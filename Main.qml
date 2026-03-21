pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import "qrc:/qt/qml/zametki/Handlers.mjs" as Handlers

Window {
    id: window
    property string selectedItemKey: ""

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
            width: Math.max(parent.width * 0.2, 200)
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            fontFamily: interFont.name
            selectedItemKey: window.selectedItemKey
            folderTitles: fileCreator.folderTitles
            noteTitles: fileCreator.noteTitles
            onSearchClicked: Handlers.onSearchClicked()
            onNewNoteClicked: Handlers.onNewNoteClicked(fileCreator)
            onGraphClicked: Handlers.onGraphClicked()
            onFolderClicked: function (folderTitle) {
                Handlers.onFolderClicked(folderTitle);
            }
            onNoteClicked: function (noteTitle) {
                Handlers.onNoteClicked(noteTitle);
            }
            onItemSelected: itemKey => window.selectedItemKey = itemKey
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
                onHideSidebarClicked: Handlers.onHideSidebarClicked()
                onShareClicked: Handlers.onShareClicked()
                onFavoriteClicked: Handlers.onFavoriteClicked()
                onMoreClicked: Handlers.onMoreClicked()
            }
        }
    }
}
