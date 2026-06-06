pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import "../scripts/Theme.js" as Palette

Popup {
    id: root

    property string uiFontFamily: Palette.fontFamily
    property int menuWidth: 220

    default property alias content: menuColumn.data

    modal: false
    focus: true
    padding: Palette.spacingSm
    width: menuWidth + padding * 2
    height: menuColumn.implicitHeight + padding * 2
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        anchors.fill: parent
        radius: Palette.radiusMd
        color: Palette.headerBackground
        border.width: 1
        border.color: Palette.border
    }

    contentItem: Column {
        id: menuColumn
        width: root.menuWidth
        spacing: Palette.spacingXs
    }
}
