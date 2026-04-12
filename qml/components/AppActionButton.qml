import QtQuick 6.8
import "../scripts/Theme.js" as Palette

AppButton {
    textColor: Palette.textPrimary
    backgroundColor: Palette.surfaceColor
    fontFamily: Palette.fontFamily
    fontPixelSize: Palette.fontSizeMd
    horizontalPadding: Palette.spacingXxl
    verticalPadding: Palette.spacingLg
    clickable: true
}
