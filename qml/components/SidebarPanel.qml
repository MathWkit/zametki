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

                        Text {
                            text: "Моя база знаний"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            font.family: root.fontFamily
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            color: Palette.textPrimary
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

            Rectangle {
                id: searchRow
                Layout.fillWidth: true
                color: "transparent"
                radius: Palette.cornerRadius
                implicitHeight: searchContent.implicitHeight + 24

                RowLayout {
                    id: searchContent
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/sidebar/search.svg"
                        width: 16
                        height: 16
                    }

                    Text {
                        text: "Поиск"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: root.searchClicked()
                    onEntered: searchRow.color = Palette.hover
                    onExited: searchRow.color = "transparent"
                }
            }

            Rectangle {
                id: newNoteRow
                Layout.fillWidth: true
                color: "transparent"
                radius: Palette.cornerRadius
                implicitHeight: newNoteContent.implicitHeight + 24

                RowLayout {
                    id: newNoteContent
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
                        width: 16
                        height: 16
                    }

                    Text {
                        text: "Новая заметка"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: root.newNoteClicked()
                    onEntered: newNoteRow.color = Palette.hover
                    onExited: newNoteRow.color = "transparent"
                }
            }

            Rectangle {
                id: graphRow
                Layout.fillWidth: true
                color: "transparent"
                radius: Palette.cornerRadius
                implicitHeight: graphContent.implicitHeight + 24

                RowLayout {
                    id: graphContent
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 6

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg"
                        width: 16
                        height: 16
                    }

                    Text {
                        text: "Вид графа"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: root.graphClicked()
                    onEntered: graphRow.color = Palette.hover
                    onExited: graphRow.color = "transparent"
                }
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

                        Text {
                            text: "Lox chvetochiy"
                            font.family: root.fontFamily
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                        Text {
                            text: "loxcvetochiy@titam.com"
                            font.family: root.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Normal
                            color: Palette.textSecondary
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

            Rectangle {
                id: menuProfileRow
                Layout.fillWidth: true
                implicitHeight: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/profile/profile.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: "Профиль"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: Palette.textPrimary
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuProfileRow.color = Palette.hover
                    onExited: menuProfileRow.color = "transparent"
                    onClicked: {
                        root.profileMenuItemClicked("profile");
                        profileMenu.close();
                    }
                }
            }

            Rectangle {
                id: menuSettingsRow
                Layout.fillWidth: true
                implicitHeight: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/profile/settings.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: "Настройки"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: Palette.textPrimary
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuSettingsRow.color = Palette.hover
                    onExited: menuSettingsRow.color = "transparent"
                    onClicked: {
                        root.settingsClicked();
                        root.profileMenuItemClicked("settings");
                        profileMenu.close();
                    }
                }
            }

            Rectangle {
                id: menuSyncRow
                Layout.fillWidth: true
                implicitHeight: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/profile/sync.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: "Статус синхронизации"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: Palette.textPrimary
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuSyncRow.color = Palette.hover
                    onExited: menuSyncRow.color = "transparent"
                    onClicked: {
                        root.profileMenuItemClicked("sync-status");
                        profileMenu.close();
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Palette.border
            }

            Rectangle {
                id: menuHelpRow
                Layout.fillWidth: true
                implicitHeight: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/profile/help.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: "Помощь и справка"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: Palette.textPrimary
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuHelpRow.color = Palette.hover
                    onExited: menuHelpRow.color = "transparent"
                    onClicked: {
                        root.profileMenuItemClicked("help");
                        profileMenu.close();
                    }
                }
            }

            Rectangle {
                id: menuHotkeysRow
                Layout.fillWidth: true
                implicitHeight: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/profile/keyboard.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: "Горячие клавиши"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: Palette.textPrimary
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuHotkeysRow.color = Palette.hover
                    onExited: menuHotkeysRow.color = "transparent"
                    onClicked: {
                        root.profileMenuItemClicked("hotkeys");
                        profileMenu.close();
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Palette.border
            }

            Rectangle {
                id: menuLogoutRow
                Layout.fillWidth: true
                implicitHeight: 40
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/profile/logout.svg"
                        width: 16
                        height: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: "Выход"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: Palette.textPrimary
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuLogoutRow.color = Palette.hover
                    onExited: menuLogoutRow.color = "transparent"
                    onClicked: {
                        root.profileMenuItemClicked("logout");
                        profileMenu.close();
                    }
                }
            }
        }
    }
}
