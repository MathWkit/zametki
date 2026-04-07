import QtQuick 6.8
import QtQuick.Controls 6.8
import "../../scripts/Theme.js" as Palette

TextField {
    id: control

    property string uiFontFamily: Palette.fontFamily
    property color fieldTextColor: Palette.textPrimary
    property color fieldPlaceholderTextColor: Palette.textSecondary
    property color fieldBackgroundColor: Palette.backgroundWhite
    property color fieldBorderColor: Palette.authInputBorder
    property color fieldHoverBorderColor: Palette.authInputBorderHover
    property color fieldFocusBorderColor: Palette.accentPrimary
    property color fieldErrorBorderColor: Palette.errorColor
    property bool hasError: false
    property int fieldFontPixelSize: Palette.fontSizeMd

    selectByMouse: true
    hoverEnabled: true
    color: fieldTextColor
    font.family: uiFontFamily
    font.pixelSize: fieldFontPixelSize
    placeholderTextColor: fieldPlaceholderTextColor
    leftPadding: Palette.spacingXl
    rightPadding: Palette.spacingXl
    topPadding: Palette.authFieldVerticalPadding
    bottomPadding: Palette.authFieldVerticalPadding

    background: Rectangle {
        radius: Palette.radiusLg
        color: control.fieldBackgroundColor
        border.width: control.activeFocus ? 2 : 1
        border.color: control.hasError
            ? control.fieldErrorBorderColor
            : (control.activeFocus
                ? control.fieldFocusBorderColor
                : (control.hovered ? control.fieldHoverBorderColor : control.fieldBorderColor))
    }
}
