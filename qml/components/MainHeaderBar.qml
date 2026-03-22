pragma ComponentBehavior: Bound

import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: root

    property string fontFamily: ""
    property bool sidebarVisible: true
    property var notePathSegments: []

    signal hideSidebarClicked
    signal shareClicked
    signal favoriteClicked
    signal moreClicked

    height: 56
    color: Palette.headerBackground
    border.width: 1
    border.color: Palette.border

    Item {
        anchors.left: parent.left
        anchors.right: actionRow.left
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 24
        height: 24
        clip: true

        Row {
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            MouseArea {
                id: hideSidebarArea
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.hideSidebarClicked()
                onEntered: hideSidebarImage.opacity = 0.6
                onExited: hideSidebarImage.opacity = 1.0

                Image {
                    id: hideSidebarImage
                    source: root.sidebarVisible ? "qrc:/qt/qml/zametki/assets/icons/header/hide-sidebar.svg" : "qrc:/qt/qml/zametki/assets/icons/header/show-sidebar.svg"
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

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Repeater {
                    model: root.notePathSegments.length > 0 ? (root.notePathSegments.length * 2 - 1) : 1

                    delegate: Text {
                        required property int index
                        readonly property bool isPlaceholder: root.notePathSegments.length === 0
                        readonly property bool isSeparator: !isPlaceholder && (index % 2 === 1)
                        readonly property int segmentIndex: Math.floor(index / 2)
                        readonly property bool isLastSegment: !isSeparator && !isPlaceholder && (segmentIndex === root.notePathSegments.length - 1)

                        text: {
                            if (isPlaceholder) {
                                return "";
                            }

                            if (isSeparator) {
                                return ">";
                            }

                            return root.notePathSegments[segmentIndex];
                        }
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: isLastSegment ? "#0F1724" : "#667085"
                    }
                }
            }
        }
    }

    Row {
        id: actionRow
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
                source: "qrc:/qt/qml/zametki/assets/icons/header/share.svg"
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
                source: "qrc:/qt/qml/zametki/assets/icons/header/favorite.svg"
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
                source: "qrc:/qt/qml/zametki/assets/icons/header/more.svg"
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
