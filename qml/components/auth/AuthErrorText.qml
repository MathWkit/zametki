import QtQuick 6.8
import "../../scripts/Theme.js" as Palette

Text {
    property string uiFontFamily: Palette.fontFamily
    property color errorTextColor: Palette.errorColor

    visible: text.length > 0
    color: errorTextColor
    font.family: uiFontFamily
    font.pixelSize: Palette.fontSizeSm
    wrapMode: Text.WordWrap
}
