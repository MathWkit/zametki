import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color textColor: Palette.textSecondary
    property int textPointSize: Palette.fontSizeBase

    font.styleName: "Regular"
    font.pointSize: textPointSize
    font.family: uiFontFamily
    color: textColor
}
