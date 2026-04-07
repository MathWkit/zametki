import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textPrimary

    font.styleName: "Regular"
    font.pointSize: Palette.fontSizeBase
    font.family: uiFontFamily
    color: textColor
}
