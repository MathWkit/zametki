pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Window 6.8
import "scripts/Theme.js" as Palette
import "scripts/Handlers.mjs" as Handlers
import "components/main"
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "components"
import "components/editor"

Window {
    id: window
    property bool authViewVisible: false
    property string selectedItemKey: ""
    property bool sidebarVisible: true
    property bool settingsViewVisible: false
    property bool searchViewVisible: false
    property bool shareViewVisible: false
    property bool profileViewVisible: false
    property bool focusFirstBlockOnNextSnapshot: false
    property string pendingFocusBlockId: ""
    property int _focusRetries: 0

    // Robustly focus a block that may not yet exist as a delegate (the Repeater
    // recreates delegates asynchronously after a structural model change). We
    // poll a few frames until the delegate appears, then focus it.
    Timer {
        id: focusRetryTimer
        interval: 16
        repeat: true
        onTriggered: {
            if (!window.pendingFocusBlockId) { stop(); return; }
            if (window.requestFocusForBlock(window.pendingFocusBlockId)) {
                window.pendingFocusBlockId = "";
                window._focusRetries = 0;
                stop();
                return;
            }
            window._focusRetries += 1;
            if (window._focusRetries > 30) {
                window.pendingFocusBlockId = "";
                window._focusRetries = 0;
                stop();
            }
        }
    }

    function scheduleFocus(blockId) {
        window.pendingFocusBlockId = blockId;
        window._focusRetries = 0;
        // Try immediately (often the delegate already exists), then poll.
        if (window.requestFocusForBlock(blockId)) {
            window.pendingFocusBlockId = "";
            return;
        }
        focusRetryTimer.restart();
    }
    // Editor Repeater model. We deliberately do NOT bind directly to
    // AppState.blocks: a plain text edit emits blocksChanged (debounced save),
    // which would rebuild every delegate and drop the caret. Instead we refresh
    // this list only on STRUCTURAL changes (block added/removed, or a full
    // snapshot rebuild). Per-block text/state is mirrored locally in the editor
    // delegate, so skipping text-only refreshes keeps focus stable.
    property var editorBlocks: []
    property int editorBlockCount: 0

    function syncEditorBlocks(force) {
        const b = AppState.blocks;
        if (force || b.length !== window.editorBlockCount) {
            window.editorBlocks = b;
            window.editorBlockCount = b.length;
            return;
        }
        // For non-structural changes (type/level/text updates) we do NOT rebuild
        // the Repeater — that would destroy the focused delegate and lose the cursor.
        // Per-delegate Connections.onBlocksChanged() keeps type/level in sync instead.
        // We only rebuild when block IDs change (shouldn't happen without a count
        // change, but guard just in case).
        for (let i = 0; i < b.length; i++) {
            if (!window.editorBlocks[i] || window.editorBlocks[i].id !== b[i].id) {
                window.editorBlocks = b;
                window.editorBlockCount = b.length;
                return;
            }
        }
    }
    readonly property bool blockEditorEnabled: AppState.blockEditorEnabled
    readonly property real asideWidth: Math.max(width * Palette.sidebarWidthRatio, Palette.sidebarMinWidth)
    readonly property var selectedNotePathSegments: buildSelectedNotePathSegments(selectedItemKey)

    function buildSelectedNotePathSegments(itemKey) {
        if (!itemKey || (itemKey.indexOf("folder:") !== 0 && itemKey.indexOf("folder-note:") !== 0 && itemKey.indexOf("note:") !== 0)) {
            return [];
        }

        let relativeNotePath = "";
        if (itemKey.indexOf("folder:") === 0) {
            relativeNotePath = itemKey.slice("folder:".length);
        } else if (itemKey.indexOf("folder-note:") === 0) {
            relativeNotePath = itemKey.slice("folder-note:".length);
        } else {
            relativeNotePath = itemKey.slice("note:".length);
        }

        const isNoteSelection = itemKey.indexOf("folder:") !== 0;
        if (isNoteSelection && relativeNotePath.indexOf("/") === -1 && AppState.currentDocumentTitle && AppState.currentDocumentTitle.length > 0) {
            return [AppState.currentDocumentTitle];
        }

        if (!relativeNotePath) {
            return [];
        }

        const pathParts = relativeNotePath.split("/").filter(part => part.length > 0);
        if (pathParts.length === 0) {
            return [];
        }

        return pathParts;
    }

    function requestFocusForBlock(blockId) {
        if (!blockId) {
            return false;
        }
        for (let i = 0; i < editorColumn.children.length; i++) {
            const item = editorColumn.children[i];
            if (item && item.block && item.block.id === blockId && item.requestFocus) {
                item.requestFocus(true);
                return true;
            }
        }
        return false;
    }

    // Flush any pending (unsaved) text in all editor delegates, then persist
    // the current note to disk. Must be called before switching notes so that
    // the user's latest keystrokes are not lost.
    function flushAllDelegates() {
        for (let i = 0; i < editorColumn.children.length; i++) {
            const item = editorColumn.children[i];
            if (item && typeof item.flushImmediate === "function") {
                item.flushImmediate();
            }
        }
        AppState.saveDocument();
    }

    function openFolderActionPopup(mode, targetPath) {
        folderActionDialog.mode = mode;
        folderActionDialog.targetFolderPath = targetPath || "";
        folderActionDialog.open();
    }

    function positionNoteActionsPopup(globalX, globalY) {
        const overlay = Overlay.overlay;
        const margin = 6;
        const pw = noteActionsPopup.width;
        const ph = noteActionsPopup.height;

        let localX;
        let localY;

        if (globalX >= 0 && globalY >= 0) {
            const p = overlay.mapFromGlobal(globalX, globalY);
            localX = p.x;
            localY = p.y;
        } else {
            const anchor = header.mapToGlobal(header.width - pw - 8, header.height + 2);
            const p = overlay.mapFromGlobal(anchor.x, anchor.y);
            localX = p.x;
            localY = p.y;
        }

        // Flip above / left of anchor when overflowing
        if (localX + pw > overlay.width - margin) {
            localX = localX - pw;
        }
        if (localY + ph > overlay.height - margin) {
            localY = localY - ph;
        }

        localX = Math.max(margin, Math.min(localX, overlay.width - pw - margin));
        localY = Math.max(margin, Math.min(localY, overlay.height - ph - margin));

        noteActionsPopup.x = localX;
        noteActionsPopup.y = localY;
    }

    function openNoteActionsMenu(itemKey, globalX, globalY) {
        const key = Handlers.resolveActiveItemKey(AppState, itemKey, window.selectedItemKey);
        if (!key) {
            return;
        }

        noteActionsPopup.targetItemKey = key;
        noteActionsPopup.parent = Overlay.overlay;
        window.positionNoteActionsPopup(globalX, globalY);
        noteActionsPopup.open();
    }

    function menuNewNote() {
        Handlers.onNewNoteClicked(AppState);
    }

    function menuSyncNow() {
        window.flushAllDelegates();
        SyncState.syncNow();
    }

    function menuSyncAction(actionKey) {
        Handlers.onProfileSyncAction(SyncState, actionKey, window);
    }

    function menuOpenSettings() {
        Handlers.onSettingsClicked();
        window.searchViewVisible = false;
        window.shareViewVisible = false;
        window.settingsViewVisible = true;
    }

    function menuToggleSidebar() {
        window.sidebarVisible = !window.sidebarVisible;
        Handlers.onHideSidebarClicked();
    }

    function menuOpenSearch() {
        Handlers.onSearchClicked();
        window.settingsViewVisible = false;
        window.shareViewVisible = false;
        window.searchViewVisible = true;
    }

    function menuShowHelp() {
        console.log("Нажатие на Помощь и справку");
    }

    function menuShowHotkeys() {
        console.log("Нажатие на Горячие клавиши");
    }

    width: 750
    height: 480
    minimumWidth: 500
    visible: true
    title: qsTr("Заметки")

    FontLoader {
        id: interFont
        source: "qrc:/qt/qml/zametki/assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf"
    }

    Item {
        anchors.fill: parent

        Shortcut {
            sequence: "Escape"
            enabled: window.authViewVisible || window.profileViewVisible || window.shareViewVisible || window.searchViewVisible || window.settingsViewVisible
            onActivated: {
                if (window.authViewVisible) {
                    window.authViewVisible = false;
                    return;
                }
                if (window.profileViewVisible) {
                    window.profileViewVisible = false;
                    return;
                }
                if (window.shareViewVisible) {
                    window.shareViewVisible = false;
                    return;
                }
                if (window.searchViewVisible) {
                    window.searchViewVisible = false;
                    return;
                }
                if (window.settingsViewVisible) {
                    window.settingsViewVisible = false;
                }
            }
        }

        SidebarPanel {
            id: aside
            width: (!window.settingsViewVisible && window.sidebarVisible) ? window.asideWidth : 0
            visible: !window.settingsViewVisible && width > 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            fontFamily: interFont.name
            selectedItemKey: window.selectedItemKey
            folderTitles: AppState.folderTitles
            noteTitles: AppState.noteTitles
            onSearchClicked: {
                Handlers.onSearchClicked();
                window.settingsViewVisible = false;
                window.searchViewVisible = true;
                window.shareViewVisible = false;
            }
            onNewNoteClicked: {
                window.flushAllDelegates();
                window.focusFirstBlockOnNextSnapshot = true;
                Handlers.onNewNoteClicked(AppState);
            }
            onGraphClicked: {
                Handlers.onGraphClicked();
            }
            onProfileMenuItemClicked: function (actionKey) {
                switch (actionKey) {
                case "settings":
                    Handlers.onSettingsClicked();
                    window.searchViewVisible = false;
                    window.shareViewVisible = false;
                    window.settingsViewVisible = true;
                    break;
                case "profile":
                    Handlers.onProfileClicked();
                    window.searchViewVisible = false;
                    window.shareViewVisible = false;
                    window.settingsViewVisible = false;
                    window.profileViewVisible = true;
                    break;
                case "sync-status":
                    SyncState.syncNow();
                    break;
                case "help":
                    console.log("Нажатие на Помощь и справку");
                    break;
                case "hotkeys":
                    console.log("Нажатие на Горячие клавиши");
                    break;
                case "logout":
                    console.log("Нажатие на Выход");
                    break;
                default:
                    console.log("Неизвестное действие меню профиля:", actionKey);
                    break;
                }
            }
            onFolderClicked: function (folderTitle) {
                Handlers.onFolderClicked(folderTitle);
            }
            onNoteClicked: function (noteTitle) {
                window.flushAllDelegates();
                Handlers.onNoteClicked(AppState, noteTitle);
            }
            onItemSelected: function (itemKey) {
                window.selectedItemKey = itemKey;
            }
            onNoteContextMenuRequested: function (itemKey, x, y) {
                window.openNoteActionsMenu(itemKey, x, y);
            }
        }

        Item {
            id: main
            visible: !window.settingsViewVisible
            anchors.left: aside.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            MainHeaderBar {
                id: header
                anchors.left: parent.left
                anchors.right: parent.right
                fontFamily: interFont.name
                sidebarVisible: window.sidebarVisible
                notePathSegments: window.selectedNotePathSegments
                onHideSidebarClicked: {
                    window.sidebarVisible = !window.sidebarVisible;
                    Handlers.onHideSidebarClicked();
                }
                onShareClicked: {
                    Handlers.onShareClicked();
                    window.settingsViewVisible = false;
                    window.shareViewVisible = true;
                    window.searchViewVisible = false;
                }
                onFavoriteClicked: {
                    Handlers.onFavoriteClicked();
                }
                onMoreClicked: {
                    Handlers.onMoreClicked(AppState, window);
                }
            }

            Column {
                id: noteToolbar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: header.bottom
                anchors.topMargin: Palette.space2
                anchors.leftMargin: Palette.contentInset
                anchors.rightMargin: Palette.contentInset
                spacing: Palette.spacingXs

                AppInputField {
                    id: noteTitleField
                    width: parent.width
                    placeholderText: "Новая заметка"
                    font.pixelSize: Palette.fontSizeXxl
                    font.weight: Font.Bold
                    fieldFontPixelSize: Palette.fontSizeXxl
                    fieldBackgroundColor: "transparent"
                    fieldBorderColor: "transparent"
                    fieldHoverBorderColor: "transparent"
                    fieldFocusBorderColor: "transparent"
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 4
                    bottomPadding: 4

                    Binding {
                        target: noteTitleField
                        property: "text"
                        value: AppState.currentDocumentTitle && AppState.currentDocumentTitle.length > 0 ? AppState.currentDocumentTitle : "Новая заметка"
                        when: !noteTitleField.activeFocus
                    }

                    onEditingFinished: {
                        AppState.renameCurrentDocument(text)
                    }
                }

                Text {
                    width: parent.width
                    text: "# заголовок  ·  ## подзаголовок  ·  - [ ] задача  ·  Ctrl+B жирный"
                    color: Palette.textSecondary
                    font.pixelSize: Palette.fontSizeSm
                    font.family: interFont.name
                    wrapMode: Text.Wrap
                    visible: AppState.blocks.length > 0
                }
            }

            Flickable {
                id: editorScroll
                anchors.top: noteToolbar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.topMargin: Palette.space1
                clip: true
                contentWidth: width
                contentHeight: editorColumn.implicitHeight + editorTapPad.height

                ScrollBar.vertical: ScrollBar { }

                Item {
                    anchors.fill: parent
                    visible: AppState.blocks.length === 0

                    Column {
                        anchors.centerIn: parent
                        spacing: Palette.spacingSm

                        Text {
                            text: "Пока нет активной заметки"
                            color: Palette.textSecondary
                            font.pixelSize: Palette.fontSizeBase
                            horizontalAlignment: Text.AlignHCenter
                        }

                        AppActionButtonCompact {
                            text: "Создать заметку"
                            onClicked: {
                                window.focusFirstBlockOnNextSnapshot = true;
                                Handlers.onNewNoteClicked(AppState);
                            }
                        }
                    }
                }

                Column {
                    id: editorColumn
                    width: editorScroll.width - Palette.contentInset * 2
                    x: Palette.contentInset
                    spacing: 2

                    Repeater {
                        model: window.editorBlocks

                        delegate: NoteBlockEditor {
                            required property var modelData
                            required property int index
                            block: modelData
                            blockIndex: index
                            editorWidth: editorColumn.width
                            uiFontFamily: interFont.name
                            onRequestFocusNext: function (blockId) {
                                window.scheduleFocus(blockId);
                            }
                        }
                    }

                    Item {
                        id: editorTapPad
                        width: editorColumn.width
                        height: Math.max(120, editorScroll.height * 0.25)
                        visible: AppState.blocks.length > 0
                    }
                }
            }
        }

        Loader {
            id: settingsPageLoader
            anchors.fill: parent
            active: window.settingsViewVisible
            visible: window.settingsViewVisible
            source: "Settings.qml"
        }

        MainModalOverlay {
            id: searchOverlay
            visible: window.searchViewVisible && !window.settingsViewVisible
            z: 200
            source: Qt.resolvedUrl("Search.qml")

            onVisibleChanged: {
                if (!searchOverlay.visible || !searchOverlay.loadedItem) {
                    return;
                }
                Qt.callLater(function() {
                    if (searchOverlay.loadedItem && searchOverlay.loadedItem.focusQueryField) {
                        searchOverlay.loadedItem.focusQueryField();
                    }
                });
            }

            onOutsideCloseRequested: {
                window.searchViewVisible = false;
            }

            Connections {
                target: searchOverlay.loadedItem
                ignoreUnknownSignals: true

                function onCloseClicked() {
                    window.searchViewVisible = false;
                }

                function onNoteSelected(documentId) {
                    window.flushAllDelegates();
                    if (AppState.openDocument(documentId)) {
                        window.selectedItemKey = AppState.itemKeyForDocumentId(documentId);
                        window.searchViewVisible = false;
                    } else {
                        console.warn("Не удалось открыть заметку:", AppState.lastError());
                    }
                }

                function onFolderSelected(folderPath) {
                    window.selectedItemKey = "folder:" + folderPath;
                    window.searchViewVisible = false;
                }

                function onCommandSelected(commandKey) {
                    switch (commandKey) {
                    case "create-note":
                        window.flushAllDelegates();
                        window.focusFirstBlockOnNextSnapshot = true;
                        Handlers.onNewNoteClicked(AppState);
                        window.searchViewVisible = false;
                        break;
                    case "open-graph":
                        Handlers.onGraphClicked();
                        window.searchViewVisible = false;
                        break;
                    default:
                        console.warn("Неизвестная команда поиска:", commandKey);
                        break;
                    }
                }
            }
        }

        MainModalOverlay {
            id: shareOverlay
            visible: window.shareViewVisible && !window.settingsViewVisible
            z: 210
            source: Qt.resolvedUrl("Share.qml")

            onOutsideCloseRequested: {
                window.shareViewVisible = false;
            }

            Connections {
                target: shareOverlay.loadedItem
                ignoreUnknownSignals: true

                function onCloseClicked() {
                    window.shareViewVisible = false;
                }
            }
        }

        MainModalOverlay {
            id: profileOverlay
            visible: window.profileViewVisible && !window.settingsViewVisible
            z: 220
            source: Qt.resolvedUrl("Profile.qml")

            onOutsideCloseRequested: {
                window.profileViewVisible = false;
            }

            Connections {
                target: profileOverlay.loadedItem
                ignoreUnknownSignals: true

                function onCloseClicked() {
                    window.profileViewVisible = false;
                }

                function onLogoutClicked() {
                    SyncState.logout();
                    window.profileViewVisible = false;
                }

                function onAddAccountClicked() {
                    window.profileViewVisible = false;
                    window.authViewVisible = true;
                    if (authOverlay) {
                        authOverlay.mode = 0;
                    }
                }
            }
        }

        Connections {
            target: settingsPageLoader.item
            ignoreUnknownSignals: true

            function onCloseRequested() {
                window.settingsViewVisible = false;
            }
        }

        CreationBD {
            id: creationBdOverlay
            anchors.fill: parent
            visible: !AppState.databaseConfigured
            fontFamily: interFont.name
            onCreateDatabaseRequested: function (databaseName, parentDirectoryPath) {
                if (!AppState.createDatabase(databaseName, parentDirectoryPath)) {
                    creationBdOverlay.errorText = AppState.lastError();
                }
            }
        }

        AuthPage {
            id: authOverlay
            anchors.fill: parent
            visible: window.authViewVisible
            z: 9999
            fontFamily: interFont.name
            closeOnOutsideClick: !SyncState.isSyncing
            onCloseRequested: {
                window.authViewVisible = false;
            }
            onLoginRequested: function (email, password) {
                SyncState.login(email, password);
            }
            onRegisterRequested: function (name, email, password) {
                // Server uses username+password; we use the email field as username
                SyncState.registerUser(email, password);
            }
            onGoogleAuthRequested: {
                console.log("Запрос входа через Google");
            }
            onAppleAuthRequested: {
                console.log("Запрос входа через Apple");
            }

            Connections {
                target: SyncState
                function onLoginFinished(success, error) {
                    if (success) {
                        window.authViewVisible = false;
                        authOverlay.loginError = "";
                    } else {
                        authOverlay.loginError = error;
                    }
                }
                function onRegisterFinished(success, error) {
                    if (success) {
                        window.authViewVisible = false;
                        authOverlay.registerError = "";
                    } else {
                        authOverlay.registerError = error;
                    }
                }
            }
        }

        NoteActionsPopup {
            id: noteActionsPopup
            uiFontFamily: interFont.name
            onActionTriggered: function (actionKey) {
                Handlers.onNoteAction(AppState, SyncState, actionKey, noteActionsPopup.targetItemKey, window);
            }
        }

        FolderActionDialog {
            id: folderActionDialog
            uiFontFamily: interFont.name
            onSubmitted: function (value) {
                if (folderActionDialog.mode === "create") {
                    AppState.createFolder(value, folderActionDialog.targetFolderPath);
                } else if (window.selectedItemKey) {
                    window.flushAllDelegates();
                    if (AppState.moveItem(window.selectedItemKey, value)) {
                        window.selectedItemKey = AppState.currentItemKey();
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        window.syncEditorBlocks(true);
        if (window.focusFirstBlockOnNextSnapshot) {
            Qt.callLater(() => {
                if (editorColumn.children.length > 0) {
                    const firstItem = editorColumn.children[0];
                    if (firstItem && firstItem.requestFocus) {
                        firstItem.requestFocus(true);
                    }
                }
                window.focusFirstBlockOnNextSnapshot = false;
            });
        }
    }

    Connections {
        target: SyncState
        function onNoteActionFinished(noteId, action, success, error) {
            if (!success) {
                console.log("Синхронизация заметки не удалась:", action, error);
                return;
            }
            if (action === "download") {
                AppState.refreshDocumentsFromDisk();
                if (AppState.currentDocumentId === noteId) {
                    AppState.reloadDocumentFromDisk(noteId);
                    window.syncEditorBlocks(true);
                }
            }
        }
        function onSyncActionFinished(action, success, error) {
            if (!success) {
                console.log("Синхронизация не удалась:", action, error);
                return;
            }

            if (error === "nothing_on_server") {
                console.log("Синхронизация завершена:", action, "— на сервере нет заметок");
            } else if (error.indexOf("downloaded_") === 0) {
                const count = error.slice("downloaded_".length);
                console.log("Синхронизация завершена:", action, "— загружено с сервера:", count);
            } else {
                console.log("Синхронизация завершена:", action, error);
            }

            if (action === "pull_soft_all" || action === "pull_hard_all") {
                AppState.refreshDocumentsFromDisk();
                const currentId = AppState.currentDocumentId;
                if (currentId && currentId.length > 0) {
                    if (action === "pull_hard_all" || (error.indexOf("downloaded_") === 0 && error !== "downloaded_0")) {
                        AppState.reloadDocumentFromDisk(currentId);
                        window.syncEditorBlocks(true);
                    }
                }
            }
        }
        function onNotesDirectoryChanged() {
            AppState.refreshNoteTitles();
            AppState.refreshFolderTitles();
        }
    }

    Connections {
        target: AppState
        // Text-only edits emit blocksChanged with an unchanged block count — we
        // only refresh the model (rebuilding delegates) when the structure
        // actually changes, so the focused editor keeps its caret.
        function onBlocksChanged() {
            window.syncEditorBlocks(false);
        }
        function onSnapshotChanged() {
            // onBlocksChanged already handled structural rebuilds when the count
            // or ids changed; calling syncEditorBlocks(false) here avoids a
            // second redundant Repeater rebuild that would destroy the focused
            // delegate and reset cursor position.
            window.syncEditorBlocks(false);
            if (window.pendingFocusBlockId) {
                focusRetryTimer.restart();
            } else if (window.focusFirstBlockOnNextSnapshot) {
                Qt.callLater(() => {
                    if (editorColumn.children.length > 0) {
                        const firstItem = editorColumn.children[0];
                        if (firstItem && firstItem.requestFocus) {
                            firstItem.requestFocus(true);
                        }
                    }
                    window.focusFirstBlockOnNextSnapshot = false;
                });
            }
        }
    }
}
