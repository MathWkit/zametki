import QtQuick 6.8
import ".."
import "../../scripts/Theme.js" as Palette

AppActionButton {
    textColor: Palette.accentPrimary
    backgroundColor: "transparent"
    hoverBackgroundColor: "transparent"
    pressedBackgroundColor: "transparent"
    fontFamily: Palette.fontFamily
    fontPixelSize: Palette.fontSizeSm
    horizontalPadding: 0
    verticalPadding: 0
    underlineOnHover: false
    clickable: true
}
