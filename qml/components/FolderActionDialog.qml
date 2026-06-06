pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../scripts/Theme.js" as Palette

Popup {
    id: root

    property string uiFontFamily: Palette.fontFamily
    property string mode: "move"
    property string targetFolderPath: ""

    signal submitted(string value)
    signal cancelled()

    modal: true
    dim: true
    focus: true
    padding: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    anchors.centerIn: Overlay.overlay
    width: Math.min(Overlay.overlay.width - Palette.creationBdCardHorizontalMargin, 400)
    height: dialogColumn.implicitHeight

    onOpened: {
        pathField.text = "";
        Qt.callLater(function () {
            pathField.forceActiveFocus();
        });
    }

    onClosed: {
        pathField.text = "";
    }

    background: Rectangle {
        anchors.fill: parent
        radius: Palette.modalSurfaceRadius
        color: Palette.headerBackground
        border.width: 1
        border.color: Palette.border
    }

    contentItem: ColumnLayout {
        id: dialogColumn
        width: root.width
        spacing: Palette.creationBdColumnSpacing

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Palette.creationBdContentPadding
        }

        AppPageTitleText {
            Layout.leftMargin: Palette.creationBdContentPadding
            Layout.rightMargin: Palette.creationBdContentPadding
            text: root.mode === "create" ? "Создать папку" : "Переместить заметку"
            uiFontFamily: root.uiFontFamily
            textPixelSize: Palette.fontSizeXl
            Layout.fillWidth: true
        }

        AppDescriptionText {
            text: root.mode === "create"
                  ? "Введите имя новой папки"
                  : "Укажите папку назначения. Оставьте поле пустым, чтобы переместить в корень."
            uiFontFamily: root.uiFontFamily
            textPixelSize: Palette.fontSizeBase
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.leftMargin: Palette.creationBdContentPadding
            Layout.rightMargin: Palette.creationBdContentPadding
        }

        AppInputField {
            id: pathField
            Layout.fillWidth: true
            Layout.leftMargin: Palette.creationBdContentPadding
            Layout.rightMargin: Palette.creationBdContentPadding
            Layout.preferredHeight: Palette.inputHeightBase
            uiFontFamily: root.uiFontFamily
            selectByMouse: true
            placeholderText: root.mode === "create" ? "Имя папки" : "Папка/подпапка"
            Keys.onReturnPressed: root.submit()
            Keys.onEnterPressed: root.submit()
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: Palette.spacingXl
            Layout.minimumHeight: Palette.buttonHeightLarge
            Layout.leftMargin: Palette.creationBdContentPadding
            Layout.rightMargin: Palette.creationBdContentPadding
            spacing: Palette.spacingLg

            Item { Layout.fillWidth: true }

            AppActionButtonCompact {
                text: "Отмена"
                fontFamily: root.uiFontFamily
                Layout.minimumHeight: Palette.buttonHeightBase
                onClicked: {
                    root.cancelled();
                    root.close();
                }
            }

            AppActionButton {
                text: root.mode === "create" ? "Создать" : "Переместить"
                fontFamily: root.uiFontFamily
                fontPixelSize: Palette.fontSizeMd
                fontWeight: Font.DemiBold
                textColor: Palette.textPrimary
                backgroundColor: Palette.accentPrimary
                hoverBackgroundColor: Palette.selected
                pressedBackgroundColor: Palette.selected
                Layout.minimumHeight: Palette.buttonHeightBase
                onClicked: root.submit()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Palette.creationBdContentPadding
        }
    }

    function submit() {
        if (root.mode === "create" && pathField.text.trim().length === 0) {
            return;
        }
        root.submitted(pathField.text.trim());
        root.close();
    }
}
