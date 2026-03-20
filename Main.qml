import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: window
    width: 640
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
        Item {
            id: aside
            width: parent.width * 0.3
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            // Верхняя граница (скрытая)
            Item {
                id: horizontalBorder
                height: 0
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
            }

            // Контейнер с кнопками
            Column {
                id: container
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: horizontalBorder.bottom
                anchors.bottom: folders.top
                // anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.topMargin: 8
                anchors.bottomMargin: 8
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
                anchors.bottom: parent.bottom
                spacing: 5
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
