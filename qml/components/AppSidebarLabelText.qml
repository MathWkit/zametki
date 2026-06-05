import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textSecondary

    font.styleName: "Medium"
    font.pixelSize: Palette.fontSizeMd
    font.family: uiFontFamily
    color: textColor
}
