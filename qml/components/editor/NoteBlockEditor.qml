pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

Item {
    id: root

    required property var    block
    required property int    blockIndex
    required property real   editorWidth
    property  string         uiFontFamily: Palette.fontFamily

    signal requestFocusNext(string blockId)

    // ── Local state (NOT directly bound to block props) ───────────────────
    // These are the source of truth for the current editing session.
    // They are synced from `block` only when: (a) a different block is
    // assigned to this delegate, or (b) we are not focused.
    property string blockType:  "paragraph"
    property int    blockLevel: 1
    property string contentDraft: ""
    property bool   doneDraft:    false

    // Internal
    property string _syncedId:           ""
    property bool   _suppressTextChange: false
    property bool   _skipBlurFlush:      false

    width:  editorWidth
    height: blockRow.implicitHeight

    // ─────────────────────────────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────────────────────────────
    function headingPx(level) {
        if (level === 1) return Math.round(Palette.fontSizeBase * 1.875)
        if (level === 2) return Math.round(Palette.fontSizeBase * 1.5)
        if (level === 3) return Math.round(Palette.fontSizeBase * 1.25)
        return Palette.fontSizeBase
    }

    function numberedOrdinal() {
        let n = 1
        for (let i = blockIndex - 1; i >= 0; i--) {
            const b = AppState.blocks[i]
            if (b && b.type === "numbered") n++
            else break
        }
        return n
    }

    function blockTypeLabel() {
        if (root.blockType === "heading")  return "H" + root.blockLevel
        if (root.blockType === "todo")     return "☐"
        if (root.blockType === "bulleted") return "•"
        if (root.blockType === "numbered") return "1."
        if (root.blockType === "quote")    return "❝"
        if (root.blockType === "code")     return "</>"
        if (root.blockType === "divider")  return "—"
        return "T"
    }

    // Detect a markdown-style prefix at the start of `text` and, if the
    // resulting block type differs from the current one, strip the prefix,
    // flush the new content, and trigger a type conversion.
    // Returns true when a conversion was initiated.
    function checkAndApplyPrefix(text) {
        const rules = [
            { prefix: "### ", type: "heading",  level: 3, done: false },
            { prefix: "## ",  type: "heading",  level: 2, done: false },
            { prefix: "# ",   type: "heading",  level: 1, done: false },
            { prefix: "- [x] ", type: "todo",   level: 1, done: true  },
            { prefix: "- [X] ", type: "todo",   level: 1, done: true  },
            { prefix: "- [ ] ", type: "todo",   level: 1, done: false },
            { prefix: "* [x] ", type: "todo",   level: 1, done: true  },
            { prefix: "* [ ] ", type: "todo",   level: 1, done: false },
            { prefix: "[ ] ",   type: "todo",   level: 1, done: false },
            { prefix: "``` ",   type: "code",   level: 1, done: false },
            { prefix: "> ",     type: "quote",  level: 1, done: false },
            { prefix: "- ",     type: "bulleted", level: 1, done: false },
            { prefix: "* ",     type: "bulleted", level: 1, done: false },
            { prefix: "+ ",     type: "bulleted", level: 1, done: false },
        ]

        // Divider: whole line is --- / *** / ___
        if (text === "---" || text === "***" || text === "___") {
            if (root.blockType !== "divider") {
                root.contentDraft = ""
                root._skipBlurFlush = true
                AppState.replaceBlockText(block.id, "")
                AppState.convertBlockType(block.id, "divider", 1, false)
                root.requestFocusNext(block.id)
            }
            return true
        }

        // Numbered list: "1. " … "99. "
        const numMatch = /^(\d+)\.\s/.exec(text)
        if (numMatch) {
            const content = text.slice(numMatch[0].length)
            if (root.blockType !== "numbered") {
                root.contentDraft = content
                root._suppressTextChange = true
                editField.text = content
                editField.cursorPosition = content.length
                root._suppressTextChange = false
                AppState.replaceBlockText(block.id, content)
                AppState.convertBlockType(block.id, "numbered", 1, false)
            }
            return true
        }

        for (const rule of rules) {
            if (text.startsWith(rule.prefix)) {
                const content = text.slice(rule.prefix.length)
                const needsConvert = (root.blockType !== rule.type) ||
                                     (rule.type === "heading" && root.blockLevel !== rule.level) ||
                                     (rule.type === "todo"    && root.doneDraft   !== rule.done)
                if (needsConvert) {
                    root.contentDraft = content
                    if (rule.type === "todo") root.doneDraft = rule.done
                    root._suppressTextChange = true
                    editField.text = content
                    editField.cursorPosition = content.length
                    root._suppressTextChange = false
                    AppState.replaceBlockText(block.id, content)
                    AppState.convertBlockType(block.id, rule.type, rule.level, rule.done)
                }
                return true
            }
        }
        return false
    }

    // ─────────────────────────────────────────────────────────────────────
    // SAVE LOGIC
    // ─────────────────────────────────────────────────────────────────────
    Timer {
        id: saveTimer
        interval: 500
        repeat: false
        onTriggered: root.flushToState()
    }

    function flushToState() {
        saveTimer.stop()
        if (root.blockType === "todo") {
            AppState.updateTodoBlock(block.id, root.contentDraft, root.doneDraft)
        } else {
            AppState.replaceBlockText(block.id, root.contentDraft)
        }
    }

    // Public method called from Main.qml before switching notes.
    function flushImmediate() {
        if (!root._skipBlurFlush) {
            flushToState()
        }
    }

    function scheduleFlush() { saveTimer.restart() }

    // Safety net: flush on delegate destruction (e.g. Repeater rebuild).
    Component.onDestruction: {
        if (!root._skipBlurFlush) {
            saveTimer.stop()
            // Call synchronously. AppState is still valid here.
            if (root.blockType === "todo") {
                AppState.updateTodoBlock(block.id, root.contentDraft, root.doneDraft)
            } else {
                AppState.replaceBlockText(block.id, root.contentDraft)
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────
    // FOCUS API
    // ─────────────────────────────────────────────────────────────────────
    function requestFocus(atEnd) {
        editField.forceActiveFocus()
        if (atEnd !== false) {
            Qt.callLater(function() {
                editField.cursorPosition = editField.length
            })
        }
        return true
    }

    // ─────────────────────────────────────────────────────────────────────
    // BLOCK SYNCHRONISATION
    // ─────────────────────────────────────────────────────────────────────

    // Keep local type/level in sync with in-place updates from C++.
    // This fires after convertBlockType emits blocksChanged (with fixed bridge).
    Connections {
        target: AppState
        function onBlocksChanged() {
            if (!editField.activeFocus) return
            const blocks = AppState.blocks
            for (const b of blocks) {
                if (b.id === root.block.id) {
                    if (root.blockType !== (b.type || "paragraph")) {
                        root.blockType = b.type || "paragraph"
                    }
                    if (root.blockLevel !== (b.level || 1)) {
                        root.blockLevel = b.level || 1
                    }
                    break
                }
            }
        }
    }

    onBlockChanged: {
        const isNew = block.id !== root._syncedId
        root._syncedId = block.id

        if (isNew) {
            // Completely different block – full sync
            saveTimer.stop()
            root.blockType    = block.type  || "paragraph"
            root.blockLevel   = block.level || 1
            root.doneDraft    = block.done  === true
            root.contentDraft = block.text  || ""
            root._suppressTextChange = true
            editField.text = root.contentDraft
            root._suppressTextChange = false
        } else if (!editField.activeFocus) {
            // Same block, not being edited – adopt authoritative values
            root.blockType    = block.type  || "paragraph"
            root.blockLevel   = block.level || 1
            root.doneDraft    = block.done  === true
            const fresh = block.text || ""
            if (root.contentDraft !== fresh) {
                root.contentDraft = fresh
                root._suppressTextChange = true
                editField.text = fresh
                root._suppressTextChange = false
            }
        } else {
            // Same block, currently focused – only update metadata
            root.blockType  = block.type  || "paragraph"
            root.blockLevel = block.level || 1
        }
    }

    Component.onCompleted: {
        root._syncedId    = block.id
        root.blockType    = block.type  || "paragraph"
        root.blockLevel   = block.level || 1
        root.contentDraft = block.text  || ""
        root.doneDraft    = block.done  === true
        root._suppressTextChange = true
        editField.text = root.contentDraft
        root._suppressTextChange = false
    }

    // ─────────────────────────────────────────────────────────────────────
    // POPUPS
    // ─────────────────────────────────────────────────────────────────────
    readonly property list<var> _blockMenuItems: [
        { label: "Текст",                   icon: "T",   type: "paragraph", level: 0 },
        { label: "Заголовок 1",             icon: "H1",  type: "heading",   level: 1 },
        { label: "Заголовок 2",             icon: "H2",  type: "heading",   level: 2 },
        { label: "Заголовок 3",             icon: "H3",  type: "heading",   level: 3 },
        { label: "Задача",                  icon: "☐",   type: "todo",      level: 0 },
        { label: "Маркированный список",    icon: "•",   type: "bulleted",  level: 0 },
        { label: "Нумерованный список",     icon: "1.",  type: "numbered",  level: 0 },
        { label: "Цитата",                  icon: "❝",   type: "quote",     level: 0 },
        { label: "Код",                     icon: "</>", type: "code",      level: 0 },
        { label: "Разделитель",             icon: "—",   type: "divider",   level: 0 },
    ]

    Popup {
        id: blockTypeMenu
        parent: addBlockBtn
        x: addBlockBtn.width + 6
        y: -(blockMenuCol.implicitHeight / 2) + addBlockBtn.height / 2
        padding: 6
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: Palette.surfaceColor; radius: 8
            border.color: Palette.border; border.width: 1
        }
        Column {
            id: blockMenuCol
            spacing: 2; width: 210
            Text {
                text: "Тип блока"; color: Palette.textSecondary
                font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily
                leftPadding: 8; topPadding: 4; bottomPadding: 2
            }
            Repeater {
                model: root._blockMenuItems
                delegate: Rectangle {
                    required property var modelData
                    width: 210; height: 32; radius: 6
                    color: bm.containsMouse ? Palette.hover : "transparent"
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 8; spacing: 10
                        Text { text: modelData.icon; color: Palette.textSecondary; font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily; font.bold: true; width: 22; horizontalAlignment: Text.AlignHCenter }
                        Text { text: modelData.label; color: Palette.textPrimary; font.pixelSize: Palette.fontSizeBase; font.family: root.uiFontFamily }
                    }
                    MouseArea {
                        id: bm; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            blockTypeMenu.close()
                            const lvl = modelData.level > 0 ? modelData.level : 1
                            const newId = AppState.insertBlockAfter(root.block.id, modelData.type)
                            if (newId && modelData.type === "heading" && modelData.level > 0)
                                AppState.convertBlockType(newId, "heading", modelData.level, false)
                            if (newId) root.requestFocusNext(newId)
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: changeTypeMenu
        parent: typeBadgeBtn
        x: typeBadgeBtn.width + 4
        y: -(changeMenuCol.implicitHeight / 2) + typeBadgeBtn.height / 2
        padding: 6
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            color: Palette.surfaceColor; radius: 8
            border.color: Palette.border; border.width: 1
        }
        Column {
            id: changeMenuCol
            spacing: 2; width: 210
            Text {
                text: "Изменить тип"; color: Palette.textSecondary
                font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily
                leftPadding: 8; topPadding: 4; bottomPadding: 2
            }
            Repeater {
                model: root._blockMenuItems
                delegate: Rectangle {
                    required property var modelData
                    width: 210; height: 32; radius: 6
                    property bool isCurrent: (modelData.type === root.blockType) &&
                                             (modelData.type !== "heading" || modelData.level === root.blockLevel)
                    color: isCurrent ? Palette.selected : (cm.containsMouse ? Palette.hover : "transparent")
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 8; spacing: 10
                        Text { text: modelData.icon; color: parent.parent.isCurrent ? Palette.textPrimary : Palette.textSecondary; font.pixelSize: Palette.fontSizeSm; font.family: root.uiFontFamily; font.bold: true; width: 22; horizontalAlignment: Text.AlignHCenter }
                        Text { text: modelData.label; color: parent.parent.isCurrent ? Palette.textPrimary : Palette.textSecondary; font.pixelSize: Palette.fontSizeBase; font.family: root.uiFontFamily; font.bold: parent.parent.isCurrent }
                    }
                    MouseArea {
                        id: cm; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            changeTypeMenu.close()
                            const lvl = modelData.level > 0 ? modelData.level : 1
                            AppState.convertBlockType(root.block.id, modelData.type, lvl, root.doneDraft)
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
        spacing: 0

        HoverHandler { id: blockHover }

        // ── Gutter (hover controls) ───────────────────────────────────────
        Item {
            id: gutter
            width: 52
            height: Math.max(28, contentArea.implicitHeight)

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                opacity: blockHover.hovered ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 120 } }

                Rectangle {
                    id: typeBadgeBtn
                    width: 24; height: 22; radius: 4
                    color: tbMouse.containsMouse ? Palette.hover : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: root.blockTypeLabel()
                        font.pixelSize: 10; font.weight: Font.Bold
                        font.family: root.uiFontFamily
                        color: Palette.textSecondary
                    }
                    MouseArea { id: tbMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: changeTypeMenu.open() }
                }

                Rectangle {
                    id: addBlockBtn
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
            width: blockRow.width - gutter.width
            implicitHeight: innerRow.implicitHeight

            // Full-width click target so empty blocks are focusable
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    editField.forceActiveFocus()
                    editField.cursorPosition = editField.positionAt(mouseX - innerRow.x, mouseY)
                }
            }

            Row {
                id: innerRow
                width: parent.width
                spacing: Palette.spacingSm

                // ── Left indicator ────────────────────────────────────────
                Item {
                    id: leftIndicator
                    width:   root.blockType === "quote"    ? 10
                           : root.blockType === "bulleted" ? 20
                           : root.blockType === "numbered" ? 28
                           : 0
                    height: Math.max(editField.implicitHeight, 20)
                    visible: width > 0

                    // Quote bar
                    Rectangle {
                        visible: root.blockType === "quote"
                        width: 3; height: parent.height - 6; radius: 2
                        color: Palette.border
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 3
                    }
                    // Bullet
                    Text {
                        visible: root.blockType === "bulleted"
                        text: "•"; color: Palette.textPrimary
                        font.family: root.uiFontFamily; font.pixelSize: Palette.fontSizeBase
                        anchors.centerIn: parent
                        topPadding: 4
                    }
                    // Number
                    Text {
                        visible: root.blockType === "numbered"
                        text: root.numberedOrdinal() + "."
                        color: Palette.textSecondary
                        font.family: root.uiFontFamily; font.pixelSize: Palette.fontSizeBase
                        anchors.right: parent.right
                        topPadding: 4
                    }
                }

                // ── Todo checkbox ─────────────────────────────────────────
                AppSwitch {
                    id: todoSwitch
                    visible: root.blockType === "todo"
                    checked: root.doneDraft
                    anchors.verticalCenter: editField.verticalCenter
                    onToggled: {
                        root.doneDraft = checked
                        saveTimer.stop()
                        AppState.updateTodoBlock(block.id, root.contentDraft, root.doneDraft)
                    }
                }

                // ── Main editor ───────────────────────────────────────────
                // For code blocks: wrapped in a styled Rectangle
                Rectangle {
                    id: codeWrap
                    visible: root.blockType === "code"
                    width: parent.width
                           - leftIndicator.width
                           - (leftIndicator.visible ? Palette.spacingSm : 0)
                    height: editField.implicitHeight + 12
                    radius: 6
                    color: Palette.surfaceColor
                    border.color: Palette.border; border.width: 1
                }

                // Divider (no TextEdit)
                Item {
                    visible: root.blockType === "divider"
                    width: parent.width
                           - leftIndicator.width
                           - (leftIndicator.visible ? Palette.spacingSm : 0)
                    height: 24
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width; height: 1
                        color: Palette.border
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: editField.forceActiveFocus()
                    }
                }

                TextEdit {
                    id: editField

                    // Width depends on block type
                    width: {
                        let w = innerRow.width
                        if (leftIndicator.visible)      w -= leftIndicator.width + Palette.spacingSm
                        if (root.blockType === "todo")  w -= todoSwitch.width + Palette.spacingSm
                        if (root.blockType === "divider") w = 0
                        return Math.max(0, w)
                    }
                    visible: root.blockType !== "divider"

                    leftPadding:   root.blockType === "code" ? 8 : 2
                    rightPadding:  root.blockType === "code" ? 8 : 2
                    topPadding:    root.blockType === "heading" ? 6
                                 : root.blockType === "code" ? 8 : 4
                    bottomPadding: root.blockType === "heading" ? 6
                                 : root.blockType === "code" ? 8 : 4

                    wrapMode:       TextEdit.Wrap
                    textFormat:     TextEdit.PlainText
                    selectByMouse:  true
                    selectionColor: Palette.selected
                    selectedTextColor: Palette.textPrimary

                    // Dynamic font / colour based on block type
                    font.family:    root.blockType === "code" ? "monospace" : root.uiFontFamily
                    font.pixelSize: root.blockType === "heading"
                                    ? root.headingPx(root.blockLevel)
                                    : Palette.fontSizeBase
                    font.bold:      root.blockType === "heading"
                    font.italic:    root.blockType === "quote"
                    font.strikeout: root.blockType === "todo" && root.doneDraft
                    color:          (root.blockType === "quote")                     ? Palette.textSecondary
                                  : (root.blockType === "todo" && root.doneDraft)    ? Palette.textSecondary
                                  : Palette.textPrimary

                    // Placeholder
                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: editField.leftPadding
                        anchors.topMargin:  editField.topPadding
                        visible: editField.text.length === 0 && !editField.activeFocus
                        text: root.blockType === "heading"  ? "Заголовок"
                            : root.blockType === "quote"    ? "Цитата"
                            : root.blockType === "code"     ? "Код"
                            : root.blockType === "todo"     ? "Задача"
                            : root.blockType === "divider"  ? ""
                            : "Текст"
                        color: Palette.textSecondary
                        opacity: 0.5
                        font:    editField.font
                        wrapMode: Text.Wrap
                    }

                    // ── Text change ───────────────────────────────────────
                    onTextChanged: {
                        if (root._suppressTextChange) return
                        if (!activeFocus) return

                        // Check for markdown prefix trigger (only when text
                        // begins with a recognised prefix character)
                        const firstChar = text.length > 0 ? text[0] : ""
                        if ("#->*+[`".includes(firstChar) || /^\d/.test(text)) {
                            if (root.checkAndApplyPrefix(text)) return
                        }

                        root.contentDraft = text
                        root.scheduleFlush()
                    }

                    // ── Focus ─────────────────────────────────────────────
                    onActiveFocusChanged: {
                        if (!activeFocus) {
                            if (!root._skipBlurFlush) {
                                root.contentDraft = text
                                root.flushToState()
                            }
                            root._skipBlurFlush = false
                        }
                    }

                    // ── Keys ──────────────────────────────────────────────
                    Keys.onPressed: function(event) {
                        // Enter → split block
                        if (event.key === Qt.Key_Return && !(event.modifiers & Qt.ShiftModifier)) {
                            event.accepted = true
                            saveTimer.stop()

                            const pos    = cursorPosition
                            const before = root.contentDraft.slice(0, pos)
                            const after  = root.contentDraft.slice(pos)

                            root.contentDraft   = before
                            root._skipBlurFlush = true

                            // Empty heading → collapse to paragraph
                            if (before.length === 0 && root.blockType === "heading") {
                                AppState.convertBlockType(block.id, "paragraph", 1, false)
                            }

                            AppState.replaceBlockText(block.id, before)

                            const contType = (root.blockType === "heading" || root.blockType === "divider")
                                             ? "paragraph" : root.blockType
                            const newId = AppState.insertBlockAfter(block.id, contType)
                            if (newId && after.length > 0)
                                AppState.replaceBlockText(newId, after)
                            if (newId)
                                root.requestFocusNext(newId)
                            return
                        }

                        // Backspace at position 0
                        if (event.key === Qt.Key_Backspace &&
                            selectionStart === selectionEnd &&
                            cursorPosition === 0) {
                            event.accepted = true
                            root._skipBlurFlush = true

                            if (root.contentDraft.length === 0 && root.blockType === "paragraph") {
                                // Delete empty paragraph
                                if (blockIndex <= 0) return
                                const prev = AppState.blocks[blockIndex - 1]
                                if (!prev) return
                                saveTimer.stop()
                                AppState.deleteBlock(block.id)
                                root.requestFocusNext(prev.id)
                            } else if (root.blockType !== "paragraph") {
                                // Convert non-paragraph to paragraph (remove type)
                                saveTimer.stop()
                                AppState.convertBlockType(block.id, "paragraph", 1, false)
                                root.requestFocusNext(block.id)
                            } else {
                                // Merge with previous block
                                if (blockIndex <= 0) return
                                const prevBlock = AppState.blocks[blockIndex - 1]
                                if (!prevBlock) return
                                saveTimer.stop()
                                const mergedText = (prevBlock.text || "") + root.contentDraft
                                AppState.replaceBlockText(prevBlock.id, mergedText)
                                AppState.deleteBlock(block.id)
                                root.requestFocusNext(prevBlock.id)
                            }
                            return
                        }

                        // Ctrl+Shift+0/1/2/3 — type shortcuts
                        if ((event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier)) {
                            if      (event.key === Qt.Key_1) { event.accepted = true; AppState.convertBlockType(block.id, "heading",   1, false) }
                            else if (event.key === Qt.Key_2) { event.accepted = true; AppState.convertBlockType(block.id, "heading",   2, false) }
                            else if (event.key === Qt.Key_3) { event.accepted = true; AppState.convertBlockType(block.id, "heading",   3, false) }
                            else if (event.key === Qt.Key_0) { event.accepted = true; AppState.convertBlockType(block.id, "paragraph", 1, false) }
                        }
                    }
                }
            }
        }
    }
}
