import QtQuick 6.8
import "../../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textSecondary
    property int textPixelSize: Palette.fontSizeSm

    color: textColor
    font.family: uiFontFamily
    font.pixelSize: textPixelSize
}
