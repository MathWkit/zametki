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

    readonly property string uiFontFamily: root.fontFamily !== "" ? root.fontFamily : Palette.fontFamily

    component SidebarActionRow: Rectangle {
        id: actionRow

        required property string iconSource
        required property string titleText

        signal clicked

        Layout.fillWidth: true
        color: {
            if (actionRowMouseArea.pressed) {
                return Palette.selected;
            }
            if (actionRowMouseArea.containsMouse) {
                return Palette.hover;
            }
            return "transparent";
        }
        radius: Palette.radiusMd
        implicitHeight: actionContent.implicitHeight + (Palette.spacingXl * 2)

        RowLayout {
            id: actionContent
            anchors.fill: parent
            anchors.margins: Palette.spacingXl
            spacing: Palette.spacingMd

            Image {
                source: actionRow.iconSource
                width: Palette.iconSmall
                height: Palette.iconSmall
            }

            AppSidebarLabelText {
                uiFontFamily: root.uiFontFamily
                textColor: Palette.textPrimary
                text: actionRow.titleText
                Layout.fillWidth: true
            }
        }

        MouseArea {
            id: actionRowMouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: actionRow.clicked()
        }
    }

    component ProfileMenuItemRow: Rectangle {
        id: menuRow

        required property string iconSource
        required property string titleText

        signal clicked

        Layout.fillWidth: true
        implicitHeight: Palette.buttonHeightBase + Palette.spacingSm
        color: {
            if (menuRowMouseArea.pressed) {
                return Palette.selected;
            }
            if (menuRowMouseArea.containsMouse) {
                return Palette.hover;
            }
            return "transparent";
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Palette.spacingXl
            anchors.rightMargin: Palette.spacingXl
            spacing: Palette.spacingLg

            Image {
                source: menuRow.iconSource
                width: Palette.iconSmall
                height: Palette.iconSmall
                fillMode: Image.PreserveAspectFit
            }

            AppBodyText {
                uiFontFamily: root.uiFontFamily
                textPixelSize: Palette.fontSizeMd
                text: menuRow.titleText
                Layout.fillWidth: true
            }
        }

        MouseArea {
            id: menuRowMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: menuRow.clicked()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: Palette.spacingXxl
            Layout.rightMargin: Palette.spacingXxl
            Layout.topMargin: Palette.spacingLg
            color: "transparent"
            implicitHeight: headerContent.implicitHeight + Palette.spacingXxl

            ColumnLayout {
                id: headerContent
                anchors.fill: parent
                anchors.margins: Palette.spacingLg
                spacing: Palette.spacingLg

                Item {
                    Layout.fillWidth: true
                    implicitHeight: Palette.iconLarge

                    RowLayout {
                        anchors.fill: parent
                        spacing: Palette.spacingMd

                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/my-knowledge-base.svg"
                            width: Palette.iconLarge
                            height: Palette.iconLarge
                            fillMode: Image.PreserveAspectFit
                        }

                        AppPageTitleText {
                            uiFontFamily: root.uiFontFamily
                            textPixelSize: Palette.fontSizeMd
                            text: "Моя база знаний"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            Layout.fillWidth: true
                        }

                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/chosen.svg"
                            width: Palette.iconSmall
                            height: Palette.iconSmall
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
            Layout.leftMargin: Palette.spacingXl
            Layout.rightMargin: Palette.spacingXl
            Layout.topMargin: Palette.spacingLg
            spacing: Palette.spacingSm

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
            Layout.leftMargin: Palette.spacingXl
            Layout.rightMargin: Palette.spacingXl
            Layout.topMargin: Palette.spacingLg
            Layout.bottomMargin: Palette.spacingLg

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            contentWidth: width
            contentHeight: folderNoteList.implicitHeight

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                minimumSize: 0.1
                width: Palette.spacingSm + Palette.spacingSm
                contentItem: Rectangle {
                    implicitWidth: Palette.spacingSm + Palette.spacingSm
                    radius: Palette.radiusSm
                    color: Palette.border
                }
                background: Rectangle {
                    implicitWidth: Palette.spacingSm + Palette.spacingSm
                    radius: Palette.radiusSm
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
            Layout.bottomMargin: Palette.spacingLg
            implicitHeight: 1
            color: Palette.border
        }

        Rectangle {
            id: profileRow
            Layout.fillWidth: true
            Layout.leftMargin: Palette.spacingXl
            Layout.rightMargin: Palette.spacingXl
            Layout.bottomMargin: Palette.spacingLg
            color: "transparent"
            radius: Palette.radiusMd
            implicitHeight: profileCard.implicitHeight

            Rectangle {
                id: profileCard
                anchors.fill: parent
                implicitHeight: profileContent.implicitHeight + (Palette.spacingXl * 2)
                radius: Palette.radiusMd
                color: {
                    if (profileCardMouseArea.pressed) {
                        return Palette.selected;
                    }
                    if (profileCardMouseArea.containsMouse) {
                        return Palette.hover;
                    }
                    return Palette.headerBackground;
                }
                border.width: 1
                border.color: Palette.border
                RowLayout {
                    id: profileContent
                    anchors.fill: parent
                    anchors.margins: Palette.spacingXl
                    spacing: Palette.spacingMd
                    Layout.fillWidth: true
                    AppInitialsAvatar {
                        uiFontFamily: root.uiFontFamily
                        initials: "GL"
                        avatarSize: Palette.avatarSmall
                        initialsPixelSize: Palette.fontSizeXs
                        initialsWeight: Font.Medium
                        avatarColor: Palette.hover
                        initialsColor: Palette.textPrimary
                        Layout.preferredWidth: Palette.avatarSmall
                        Layout.preferredHeight: Palette.avatarSmall
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Palette.sidebarProfileTinyGap

                        AppSidebarLabelText {
                            uiFontFamily: root.uiFontFamily
                            textColor: Palette.textPrimary
                            text: "Lox chvetochiy"
                        }
                        AppDescriptionText {
                            uiFontFamily: root.uiFontFamily
                            textPixelSize: Palette.fontSizeSm
                            text: "loxcvetochiy@titam.com"
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/sidebar/chosen.svg"

                        width: Palette.iconSmall
                        height: Palette.iconSmall
                        fillMode: Image.PreserveAspectFit
                    }
                }

                MouseArea {
                    id: profileCardMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: profileMenu.open()
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
        y: Math.max(Palette.spacingLg, profileRow.y - implicitHeight - Palette.spacingLg)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: Palette.radiusMd
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
