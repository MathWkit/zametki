import QtQuick 6.8
import QtQuick.Controls 6.8
import "../../scripts/Theme.js" as Palette

TabButton {
    id: control

    property string uiFontFamily: Palette.fontFamily
    property color selectedColor: Palette.accentPrimary
    property color hoverColor: Palette.selected
    property color normalTextColor: Palette.textPrimary

    font.family: uiFontFamily
    font.pixelSize: Palette.fontSizeBase
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.checked ? Palette.backgroundWhite : control.normalTextColor
    }

    background: Rectangle {
        radius: Palette.radiusLg
        color: control.checked ? control.selectedColor : (control.hovered ? control.hoverColor : "transparent")
    }
}
