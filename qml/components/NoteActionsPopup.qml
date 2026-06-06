pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import "../scripts/Theme.js" as Palette

Popup {
    id: root

    property string targetItemKey: ""
    property string uiFontFamily: Palette.fontFamily

    readonly property int menuWidth: 260

    signal actionTriggered(string actionKey)

    modal: false
    focus: true
    padding: 6
    width: menuWidth + padding * 2
    height: menuColumn.implicitHeight + padding * 2
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        anchors.fill: parent
        radius: Palette.radiusMd
        color: Palette.surfaceColor
        border.width: 1
        border.color: Palette.border
    }

    contentItem: Column {
        id: menuColumn
        width: root.menuWidth
        spacing: 2

        component MenuRow: Rectangle {
            id: menuRow

            required property string actionKey
            required property string labelText

            width: menuColumn.width
            height: 34
            radius: Palette.radiusSm
            color: rowMouse.containsMouse ? Palette.hover : "transparent"

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: menuRow.labelText
                font.family: root.uiFontFamily
                font.pixelSize: Palette.fontSizeBase
                color: Palette.textPrimary
            }

            MouseArea {
                id: rowMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.actionTriggered(menuRow.actionKey)
                    root.close()
                }
            }
        }

        MenuRow {
            actionKey: "duplicate"
            labelText: "Дублировать"
        }

        MenuRow {
            actionKey: "move"
            labelText: "Переместить"
        }

        Rectangle {
            width: menuColumn.width
            height: 1
            color: Palette.border
        }

        MenuRow {
            actionKey: "upload"
            labelText: "Выгрузить на сервер"
        }

        MenuRow {
            actionKey: "download"
            labelText: "Подтянуть с сервера"
        }

        Rectangle {
            width: menuColumn.width
            height: 1
            color: Palette.border
        }

        MenuRow {
            actionKey: "delete"
            labelText: "Удалить"
        }
    }
}
