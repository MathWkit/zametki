import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textPrimary
    property int textPixelSize: Palette.fontSizeBase

    font.styleName: "Regular"
    font.pixelSize: textPixelSize
    font.family: uiFontFamily
    color: textColor
}
