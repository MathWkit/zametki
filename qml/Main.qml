pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Window 6.8
import "scripts/Theme.js" as Palette
import "scripts/Handlers.mjs" as Handlers

Window {
    id: window
    property string selectedItemKey: ""
    property bool sidebarVisible: true
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
            width: window.sidebarVisible ? window.asideWidth : 0
            visible: width > 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            fontFamily: interFont.name
            selectedItemKey: window.selectedItemKey
            folderTitles: AppState.folderTitles
            noteTitles: AppState.noteTitles
            onSearchClicked: {
                Handlers.onSearchClicked();
            }
            onNewNoteClicked: {
                Handlers.onNewNoteClicked(AppState);
            }
            onGraphClicked: {
                Handlers.onGraphClicked();
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
                }
                onFavoriteClicked: {
                    Handlers.onFavoriteClicked();
                }
                onMoreClicked: {
                    Handlers.onMoreClicked();
                }
            }
        }
    }
}
