import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: window
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
                        onClicked: console.log("Нажатие на Поиск")
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
                        onClicked: console.log("Нажатие на Новую заметку")
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
                        onClicked: console.log("Нажатие на Вид графа")
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
                        onClicked: console.log("Нажатие на Hide Sidebar")
                        onEntered: hideSidebarImage.opacity = 0.6
                        onExited: hideSidebarImage.opacity = 1.0

                        Image {
                            id: hideSidebarImage
                            source: "qrc:/qt/qml/zametki/assets/hide-sidebar.png"
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
                        onClicked: console.log("Нажата иконка Share")
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
                        onClicked: console.log("Нажата иконка Favorite")
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
                        onClicked: console.log("Нажата иконка More")
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
