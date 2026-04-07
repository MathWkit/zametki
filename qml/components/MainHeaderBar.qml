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

    height: Palette.headerHeight
    color: Palette.headerBackground
    border.width: 1
    border.color: Palette.border

    Item {
        anchors.left: parent.left
        anchors.right: actionRow.left
        anchors.rightMargin: Palette.spacingMassive
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Palette.spacingMassive
        height: Palette.iconLarge
        clip: true

        Row {
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            spacing: Palette.spacingLg

            MouseArea {
                id: hideSidebarArea
                width: Palette.iconSmall
                height: Palette.iconSmall
                anchors.verticalCenter: parent.verticalCenter
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.hideSidebarClicked()
                onEntered: hideSidebarImage.opacity = 0.6
                onExited: hideSidebarImage.opacity = 1.0

                Image {
                    id: hideSidebarImage
                    source: root.sidebarVisible ? "qrc:/qt/qml/zametki/assets/icons/header/hide-sidebar.svg" : "qrc:/qt/qml/zametki/assets/icons/header/show-sidebar.svg"
                    width: Palette.iconSmall
                    height: Palette.iconSmall
                    fillMode: Image.PreserveAspectFit
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Palette.animationFast
                        }
                    }
                }
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: Palette.spacingLg

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
                        font.pixelSize: Palette.fontSizeMd
                        font.weight: Font.Medium
                        color: isLastSegment ? Palette.textPrimary : Palette.textSecondary
                    }
                }
            }
        }
    }

    Row {
        id: actionRow
        spacing: Palette.spacingXl
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: Palette.spacingMassive

        MouseArea {
            id: shareArea
            width: Palette.iconSmall
            height: Palette.iconSmall
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.shareClicked()
            onEntered: shareImage.opacity = 0.6
            onExited: shareImage.opacity = 1.0

            Image {
                id: shareImage
                source: "qrc:/qt/qml/zametki/assets/icons/header/share.svg"
                width: Palette.iconSmall
                height: Palette.iconSmall
                fillMode: Image.PreserveAspectFit
                Behavior on opacity {
                    NumberAnimation {
                        duration: Palette.animationFast
                    }
                }
            }
        }

        MouseArea {
            id: favoriteArea
            width: Palette.iconSmall
            height: Palette.iconSmall
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.favoriteClicked()
            onEntered: favoriteImage.opacity = 0.6
            onExited: favoriteImage.opacity = 1.0

            Image {
                id: favoriteImage
                source: "qrc:/qt/qml/zametki/assets/icons/header/favorite.svg"
                width: Palette.iconSmall
                height: Palette.iconSmall
                fillMode: Image.PreserveAspectFit
                Behavior on opacity {
                    NumberAnimation {
                        duration: Palette.animationFast
                    }
                }
            }
        }

        MouseArea {
            id: moreArea
            width: Palette.iconSmall
            height: Palette.iconSmall
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.moreClicked()
            onEntered: moreImage.opacity = 0.6
            onExited: moreImage.opacity = 1.0

            Image {
                id: moreImage
                source: "qrc:/qt/qml/zametki/assets/icons/header/more.svg"
                width: Palette.iconSmall
                height: Palette.iconSmall
                fillMode: Image.PreserveAspectFit
                Behavior on opacity {
                    NumberAnimation {
                        duration: Palette.animationFast
                    }
                }
            }
        }
    }
}
