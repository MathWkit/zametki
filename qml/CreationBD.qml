pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Dialogs 6.8
import QtQuick.Layouts 1.15
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
        width: Math.min(parent.width - Palette.creationBdCardHorizontalMargin, Palette.creationBdMaxCardWidth)
        height: implicitHeight
        anchors.centerIn: parent
        cardColor: Palette.headerBackground
        cornerRadius: Palette.modalSurfaceRadius
        borderLineWidth: 1
        borderLineColor: Palette.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Palette.creationBdContentPadding
            spacing: Palette.creationBdColumnSpacing

            AppPageTitleText {
                text: "Создание базы данных"
                uiFontFamily: root.fontFamily
                textPixelSize: Palette.fontSizeXxl
                Layout.fillWidth: true
            }

            AppDescriptionText {
                text: "Введите название базы и выберите папку, где она будет храниться"
                uiFontFamily: root.fontFamily
                textPixelSize: Palette.fontSizeBase
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            AppInputField {
                id: databaseNameField
                placeholderText: "Название базы данных"
                uiFontFamily: root.fontFamily !== "" ? root.fontFamily : Palette.fontFamily
                selectByMouse: true
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: Palette.creationBdFolderRowSpacing
                Layout.fillWidth: true

                AppActionButton {
                    id: chooseFolderButton
                    text: "Выбрать папку"
                    fontFamily: root.fontFamily
                    fontPixelSize: Palette.fontSizeBase
                    textColor: Palette.textPrimary
                    backgroundColor: Palette.surfaceColor
                    hoverBackgroundColor: Palette.hover
                    pressedBackgroundColor: Palette.selected
                    radius: Palette.radiusMd
                    onClicked: folderDialog.open()
                }

                AppDescriptionText {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: root.selectedDirectoryPath === "" ? "Папка не выбрана" : root.selectedDirectoryPath
                    uiFontFamily: root.fontFamily
                    textPixelSize: Palette.fontSizeSm
                    elide: Text.ElideMiddle
                }
            }

            AppDescriptionText {
                visible: root.errorText.length > 0
                text: root.errorText
                uiFontFamily: root.fontFamily
                textPixelSize: Palette.fontSizeSm
                textColor: Palette.errorColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            AppActionButton {
                id: createButton
                text: "Создать"
                fontFamily: root.fontFamily
                fontPixelSize: Palette.fontSizeMd
                fontWeight: Font.DemiBold
                textColor: Palette.textPrimary
                backgroundColor: Palette.accentPrimary
                hoverBackgroundColor: Palette.authAccentHover
                pressedBackgroundColor: Palette.authAccentPressed
                disabledBackgroundColor: Palette.authInputBorder
                radius: Palette.radiusLg
                implicitHeight: Palette.buttonHeightLarge
                enabled: databaseNameField.text.trim().length > 0 && root.selectedDirectoryPath.length > 0
                onClicked: {
                    root.errorText = "";
                    root.createDatabaseRequested(databaseNameField.text, root.selectedDirectoryPath);
                }
                Layout.fillWidth: true
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
