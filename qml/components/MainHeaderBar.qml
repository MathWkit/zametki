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
    border.width: 0

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

            Item {
                width: Palette.buttonHeightSmall
                height: Palette.buttonHeightSmall
                anchors.verticalCenter: parent.verticalCenter

                AppIconSurfaceButton {
                    anchors.fill: parent
                    iconSource: root.sidebarVisible ? "qrc:/qt/qml/zametki/assets/icons/header/hide-sidebar.svg" : "qrc:/qt/qml/zametki/assets/icons/header/show-sidebar.svg"
                    iconWidth: Palette.iconSmall
                    iconHeight: Palette.iconSmall
                    surfaceColor: "transparent"
                    hoverSurfaceColor: Palette.hover
                    pressedSurfaceColor: Palette.selected
                    cornerRadius: Palette.radiusMd
                    onClicked: root.hideSidebarClicked()
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

        Item {
            width: Palette.buttonHeightSmall
            height: Palette.buttonHeightSmall
            anchors.verticalCenter: parent.verticalCenter

            AppIconSurfaceButton {
                anchors.fill: parent
                iconSource: "qrc:/qt/qml/zametki/assets/icons/header/share.svg"
                iconWidth: Palette.iconSmall
                iconHeight: Palette.iconSmall
                surfaceColor: "transparent"
                hoverSurfaceColor: Palette.hover
                pressedSurfaceColor: Palette.selected
                cornerRadius: Palette.radiusMd
                onClicked: root.shareClicked()
            }
        }

        Item {
            width: Palette.buttonHeightSmall
            height: Palette.buttonHeightSmall
            anchors.verticalCenter: parent.verticalCenter

            AppIconSurfaceButton {
                anchors.fill: parent
                iconSource: "qrc:/qt/qml/zametki/assets/icons/header/favorite.svg"
                iconWidth: Palette.iconSmall
                iconHeight: Palette.iconSmall
                surfaceColor: "transparent"
                hoverSurfaceColor: Palette.hover
                pressedSurfaceColor: Palette.selected
                cornerRadius: Palette.radiusMd
                onClicked: root.favoriteClicked()
            }
        }

        Item {
            width: Palette.buttonHeightSmall
            height: Palette.buttonHeightSmall
            anchors.verticalCenter: parent.verticalCenter

            AppIconSurfaceButton {
                anchors.fill: parent
                iconSource: "qrc:/qt/qml/zametki/assets/icons/header/more.svg"
                iconWidth: Palette.iconSmall
                iconHeight: Palette.iconSmall
                surfaceColor: "transparent"
                hoverSurfaceColor: Palette.hover
                pressedSurfaceColor: Palette.selected
                cornerRadius: Palette.radiusMd
                onClicked: root.moreClicked()
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        implicitHeight: 1
        color: Palette.border
    }
}
