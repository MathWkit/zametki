import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: control

    property alias text: label.text
    property color textColor: Palette.textPrimary
    property color disabledTextColor: textColor
    property color backgroundColor: Palette.surfaceColor
    property color hoverBackgroundColor: backgroundColor
    property color pressedBackgroundColor: hoverBackgroundColor
    property color disabledBackgroundColor: backgroundColor
    property color borderColor: "transparent"
    property color hoverBorderColor: borderColor
    property color pressedBorderColor: hoverBorderColor
    property color disabledBorderColor: borderColor
    property string fontFamily: Palette.fontFamily
    property string fontStyleName: "Regular"
    property int fontPixelSize: Palette.fontSizeMd
    property int fontWeight: Font.Normal
    property bool underlineOnHover: false
    property int horizontalPadding: Palette.spacingXl
    property int verticalPadding: Palette.spacingXl
    property int borderWidth: 0
    property real disabledOpacity: 0.6
    property bool clickable: false

    readonly property bool hovered: buttonMouseArea.containsMouse
    readonly property bool pressed: buttonMouseArea.pressed

    signal clicked

    radius: Palette.radiusMd
    color: {
        if (!control.enabled) {
            return control.disabledBackgroundColor;
        }

        if (control.pressed) {
            return control.pressedBackgroundColor;
        }

        if (control.hovered) {
            return control.hoverBackgroundColor;
        }

        return control.backgroundColor;
    }
    border.width: control.borderWidth
    border.color: {
        if (!control.enabled) {
            return control.disabledBorderColor;
        }

        if (control.pressed) {
            return control.pressedBorderColor;
        }

        if (control.hovered) {
            return control.hoverBorderColor;
        }

        return control.borderColor;
    }
    opacity: control.enabled ? 1 : control.disabledOpacity
    implicitWidth: label.implicitWidth + horizontalPadding * 2
    implicitHeight: label.implicitHeight + verticalPadding * 2

    Text {
        id: label
        anchors.centerIn: parent
        color: control.enabled ? control.textColor : control.disabledTextColor
        font.family: control.fontFamily
        font.styleName: control.fontStyleName
        font.pixelSize: control.fontPixelSize
        font.weight: control.fontWeight
        font.underline: control.underlineOnHover && control.hovered
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        enabled: control.clickable && control.enabled
        hoverEnabled: control.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: control.clicked()
    }
}
