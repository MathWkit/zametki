pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Layouts 6.8
import QtQuick.Controls 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: root

    property string fontFamily: ""
    property var folderTitles: []
    property var noteTitles: []
    property string selectedItemKey: ""

    signal searchClicked
    signal newNoteClicked
    signal graphClicked
    signal settingsClicked
    signal profileMenuItemClicked(string actionKey)
    signal folderClicked(string folderTitle)
    signal noteClicked(string noteTitle)
    signal itemSelected(string itemKey)

    color: "transparent"
    border.width: 1
    border.color: Palette.border

    component SidebarTitleText: Text {
        font.family: root.fontFamily
        font.pixelSize: 14
        font.weight: Font.DemiBold
        color: Palette.textPrimary
    }

    component SidebarSubtitleText: Text {
        font.family: root.fontFamily
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    component SidebarBodyText: Text {
        font.family: root.fontFamily
        font.pixelSize: 14
        font.weight: Font.Normal
        color: Palette.textPrimary
    }

    component SidebarSmallText: Text {
        font.family: root.fontFamily
        font.pixelSize: 12
        font.weight: Font.Normal
        color: Palette.textSecondary
    }

    component SidebarActionRow: Rectangle {
        id: actionRow

        required property string iconSource
        required property string titleText

        signal clicked

        Layout.fillWidth: true
        color: "transparent"
        radius: Palette.cornerRadius
        implicitHeight: actionContent.implicitHeight + 24

        RowLayout {
            id: actionContent
            anchors.fill: parent
            anchors.margins: 12
            spacing: 6

            Image {
                source: actionRow.iconSource
                width: 16
                height: 16
            }

            SidebarSubtitleText {
                text: actionRow.titleText
                Layout.fillWidth: true
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: actionRow.clicked()
            onEntered: actionRow.color = Palette.hover
            onExited: actionRow.color = "transparent"
        }
    }

    component ProfileMenuItemRow: Rectangle {
        id: menuRow

        required property string iconSource
        required property string titleText

        signal clicked

        Layout.fillWidth: true
        implicitHeight: 40
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            Image {
                source: menuRow.iconSource
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit
            }

            SidebarBodyText {
                text: menuRow.titleText
                Layout.fillWidth: true
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: menuRow.color = Palette.hover
            onExited: menuRow.color = "transparent"
            onClicked: menuRow.clicked()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 8
            color: "transparent"
            implicitHeight: headerContent.implicitHeight + 16

            ColumnLayout {
                id: headerContent
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 24

                    RowLayout {
                        anchors.fill: parent
                        spacing: 6

                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/my-knowledge-base.svg"
                            width: 24
                            height: 24
                            fillMode: Image.PreserveAspectFit
                        }

                        SidebarTitleText {
                            text: "Моя база знаний"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            Layout.fillWidth: true
                        }

                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/chosen.svg"
                            width: 16
                            height: 16
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Palette.border
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 8
            spacing: 4

            SidebarActionRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/sidebar/search.svg"
                titleText: "Поиск"
                onClicked: root.searchClicked()
            }

            SidebarActionRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
                titleText: "Новая заметка"
                onClicked: root.newNoteClicked()
            }

            SidebarActionRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg"
                titleText: "Вид графа"
                onClicked: root.graphClicked()
            }
        }

        Flickable {
            id: noteListScroller
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 8
            Layout.bottomMargin: 8

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            contentWidth: width
            contentHeight: folderNoteList.implicitHeight

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                minimumSize: 0.1
                width: 6
                contentItem: Rectangle {
                    implicitWidth: 6
                    radius: 3
                    color: Palette.border
                }
                background: Rectangle {
                    implicitWidth: 6
                    radius: 3
                    color: "transparent"
                }
            }

            FolderNoteList {
                id: folderNoteList
                width: noteListScroller.width

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

        Rectangle {
            Layout.fillWidth: true
            Layout.bottomMargin: 8
            implicitHeight: 1
            color: Palette.border
        }

        Rectangle {
            id: profileRow
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.bottomMargin: 8
            color: "transparent"
            radius: Palette.cornerRadius
            implicitHeight: profileCard.implicitHeight

            Rectangle {
                id: profileCard
                anchors.fill: parent
                implicitHeight: profileContent.implicitHeight + 24
                radius: Palette.cornerRadius
                color: Palette.headerBackground
                border.width: 1
                border.color: Palette.border
                RowLayout {
                    id: profileContent
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6
                    Layout.fillWidth: true
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 32
                        color: Palette.hover

                        Text {
                            text: "GL"
                            anchors.centerIn: parent
                            font.family: root.fontFamily
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            color: Palette.textPrimary
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        SidebarSubtitleText {
                            text: "Lox chvetochiy"
                        }
                        SidebarSmallText {
                            text: "loxcvetochiy@titam.com"
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/sidebar/chosen.svg"

                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: profileMenu.open()
                    onEntered: profileCard.color = Palette.hover
                    onExited: profileCard.color = Palette.headerBackground
                }
            }
        }
    }

    Popup {
        id: profileMenu
        parent: root
        modal: false
        focus: true
        padding: 0
        width: profileRow.width
        x: profileRow.x
        y: Math.max(8, profileRow.y - implicitHeight - 8)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: Palette.cornerRadius
            color: Palette.headerBackground
            border.width: 1
            border.color: Palette.border
        }

        contentItem: ColumnLayout {
            spacing: 0

            ProfileMenuItemRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/profile.svg"
                titleText: "Профиль"
                onClicked: {
                    root.profileMenuItemClicked("profile");
                    profileMenu.close();
                }
            }

            ProfileMenuItemRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/settings.svg"
                titleText: "Настройки"
                onClicked: {
                    root.settingsClicked();
                    root.profileMenuItemClicked("settings");
                    profileMenu.close();
                }
            }

            ProfileMenuItemRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/sync.svg"
                titleText: "Статус синхронизации"
                onClicked: {
                    root.profileMenuItemClicked("sync-status");
                    profileMenu.close();
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Palette.border
            }

            ProfileMenuItemRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/help.svg"
                titleText: "Помощь и справка"
                onClicked: {
                    root.profileMenuItemClicked("help");
                    profileMenu.close();
                }
            }

            ProfileMenuItemRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/keyboard.svg"
                titleText: "Горячие клавиши"
                onClicked: {
                    root.profileMenuItemClicked("hotkeys");
                    profileMenu.close();
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Palette.border
            }

            ProfileMenuItemRow {
                iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/logout.svg"
                titleText: "Выход"
                onClicked: {
                    root.profileMenuItemClicked("logout");
                    profileMenu.close();
                }
            }
        }
    }
}
