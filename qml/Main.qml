pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Window 6.8
import "scripts/Theme.js" as Palette
import "scripts/Handlers.mjs" as Handlers

Window {
    id: window
    property bool authenticated: false
    property bool useDarkAuthTheme: false
    property string selectedItemKey: ""
    property bool sidebarVisible: true
    property bool settingsViewVisible: false
    property bool searchViewVisible: false
    property bool shareViewVisible: false
    property bool profileViewVisible: false
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

        if (!relativeNotePath) {
            return [];
        }

        const pathParts = relativeNotePath.split("/").filter(part => part.length > 0);
        if (pathParts.length === 0) {
            return [];
        }

        return pathParts;
    }

    width: 750
    height: 480
    minimumWidth: 500
    visible: true
    title: qsTr("Hello World")

    FontLoader {
        id: interFont
        source: "qrc:/qt/qml/zametki/assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf"
    }

    Item {
        anchors.fill: parent

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
                Handlers.onNoteClicked(noteTitle);
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
        }

        Loader {
            id: settingsPageLoader
            anchors.fill: parent
            active: window.settingsViewVisible
            visible: window.settingsViewVisible
            source: "Settings.qml"
        }

        Rectangle {
            id: searchOverlay
            anchors.fill: parent
            visible: window.searchViewVisible && !window.settingsViewVisible
            color: "#66000000"
            z: 200

            MouseArea {
                anchors.fill: parent
                onClicked: function (mouse) {
                    if (!searchLoader.item || !searchLoader.item.dialogItem) {
                        return;
                    }

                    const dialog = searchLoader.item.dialogItem;
                    const dialogPos = dialog.mapToItem(searchOverlay, 0, 0);
                    const clickedOutsideDialog = mouse.x < dialogPos.x || mouse.x > (dialogPos.x + dialog.width) || mouse.y < dialogPos.y || mouse.y > (dialogPos.y + dialog.height);

                    if (clickedOutsideDialog) {
                        window.searchViewVisible = false;
                    }
                }
            }

            Loader {
                id: searchLoader
                anchors.fill: parent
                active: searchOverlay.visible
                source: "Search.qml"
            }
        }

        Rectangle {
            id: shareOverlay
            anchors.fill: parent
            visible: window.shareViewVisible && !window.settingsViewVisible
            color: "#66000000"
            z: 210

            MouseArea {
                anchors.fill: parent
                onClicked: function (mouse) {
                    if (!shareLoader.item || !shareLoader.item.dialogItem) {
                        return;
                    }

                    const dialog = shareLoader.item.dialogItem;
                    const dialogPos = dialog.mapToItem(shareOverlay, 0, 0);
                    const clickedOutsideDialog = mouse.x < dialogPos.x || mouse.x > (dialogPos.x + dialog.width) || mouse.y < dialogPos.y || mouse.y > (dialogPos.y + dialog.height);

                    if (clickedOutsideDialog) {
                        window.shareViewVisible = false;
                    }
                }
            }

            Loader {
                id: shareLoader
                anchors.fill: parent
                active: shareOverlay.visible
                source: "Share.qml"
            }

            Connections {
                target: shareLoader.item
                ignoreUnknownSignals: true

                function onCloseClicked() {
                    window.shareViewVisible = false;
                }
            }
        }

        Rectangle {
            id: profileOverlay
            anchors.fill: parent
            visible: window.profileViewVisible && !window.settingsViewVisible
            color: "#66000000"
            z: 220

            MouseArea {
                anchors.fill: parent
                onClicked: function (mouse) {
                    if (!profileLoader.item || !profileLoader.item.dialogItem) {
                        return;
                    }

                    const dialog = profileLoader.item.dialogItem;
                    const dialogPos = dialog.mapToItem(profileOverlay, 0, 0);
                    const clickedOutsideDialog = mouse.x < dialogPos.x || mouse.x > (dialogPos.x + dialog.width) || mouse.y < dialogPos.y || mouse.y > (dialogPos.y + dialog.height);

                    if (clickedOutsideDialog) {
                        window.profileViewVisible = false;
                    }
                }
            }

            Loader {
                id: profileLoader
                anchors.fill: parent
                active: profileOverlay.visible
                source: "Profile.qml"
            }

            Connections {
                target: profileLoader.item
                ignoreUnknownSignals: true

                function onCloseClicked() {
                    window.profileViewVisible = false;
                }

                function onLogoutClicked() {
                    window.profileViewVisible = false;
                    console.log("Logout clicked");
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
            visible: !window.authenticated
            z: 9999
            fontFamily: interFont.name
            darkTheme: window.useDarkAuthTheme
            onLoginRequested: function (email, password) {
                console.log("Login requested:", email, "password length:", password.length);
                window.authenticated = true;
            }
            onRegisterRequested: function (name, email, password) {
                console.log("Register requested:", name, email, "password length:", password.length);
                window.authenticated = true;
            }
        }
    }
}
