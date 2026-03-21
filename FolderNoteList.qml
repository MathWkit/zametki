pragma ComponentBehavior: Bound

import QtQuick 6.8
import "qrc:/qt/qml/zametki/Theme.js" as Palette

Column {
    id: root

    property string fontFamily: ""
    property var folderTitles: []
    property var noteTitles: []
    property string selectedItemKey: ""

    signal folderClicked(string folderTitle)
    signal noteClicked(string noteTitle)
    signal itemSelected(string itemKey)

    spacing: 5

    Text {
        text: "Папки"
        font.family: root.fontFamily
        font.pixelSize: 11
        font.weight: Font.DemiBold
        color: Palette.textSecondary
        anchors.left: parent.left
        anchors.leftMargin: 12
    }

    Repeater {
        model: root.folderTitles

        delegate: Rectangle {
            id: folderItem
            required property string modelData

            width: parent ? parent.width : 0
            height: 26
            color: root.selectedItemKey === ("folder:" + folderItem.modelData) ? Palette.selected : (folderMouseArea.containsMouse ? Palette.hover : "transparent")
            radius: Palette.cornerRadius

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Image {
                    source: "qrc:/qt/qml/zametki/assets/closed-bracket.svg"
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    source: "qrc:/qt/qml/zametki/assets/folder.svg"
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: folderItem.modelData
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Normal
                    color: Palette.textPrimary
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                id: folderMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    root.itemSelected("folder:" + folderItem.modelData);
                    root.folderClicked(folderItem.modelData);
                }
            }
        }
    }

    Repeater {
        model: root.noteTitles

        delegate: Rectangle {
            id: noteItem
            required property string modelData

            width: parent ? parent.width : 0
            height: 30
            color: root.selectedItemKey === ("note:" + noteItem.modelData) ? Palette.selected : (noteMouseArea.containsMouse ? Palette.hover : "transparent")
            radius: Palette.cornerRadius

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Image {
                    source: "qrc:/qt/qml/zametki/assets/note.svg"
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: noteItem.modelData
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Normal
                    color: Palette.textPrimary
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                id: noteMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    root.itemSelected("note:" + noteItem.modelData);
                    root.noteClicked(noteItem.modelData);
                }
            }
        }
    }
}
