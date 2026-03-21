import QtQuick 6.8

Rectangle {
    id: root

    property string fontFamily: ""

    signal hideSidebarClicked
    signal shareClicked
    signal favoriteClicked
    signal moreClicked

    height: 56
    color: "#F8F9FA"
    border.width: 1
    border.color: Qt.rgba(0, 0, 0, 0.08)

    Row {
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
            onClicked: root.hideSidebarClicked()
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
            font.family: root.fontFamily
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            color: "#0F1724"
        }
    }

    Row {
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
            onClicked: root.shareClicked()
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
            onClicked: root.favoriteClicked()
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
            onClicked: root.moreClicked()
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
