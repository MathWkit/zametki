import QtQuick 6.8
import "../../scripts/Theme.js" as Palette
import ".."

AppInputField {
    id: control

    uiFontFamily: Palette.fontFamily
    fieldTextColor: Palette.textPrimary
    fieldPlaceholderTextColor: Palette.textSecondary
    fieldBackgroundColor: Palette.backgroundWhite
    fieldBorderColor: Palette.authInputBorder
    fieldHoverBorderColor: Palette.authInputBorderHover
    fieldFocusBorderColor: Palette.accentPrimary
    fieldErrorBorderColor: Palette.errorColor
    fieldFontPixelSize: Palette.fontSizeMd

    fieldLeftPadding: Palette.spacingXl
    fieldRightPadding: Palette.spacingXl
    fieldTopPadding: Palette.authFieldVerticalPadding
    fieldBottomPadding: Palette.authFieldVerticalPadding
    cornerRadius: Palette.radiusLg
    borderWidthNormal: Palette.inputBorderWidth
    borderWidthFocused: Palette.inputFocusBorderWidth
}
