pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Dialogs 6.8
import "scripts/Theme.js" as Palette
import "components"

Rectangle {
    id: root

    property string fontFamily: ""
    property string selectedDirectoryPath: ""
    property string errorText: ""

    signal createDatabaseRequested(string databaseName, string parentDirectoryPath)

    color: Palette.overlayScrim

    AppSectionCard {
        width: Math.min(parent.width - 40, 480)
        height: implicitHeight
        anchors.centerIn: parent
        cardColor: Palette.headerBackground
        cornerRadius: 8
        borderLineWidth: 1
        borderLineColor: Palette.border

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            AppPageTitleText {
                text: "CreationBD"
                uiFontFamily: root.fontFamily
                textPointSize: 20
            }

            AppDescriptionText {
                text: "Введите название базы и выберите папку, где она будет храниться"
                uiFontFamily: root.fontFamily
                textPointSize: 13
                wrapMode: Text.WordWrap
            }

            AppInputField {
                id: databaseNameField
                placeholderText: "Название базы данных"
                font.family: root.fontFamily
                selectByMouse: true
            }

            Row {
                spacing: 8
                width: parent.width

                AppActionButton {
                    id: chooseFolderButton
                    text: "Выбрать папку"
                    fontFamily: root.fontFamily
                    fontPointSize: Palette.fontSizeBase
                    textColor: Palette.textPrimary
                    backgroundColor: Palette.surfaceColor
                    hoverBackgroundColor: Palette.hover
                    pressedBackgroundColor: Palette.selected
                    radius: Palette.radiusMd
                    onClicked: folderDialog.open()
                }

                AppDescriptionText {
                    width: parent.width - 140
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.selectedDirectoryPath === "" ? "Папка не выбрана" : root.selectedDirectoryPath
                    uiFontFamily: root.fontFamily
                    textPointSize: 12
                    elide: Text.ElideMiddle
                }
            }

            AppDescriptionText {
                visible: root.errorText.length > 0
                text: root.errorText
                uiFontFamily: root.fontFamily
                textPointSize: 12
                textColor: Palette.errorColor
                wrapMode: Text.WordWrap
            }

            AppActionButton {
                id: createButton
                text: "Создать"
                fontFamily: root.fontFamily
                fontPointSize: Palette.fontSizeMd
                fontWeight: Font.DemiBold
                textColor: Palette.backgroundWhite
                backgroundColor: Palette.accentPrimary
                hoverBackgroundColor: Palette.authAccentHover
                pressedBackgroundColor: Palette.authAccentPressed
                disabledBackgroundColor: Palette.authInputBorder
                radius: Palette.radiusLg
                implicitHeight: Palette.buttonHeightBase
                enabled: databaseNameField.text.trim().length > 0 && root.selectedDirectoryPath.length > 0
                onClicked: {
                    root.errorText = "";
                    root.createDatabaseRequested(databaseNameField.text, root.selectedDirectoryPath);
                }
            }
        }
    }

    FolderDialog {
        id: folderDialog
        title: "Выберите папку для базы данных"
        onAccepted: {
            root.selectedDirectoryPath = String(selectedFolder);
            root.errorText = "";
        }
    }
}
