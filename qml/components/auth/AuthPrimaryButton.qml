import QtQuick 6.8
import ".."
import "../../scripts/Theme.js" as Palette

AppActionButton {
    textColor: Palette.backgroundWhite
    backgroundColor: Palette.accentPrimary
    hoverBackgroundColor: Palette.authAccentHover
    pressedBackgroundColor: Palette.authAccentPressed
    fontFamily: Palette.fontFamily
    fontPixelSize: Palette.fontSizeMd
    fontWeight: Font.DemiBold
    radius: Palette.radiusLg
    implicitHeight: Palette.buttonHeightLarge
    clickable: true
}
