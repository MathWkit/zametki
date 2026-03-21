pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string fontFamily: ""
    property var folderTitles: []
    property var noteTitles: []
    property string selectedItemKey: ""

    signal searchClicked
    signal newNoteClicked
    signal graphClicked
    signal folderClicked(string folderTitle)
    signal noteClicked(string noteTitle)
    signal itemSelected(string itemKey)

    color: "transparent"
    border.width: 1
    border.color: Qt.rgba(0, 0, 0, 0.08)

    Column {
        id: horizontalBorder
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 8

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Image {
                    source: "qrc:/qt/qml/zametki/assets/my-knowledge-base.svg"
                    width: 24
                    height: 24
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "Моя база знаний"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.family: root.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    color: "#0F1724"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Image {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qt/qml/zametki/assets/chose.svg"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(0, 0, 0, 0.08)
        }
    }

    Column {
        id: container
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: horizontalBorder.bottom
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 8
        spacing: 4

        Rectangle {
            id: searchRow
            height: 40
            width: parent.width
            color: "transparent"
            radius: 4

            Row {
                anchors.fill: parent
                spacing: 6
                leftPadding: 12
                rightPadding: 12

                Image {
                    source: "qrc:/qt/qml/zametki/assets/search.svg"
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Поиск"
                    font.family: root.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.searchClicked()
                onEntered: searchRow.color = "#f0f0f0"
                onExited: searchRow.color = "transparent"
            }
        }

        Rectangle {
            id: newNoteRow
            height: 40
            width: parent.width
            color: "transparent"
            radius: 4

            Row {
                anchors.fill: parent
                spacing: 6
                leftPadding: 12
                rightPadding: 12

                Image {
                    source: "qrc:/qt/qml/zametki/assets/new-note.svg"
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Новая заметка"
                    font.family: root.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.newNoteClicked()
                onEntered: newNoteRow.color = "#f0f0f0"
                onExited: newNoteRow.color = "transparent"
            }
        }

        Rectangle {
            id: graphRow
            height: 40
            width: parent.width
            color: "transparent"
            radius: 4

            Row {
                anchors.fill: parent
                spacing: 6
                leftPadding: 12
                rightPadding: 12

                Image {
                    source: "qrc:/qt/qml/zametki/assets/graph-view.svg"
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "Вид графа"
                    font.family: root.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.graphClicked()
                onEntered: graphRow.color = "#f0f0f0"
                onExited: graphRow.color = "transparent"
            }
        }
    }

    FolderNoteList {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: container.bottom
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 8
        anchors.bottomMargin: 8

        fontFamily: root.fontFamily
        folderTitles: root.folderTitles
        noteTitles: root.noteTitles
        selectedItemKey: root.selectedItemKey

        onFolderClicked: function (folderTitle) {
            root.folderClicked(folderTitle);
        }
        onNoteClicked: function (noteTitle) {
            root.noteClicked(noteTitle);
        }
        onItemSelected: function (itemKey) {
            root.itemSelected(itemKey);
        }
    }
}
