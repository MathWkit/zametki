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
    property string folderActionMode: ""
    property string folderActionTargetPath: ""
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

    function openFolderActionPopup(mode, targetPath) {
        window.folderActionMode = mode;
        window.folderActionTargetPath = targetPath || "";
        folderPathField.text = "";
        folderActionPopup.open();
        Qt.callLater(function () {
            folderPathField.forceActiveFocus();
        });
    }

    function submitFolderAction() {
        const value = folderPathField.text.trim();
        if (!value) {
            return;
        }

        if (window.folderActionMode === "create") {
            AppState.createFolder(value, window.folderActionTargetPath);
        } else if (window.folderActionMode === "move" && window.selectedItemKey) {
            AppState.moveItem(window.selectedItemKey, value);
        }

        folderActionPopup.close();
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
                    console.log("Нажатие на Статус синхронизации");
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
                Handlers.onNoteClicked(AppState, noteTitle);
            }
            onItemSelected: function (itemKey) {
                window.selectedItemKey = itemKey;
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
                    Handlers.onMoreClicked();
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
            onOutsideCloseRequested: {
                window.searchViewVisible = false;
            }

            Connections {
                target: searchOverlay.loadedItem
                ignoreUnknownSignals: true

                function onCloseClicked() {
                    window.searchViewVisible = false;
                }
            }
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
                        model: AppState.blocks

                        delegate: NoteBlockEditor {
                            required property var modelData
                            required property int index
                            block: modelData
                            blockIndex: index
                            editorWidth: editorColumn.width
                            uiFontFamily: interFont.name
                            onRequestFocusNext: function (blockId) {
                                window.pendingFocusBlockId = blockId;
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

        Popup {
            id: folderActionPopup
            modal: true
            anchors.centerIn: parent

            contentItem: Column {
                spacing: 10
                width: 300

                Text {
                    text: window.folderActionMode === "create" ? "Введите имя папки:" : "Введите новый путь:"
                    color: Palette.textPrimary
                }

                TextField {
                    width: parent.width
                    id: folderPathField
                    placeholderText: window.folderActionMode === "create" ? "Имя папки" : "Путь"
                }

                Row {
                    spacing: 10
                    anchors.right: parent.right

                    Button {
                        text: "OK"
                        onClicked: window.submitFolderAction()
                    }

                    Button {
                        text: "Отмена"
                        onClicked: folderActionPopup.close()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
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
        target: AppState
        function onSnapshotChanged() {
            if (window.pendingFocusBlockId) {
                Qt.callLater(() => {
                    if (window.requestFocusForBlock(window.pendingFocusBlockId)) {
                        window.pendingFocusBlockId = "";
                    }
                });
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
        AuthPage {
            id: authOverlay
            anchors.fill: parent
            visible: window.authViewVisible
            z: 9999
            fontFamily: interFont.name
            closeOnOutsideClick: true
            onCloseRequested: {
                window.authViewVisible = false;
            }
            onLoginRequested: function (email, password) {
                console.log("Запрос входа:", email, "длина пароля:", password.length);
                window.authViewVisible = false;
            }
            onRegisterRequested: function (name, email, password) {
                console.log("Запрос регистрации:", name, email, "длина пароля:", password.length);
                window.authViewVisible = false;
            }
            onGoogleAuthRequested: {
                console.log("Запрос входа через Google");
                window.authViewVisible = false;
            }
            onAppleAuthRequested: {
                console.log("Запрос входа через Apple");
                window.authViewVisible = false;
            }
        }
    }
}


