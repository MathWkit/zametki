import QtQuick 6.8
import ".."
import "../../scripts/Theme.js" as Palette

AppActionButton {
    textColor: Palette.textPrimary
    backgroundColor: Palette.backgroundWhite
    hoverBackgroundColor: Palette.authSocialButtonHover
    pressedBackgroundColor: Palette.authSocialButtonHover
    borderWidth: 1
    borderColor: Palette.authInputBorder
    hoverBorderColor: Palette.authInputBorder
    pressedBorderColor: Palette.authInputBorder
    fontFamily: Palette.fontFamily
    fontPixelSize: Palette.fontSizeBase
    fontWeight: Font.DemiBold
    radius: Palette.radiusLg
    implicitHeight: Palette.authSocialButtonHeight
    clickable: true
}
