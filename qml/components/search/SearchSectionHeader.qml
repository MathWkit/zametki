import QtQuick 6.8
import "../../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textSecondary

    color: textColor
    font.family: uiFontFamily
    font.pixelSize: Palette.fontSizeSm
    font.weight: Font.DemiBold
}
