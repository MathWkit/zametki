pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
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

        // Левая сайдбар
        Rectangle {
            id: aside
            width: Math.max(parent.width * 0.2, 200)
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

            Column {
                id: container
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: horizontalBorder.bottom
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.topMargin: 8
                spacing: 4

                // ─── Row 1: Поиск ───
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
                            font.family: interFont.name
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
                        onClicked: Handlers.onSearchClicked()
                        onEntered: searchRow.color = "#f0f0f0"
                        onExited: searchRow.color = "transparent"
                    }
                }

                // ─── Row 2: Новая заметка ───
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
                            font.family: interFont.name
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
                        onClicked: Handlers.onNewNoteClicked(fileCreator)
                        onEntered: newNoteRow.color = "#f0f0f0"
                        onExited: newNoteRow.color = "transparent"
                    }
                }

                // ─── Row 3: Вид графа ───
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
                            font.family: interFont.name
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
                        onClicked: Handlers.onGraphClicked()
                        onEntered: graphRow.color = "#f0f0f0"
                        onExited: graphRow.color = "transparent"
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
                anchors.bottomMargin: 8

                spacing: 5
                Text {
                    text: "Папки"
                    font.family: interFont.name
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: "#6B7280"
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                }

                Repeater {
                    model: fileCreator.folderTitles

                    delegate: Rectangle {
                        id: folderItem
                        required property string modelData

                        width: parent ? parent.width : 0
                        height: 26
                        color: window.selectedItemKey === ("folder:" + folderItem.modelData) ? "#e8eefc" : (folderMouseArea.containsMouse ? "#f0f0f0" : "transparent")
                        radius: 4

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
                                font.family: interFont.name
                                font.pixelSize: 13
                                font.weight: Font.Normal
                                color: "#0F1724"
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: folderMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                window.selectedItemKey = "folder:" + folderItem.modelData;
                                Handlers.onFolderClicked(folderItem.modelData);
                            }
                        }
                    }
                }

                Repeater {
                    model: fileCreator.noteTitles

                    delegate: Rectangle {
                        id: noteItem
                        required property string modelData

                        width: parent ? parent.width : 0
                        height: 30
                        color: window.selectedItemKey === ("note:" + noteItem.modelData) ? "#e8eefc" : (noteMouseArea.containsMouse ? "#f0f0f0" : "transparent")
                        radius: 4

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
                                font.family: interFont.name
                                font.pixelSize: 13
                                font.weight: Font.Normal
                                color: "#0F1724"
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: noteMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                window.selectedItemKey = "note:" + noteItem.modelData;
                                Handlers.onNoteClicked(noteItem.modelData);
                            }
                        }
                    }
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
            Rectangle {
                id: header
                height: 56           // фиксированная высота шапки
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#F8F9FA"    // фон шапки, можно прозрачный
                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.08)

                // Левая часть: иконка + текст
                Row {
                    id: leftPart
                    spacing: 10
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 24

                    MouseArea {
                        id: hideSidebarArea
                        width: 16
                        height: 16
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: Handlers.onHideSidebarClicked()
                        onEntered: hideSidebarImage.opacity = 0.6
                        onExited: hideSidebarImage.opacity = 1.0

                        Image {
                            id: hideSidebarImage
                            source: "qrc:/qt/qml/zametki/assets/hide-sidebar.svg"
                            width: 16
                            height: 16
                            fillMode: Image.PreserveAspectFit
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    Text {
                        text: "Поле для текста"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter

                        color: "#0F1724"
                    }
                }

                // Правая часть: 3 иконки
                Row {
                    id: rightPart
                    spacing: 16
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 24

                    MouseArea {
                        id: shareArea
                        width: 16
                        height: 16
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: Handlers.onShareClicked()
                        onEntered: shareImage.opacity = 0.6
                        onExited: shareImage.opacity = 1.0

                        Image {
                            id: shareImage
                            source: "qrc:/qt/qml/zametki/assets/share.svg"
                            width: 16
                            height: 16
                            fillMode: Image.PreserveAspectFit
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: favoriteArea
                        width: 16
                        height: 16
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: Handlers.onFavoriteClicked()
                        onEntered: favoriteImage.opacity = 0.6
                        onExited: favoriteImage.opacity = 1.0

                        Image {
                            id: favoriteImage
                            source: "qrc:/qt/qml/zametki/assets/favorite.svg"
                            width: 16
                            height: 16
                            fillMode: Image.PreserveAspectFit
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: moreArea
                        width: 16
                        height: 16
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: Handlers.onMoreClicked()
                        onEntered: moreImage.opacity = 0.6
                        onExited: moreImage.opacity = 1.0

                        Image {
                            id: moreImage
                            source: "qrc:/qt/qml/zametki/assets/more.svg"
                            width: 16
                            height: 16
                            fillMode: Image.PreserveAspectFit
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
