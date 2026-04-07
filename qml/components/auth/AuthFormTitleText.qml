import QtQuick 6.8
import "../../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textPrimary
    property int textPixelSize: Palette.fontSizeXxl

    color: textColor
    font.family: uiFontFamily
    font.pixelSize: textPixelSize
    font.weight: Font.DemiBold
}
