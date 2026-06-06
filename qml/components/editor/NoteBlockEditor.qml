pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

Item {
    id: root

    required property var block
    required property int blockIndex
    required property real editorWidth
    property string uiFontFamily: Palette.fontFamily

    signal requestFocusNext(string blockId)

    // ── State ────────────────────────────────────────────────────────────
    property string contentDraft: ""    // text without prefix
    property bool   doneDraft:    false // todo done state
    property string syncedBlockId: ""
    // editActive is DERIVED from the editor's real focus. The editField is always
    // present (never toggled by visibility), so focus is never dropped by a model
    // refresh — exactly how the original multi-editor version stayed focused.
    readonly property bool editActive: editField.activeFocus
    property bool   anyEditorFocused: editActive  // for gutter compat
    property bool   _suppressTextChange: false     // guard recursive onTextChanged
    property int    _savedContentCursor: 0         // cursor offset within content (after prefix)
    property bool   _skipBlurFlush: false          // structural op already saved text

    width:  editorWidth
    height: blockRow.implicitHeight

    // ── Prefix helpers ───────────────────────────────────────────────────
    function blockPrefix() {
        if (block.type === "heading")  return "#".repeat(block.level || 1) + " ";
        if (block.type === "bulleted") return "- ";
        if (block.type === "todo")     return doneDraft ? "- [x] " : "- [ ] ";
        return "";
    }

    function toEditText() {
        return blockPrefix() + (contentDraft || "");
    }

    function parseEditText(text) {
        const rules = [
            { prefix: "### ", type: "heading",  level: 3, done: false },
            { prefix: "## ",  type: "heading",  level: 2, done: false },
            { prefix: "# ",   type: "heading",  level: 1, done: false },
            { prefix: "- [x] ", type: "todo",   level: 1, done: true  },
            { prefix: "- [X] ", type: "todo",   level: 1, done: true  },
            { prefix: "- [ ] ", type: "todo",   level: 1, done: false },
            { prefix: "[] ",    type: "todo",   level: 1, done: false },
        ];
        for (const rule of rules) {
            if (text.startsWith(rule.prefix)) {
                return { type: rule.type, level: rule.level, done: rule.done,
                         content: text.slice(rule.prefix.length) };
            }
        }
        return { type: "paragraph", level: 1, done: false, content: text };
    }

    function headingPx(level) {
        if (level === 1) return Math.round(Palette.fontSizeBase * 1.875);
        if (level === 2) return Math.round(Palette.fontSizeBase * 1.5);
        if (level === 3) return Math.round(Palette.fontSizeBase * 1.25);
        return Math.round(Palette.fontSizeBase * 1.1);
    }

    function blockTypeLabel() {
        if (block.type === "heading")  return "H" + (block.level || 1);
        if (block.type === "todo")     return "☐";
        if (block.type === "bulleted") return "•";
        return "T";
    }

    // ── Save timer ───────────────────────────────────────────────────────
    Timer {
        id: saveTimer
        interval: 400
        repeat: false
        onTriggered: root.flushToState()
    }

    function flushToState() {
        if (block.type === "todo") {
            AppState.updateTodoBlock(block.id, root.contentDraft, root.doneDraft);
        } else {
            AppState.replaceBlockText(block.id, root.contentDraft);
        }
    }

    function scheduleFlush() { saveTimer.restart(); }

    // ── Focus API ────────────────────────────────────────────────────────
    // Called externally (from Main.qml) to focus this block
    function requestFocus(cursorAtEnd) {
        activateEditor(cursorAtEnd !== false);
        return true;
    }

    function activateEditor(atEnd) {
        editField.forceActiveFocus();
        // onActiveFocusChanged populates prefix+content and positions the cursor
    }

    // ── Block operations ─────────────────────────────────────────────────
    function mergeWithPrevious() {
        if (blockIndex <= 0) return false;
        const prev = AppState.blocks[blockIndex - 1];
        if (!prev) return false;
        saveTimer.stop();
        AppState.replaceBlockText(prev.id, (prev.text || "") + contentDraft);
        AppState.deleteBlock(block.id);
        root.requestFocusNext(prev.id);
        return true;
    }

    function deleteEmptyBlock() {
        if (blockIndex <= 0) return false;
        const prev = AppState.blocks[blockIndex - 1];
        if (!prev) return false;
        saveTimer.stop();
        AppState.deleteBlock(block.id);
        root.requestFocusNext(prev.id);
        return true;
    }

    // ── Sync from AppState ───────────────────────────────────────────────
    onBlockChanged: {
        const isNewBlock = block.id !== syncedBlockId;
        syncedBlockId = block.id;

        // While the user is actively typing here we NEVER reassign the editor's
        // text — that is what keeps focus and the cursor stable across the
        // optimistic blocksChanged echo. Only the draft is kept in sync.
        if (editActive && !isNewBlock) {
            // type/level may have changed via popup/shortcut: keep prefix correct
            const expectedText = root.toEditText();
            if (editField.text !== expectedText) {
                const curOff = Math.max(0, editField.cursorPosition - (editField.text.length - root.contentDraft.length));
                const newPfx = root.blockPrefix();
                root._suppressTextChange = true;
                editField.text = expectedText;
                editField.cursorPosition = Math.min(newPfx.length + curOff, expectedText.length);
                root._suppressTextChange = false;
            }
            return;
        }

        // Not editing (or a brand-new block rebound to this delegate): adopt the
        // authoritative block values.
        saveTimer.stop();
        root.contentDraft = block.text || "";
        root.doneDraft = block.done === true;
    }

    Component.onCompleted: {
        syncedBlockId = block.id;
        contentDraft = block.text || "";
        doneDraft = block.done === true;
    }

    // ─────────────────────────────────────────────────────────────────────
    // POPUPS
    // ─────────────────────────────────────────────────────────────────────

    // ── Add block popup ───────────────────────────────────────────────────
    Popup {
        id: blockTypeMenu
        parent: addBlockButton
        x: addBlockButton.width + 6
        y: -(blockTypeMenuColumn.implicitHeight / 2) + addBlockButton.height / 2
        padding: 6
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: Palette.surfaceColor; radius: 8
            border.color: Palette.border; border.width: 1
        }
        Column {
            id: blockTypeMenuColumn
            spacing: 2; width: 210
            Text {
                text: "Тип блока"; color: Palette.textSecondary
                font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily
                leftPadding: 8; topPadding: 4; bottomPadding: 2
            }
            Repeater {
                model: [
                    { label: "Текст",       icon: "T",  type: "paragraph", level: 0 },
                    { label: "Заголовок 1", icon: "H1", type: "heading",   level: 1 },
                    { label: "Заголовок 2", icon: "H2", type: "heading",   level: 2 },
                    { label: "Заголовок 3", icon: "H3", type: "heading",   level: 3 },
                    { label: "Задача",      icon: "☐",  type: "todo",      level: 0 },
                    { label: "Список",      icon: "•",  type: "bulleted",  level: 0 },
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 210; height: 32; radius: 6
                    color: addMenuMouse.containsMouse ? Palette.hover : "transparent"
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 8; spacing: 10
                        Text { text: modelData.icon; color: Palette.textSecondary; font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily; font.bold: true; width: 22; horizontalAlignment: Text.AlignHCenter }
                        Text { text: modelData.label; color: Palette.textPrimary; font.pixelSize: Palette.fontSizeBase; font.family: root.uiFontFamily }
                    }
                    MouseArea {
                        id: addMenuMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            blockTypeMenu.close();
                            const newId = AppState.insertBlockAfter(root.block.id, modelData.type);
                            if (newId && modelData.type === "heading" && modelData.level > 0)
                                AppState.convertBlockType(newId, "heading", modelData.level, false);
                            if (newId) root.requestFocusNext(newId);
                        }
                    }
                }
            }
        }
    }

    // ── Change type popup ─────────────────────────────────────────────────
    Popup {
        id: changeTypeMenu
        parent: blockTypeBadgeBtn
        x: blockTypeBadgeBtn.width + 4
        y: -(changeTypeMenuColumn.implicitHeight / 2) + blockTypeBadgeBtn.height / 2
        padding: 6
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: Palette.surfaceColor; radius: 8
            border.color: Palette.border; border.width: 1
        }
        Column {
            id: changeTypeMenuColumn
            spacing: 2; width: 210
            Text {
                text: "Изменить тип"; color: Palette.textSecondary
                font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily
                leftPadding: 8; topPadding: 4; bottomPadding: 2
            }
            Repeater {
                model: [
                    { label: "Текст",       icon: "T",  type: "paragraph", level: 0 },
                    { label: "Заголовок 1", icon: "H1", type: "heading",   level: 1 },
                    { label: "Заголовок 2", icon: "H2", type: "heading",   level: 2 },
                    { label: "Заголовок 3", icon: "H3", type: "heading",   level: 3 },
                    { label: "Задача",      icon: "☐",  type: "todo",      level: 0 },
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 210; height: 32; radius: 6
                    property bool isCurrent: (modelData.type === root.block.type) &&
                                             (modelData.type !== "heading" || modelData.level === (root.block.level || 1))
                    color: isCurrent ? Palette.selected : (chgMenuMouse.containsMouse ? Palette.hover : "transparent")
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 8; spacing: 10
                        Text { text: modelData.icon; color: parent.parent.isCurrent ? Palette.textPrimary : Palette.textSecondary; font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily; font.bold: true; width: 22; horizontalAlignment: Text.AlignHCenter }
                        Text { text: modelData.label; color: parent.parent.isCurrent ? Palette.textPrimary : Palette.textSecondary; font.pixelSize: Palette.fontSizeBase; font.family: root.uiFontFamily; font.bold: parent.parent.isCurrent }
                    }
                    MouseArea {
                        id: chgMenuMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            changeTypeMenu.close();
                            const lvl = modelData.level > 0 ? modelData.level : 1;
                            AppState.convertBlockType(root.block.id, modelData.type, lvl, root.block.done === true);
                        }
                    }
                }
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────
    // LAYOUT
    // ─────────────────────────────────────────────────────────────────────
    Row {
        id: blockRow
        width: parent.width
        spacing: 2

        HoverHandler { id: blockHover }

        // ── Gutter ────────────────────────────────────────────────────────
        Item {
            id: addBlockGutter
            property bool showControls: false
            width: 0
            height: Math.max(28, contentArea.implicitHeight)
            Behavior on width { NumberAnimation { duration: 100 } }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 2
                opacity: addBlockGutter.showControls ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 120 } }

                Rectangle {
                    id: blockTypeBadgeBtn
                    width: 26; height: 22; radius: 4
                    color: badgeMouse.containsMouse ? Palette.hover : "transparent"
                    Text { anchors.centerIn: parent; text: root.blockTypeLabel(); font.pixelSize: 10; font.weight: Font.Bold; font.family: root.uiFontFamily; color: Palette.textSecondary }
                    MouseArea { id: badgeMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: changeTypeMenu.open() }
                }
                Rectangle {
                    id: addBlockButton
                    width: 22; height: 22; radius: 4
                    color: addMouse.containsMouse ? Palette.hover : "transparent"
                    Text { anchors.centerIn: parent; text: "+"; font.pixelSize: Palette.fontSizeLg; font.weight: Font.Medium; color: Palette.textSecondary }
                    MouseArea { id: addMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: blockTypeMenu.open() }
                }
            }
        }

        // ── Content area ──────────────────────────────────────────────────
        Item {
            id: contentArea
            width: blockRow.width - addBlockGutter.width
            implicitHeight: editField.activeFocus ? editField.implicitHeight : displayLayer.implicitHeight

            // ── Edit field (ALWAYS present — declared first so it sits BELOW the
            //    display overlay). Never visibility-toggled, so a model refresh
            //    can never strip its focus. Shows raw prefix + content when focused,
            //    empty otherwise (hidden behind the overlay). ──────────────────
            TextEdit {
                id: editField
                width: parent.width
                leftPadding: 2; rightPadding: 2; topPadding: 4; bottomPadding: 4
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.PlainText
                font.family: root.uiFontFamily
                font.pixelSize: Palette.fontSizeBase
                color: Palette.textPrimary
                selectByMouse: true
                selectionColor: Palette.selected
                selectedTextColor: Palette.textPrimary

                onActiveFocusChanged: {
                    if (activeFocus) {
                        root._skipBlurFlush = false;
                        // Populate with prefix + content
                        root._suppressTextChange = true;
                        text = root.toEditText();
                        root._suppressTextChange = false;
                        // Restore cursor at saved content offset (or end if new focus)
                        const pLen = root.blockPrefix().length;
                        cursorPosition = pLen + Math.min(root._savedContentCursor, root.contentDraft.length);
                        root._savedContentCursor = 0;
                    } else {
                        // Structural ops (Enter / merge / delete) already wrote the
                        // authoritative text, so don't let the blur overwrite it.
                        if (root._skipBlurFlush) {
                            root._skipBlurFlush = false;
                        } else {
                            const parsed = root.parseEditText(text);
                            root.contentDraft = parsed.content;
                            root.doneDraft    = parsed.done;
                            saveTimer.stop();
                            root.flushToState();
                        }
                        root._suppressTextChange = true;
                        text = "";   // hide behind the styled overlay
                        root._suppressTextChange = false;
                    }
                }

                onTextChanged: {
                    if (!activeFocus || root._suppressTextChange) return;

                    const parsed = root.parseEditText(text);

                    const prevType  = root.block.type;
                    const prevLevel = root.block.level || 1;
                    const prevDone  = root.doneDraft;

                    root.contentDraft = parsed.content;
                    if (parsed.type === "todo") root.doneDraft = parsed.done;

                    const typeChanged  = parsed.type  !== prevType;
                    const levelChanged = prevType === "heading" && parsed.level !== prevLevel;
                    const doneChanged  = prevType === "todo"    && parsed.done  !== prevDone;

                    if (typeChanged || levelChanged || doneChanged) {
                        saveTimer.stop();
                        // Save cursor position in content space before focus is lost
                        root._savedContentCursor = Math.max(0, editField.cursorPosition - root.blockPrefix().length);
                        AppState.convertBlockType(root.block.id, parsed.type, parsed.level, parsed.done);
                        // Re-request focus: convertBlockType causes Repeater to update the
                        // delegate which may lose activeFocus. The async path via
                        // requestFocusNext / snapshotChanged restores it correctly.
                        root.requestFocusNext(root.block.id);
                        return;
                    }

                    root.scheduleFlush();
                }

                Keys.onPressed: function(event) {
                    const prefixLen = root.blockPrefix().length;

                    // ── Enter ──────────────────────────────────────────────
                    if (event.key === Qt.Key_Return) {
                        if (event.modifiers & Qt.ShiftModifier) return;
                        event.accepted = true;
                        saveTimer.stop();

                        const contentPos = Math.max(0, editField.cursorPosition - prefixLen);
                        const before = root.contentDraft.slice(0, contentPos);
                        const after  = root.contentDraft.slice(contentPos);

                        // We've computed the split — don't let the upcoming blur
                        // re-flush the stale full editor text over `before`.
                        root.contentDraft = before;
                        root._skipBlurFlush = true;

                        // Empty heading → convert to paragraph first
                        if (root.contentDraft.length === 0 && root.block.type === "heading") {
                            AppState.convertBlockType(root.block.id, "paragraph", 1, false);
                        }

                        AppState.replaceBlockText(root.block.id, before);
                        const contType = (root.block.type === "heading") ? "paragraph" : root.block.type;
                        const newId = AppState.insertBlockAfter(root.block.id, contType);
                        if (newId && after.length > 0) AppState.replaceBlockText(newId, after);
                        if (newId) root.requestFocusNext(newId);
                        return;
                    }

                    // ── Backspace at position 0 (before any prefix) ───────────
                    if (event.key === Qt.Key_Backspace &&
                        editField.selectionStart === editField.selectionEnd &&
                        editField.cursorPosition === 0) {
                        event.accepted = true;
                        root._skipBlurFlush = true;
                        if (root.contentDraft.length === 0 && root.block.type === "paragraph") {
                            root.deleteEmptyBlock();
                        } else {
                            root.mergeWithPrevious();
                        }
                        return;
                    }

                    // ── Ctrl+Shift type shortcuts ──────────────────────────
                    if ((event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier)) {
                        if      (event.key === Qt.Key_1) { event.accepted = true; AppState.convertBlockType(root.block.id, "heading",   1, false); }
                        else if (event.key === Qt.Key_2) { event.accepted = true; AppState.convertBlockType(root.block.id, "heading",   2, false); }
                        else if (event.key === Qt.Key_3) { event.accepted = true; AppState.convertBlockType(root.block.id, "heading",   3, false); }
                        else if (event.key === Qt.Key_0) { event.accepted = true; AppState.convertBlockType(root.block.id, "paragraph", 1, false); }
                    }
                }
            }

            // ── Display overlay (styled, shown when not focused; on TOP of
            //    editField so its empty text stays hidden). Clicking focuses
            //    the editField. ──────────────────────────────────────────────
            Item {
                id: displayLayer
                visible: !editField.activeFocus
                width: parent.width
                height: displayContent.implicitHeight
                implicitHeight: displayContent.implicitHeight

                // Full-width click target (declared first → sits beneath the text
                // MouseAreas) so empty blocks can still be clicked to focus.
                MouseArea { anchors.fill: parent; onClicked: root.activateEditor(true) }

                // Paragraph
                Text {
                    id: paraDisplay
                    visible: block.type === "paragraph"
                    width: parent.width
                    text: root.contentDraft
                    wrapMode: Text.Wrap
                    font.family: root.uiFontFamily; font.pixelSize: Palette.fontSizeBase
                    color: Palette.textPrimary
                    leftPadding: 2; rightPadding: 2; topPadding: 4; bottomPadding: 4
                    MouseArea { anchors.fill: parent; onClicked: root.activateEditor(true) }
                }

                // Heading
                Text {
                    id: headDisplay
                    visible: block.type === "heading"
                    width: parent.width
                    text: root.contentDraft
                    wrapMode: Text.Wrap
                    font.family: root.uiFontFamily; font.bold: true
                    font.pixelSize: root.headingPx(block.level || 1)
                    color: Palette.textPrimary
                    leftPadding: 2; rightPadding: 2; topPadding: 6; bottomPadding: 6
                    MouseArea { anchors.fill: parent; onClicked: root.activateEditor(true) }
                }

                // Todo
                RowLayout {
                    id: todoDisplay
                    visible: block.type === "todo"
                    width: parent.width; spacing: Palette.spacingSm
                    AppSwitch {
                        id: todoSwitch
                        checked: root.doneDraft
                        onToggled: {
                            root.doneDraft = checked;
                            saveTimer.stop();
                            root.flushToState();
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: root.contentDraft; wrapMode: Text.Wrap
                        font.family: root.uiFontFamily; font.pixelSize: Palette.fontSizeBase
                        color: root.doneDraft ? Palette.textSecondary : Palette.textPrimary
                        font.strikeout: root.doneDraft
                        leftPadding: 2; rightPadding: 2; topPadding: 4; bottomPadding: 4
                        MouseArea { anchors.fill: parent; onClicked: root.activateEditor(true) }
                    }
                }

                // Invisible item used for implicitHeight calculation
                Item {
                    id: displayContent
                    width: parent.width
                    implicitHeight: paraDisplay.visible ? paraDisplay.implicitHeight
                                  : headDisplay.visible ? headDisplay.implicitHeight
                                  : todoDisplay.visible ? todoDisplay.implicitHeight
                                  : 28
                }
            }
        }
    }
}
