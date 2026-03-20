import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: window
    width: 1920
    height: 480
    visible: true
    title: qsTr("Hello World")

    FontLoader {
        id: interFont
        source: "qrc:/qt/qml/zametki/assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf"
    }

    Item {
        anchors.fill: parent

        // Левая сайдбар
        Rectangle {
            id: aside
            width: parent.width * 0.2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(0, 0, 0, 0.08)

            // Верхняя граница (скрытая)
            Column {
                id: horizontalBorder
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                spacing: 16

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 40
                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6

                        Image {
                            id: horizontalBorderIcon
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
                            font.family: interFont.name
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            color: "#0F1724"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Image {
                        id: chosenNoteIcon
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

            // Контейнер с кнопками
            Column {
                id: container
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: horizontalBorder.bottom
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.topMargin: 8
                spacing: 4

                Row {
                    id: search
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 10
                    leftPadding: 12
                    rightPadding: 12
                    topPadding: 8
                    bottomPadding: 8
                    Layout.alignment: Qt.AlignLeft

                    Image {
                        id: searchIcon
                        source: "qrc:/qt/qml/zametki/assets/search.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: "Поиск"
                        verticalAlignment: Text.AlignVCenter
                        font.family: interFont.name
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }

                Row {
                    id: newNote
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 10
                    leftPadding: 12
                    rightPadding: 12
                    topPadding: 8
                    bottomPadding: 8
                    Layout.alignment: Qt.AlignLeft

                    Image {
                        id: newNoteIcon
                        source: "qrc:/qt/qml/zametki/assets/new-note.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: "Новая заметка"
                        verticalAlignment: Text.AlignVCenter
                        font.family: interFont.name
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }

                Row {
                    id: graphView
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 10
                    leftPadding: 12
                    rightPadding: 12
                    topPadding: 8
                    bottomPadding: 8
                    Layout.alignment: Qt.AlignLeft

                    Image {
                        id: graphViewIcon
                        source: "qrc:/qt/qml/zametki/assets/graph-view.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: "Вид графа"
                        verticalAlignment: Text.AlignVCenter
                        font.family: interFont.name
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

            // Папки (внизу)
            Column {
                id: folders
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: container.bottom
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.topMargin: 8
                spacing: 5
                Text {
                    text: "Папки"
                    font.family: interFont.name
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: "#6B7280"
                    Layout.alignment: Qt.AlignLeft
                    leftPadding: 12
                    rightPadding: 12
                    topPadding: 12
                    bottomPadding: 4
                }
            }
        }

        // Главная область
        Item {
            id: main
            anchors.left: aside.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }
}
