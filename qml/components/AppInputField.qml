import QtQuick 6.8
import QtQuick.Controls 2.15
import "../scripts/Theme.js" as Palette

TextField {
    id: control

    property string uiFontFamily: Palette.fontFamily
    property color fieldTextColor: Palette.textPrimary
    property color fieldPlaceholderTextColor: Palette.textSecondary
    property color fieldBackgroundColor: Palette.backgroundWhite
    property color fieldBorderColor: Palette.border
    property color fieldHoverBorderColor: fieldBorderColor
    property color fieldFocusBorderColor: fieldBorderColor
    property color fieldErrorBorderColor: Palette.errorColor
    property bool hasError: false
    property int cornerRadius: Palette.radiusMd
    property int fieldFontPixelSize: Palette.fontSizeMd
    property int fieldLeftPadding: Palette.spacingXl
    property int fieldRightPadding: Palette.spacingXl
    property int fieldTopPadding: Palette.space2 - Palette.spacingSm
    property int fieldBottomPadding: Palette.space2 - Palette.spacingSm
    property int borderWidthNormal: Palette.inputBorderWidth
    property int borderWidthFocused: Palette.inputFocusBorderWidth

    hoverEnabled: true
    color: fieldTextColor
    font.family: uiFontFamily
    font.pixelSize: fieldFontPixelSize
    placeholderTextColor: fieldPlaceholderTextColor
    leftPadding: fieldLeftPadding
    rightPadding: fieldRightPadding
    topPadding: fieldTopPadding
    bottomPadding: fieldBottomPadding

    background: Rectangle {
        radius: control.cornerRadius
        color: control.fieldBackgroundColor
        border.width: control.activeFocus ? control.borderWidthFocused : control.borderWidthNormal
        border.color: control.hasError ? control.fieldErrorBorderColor : (control.activeFocus ? control.fieldFocusBorderColor : (control.hovered ? control.fieldHoverBorderColor : control.fieldBorderColor))
    }
}
