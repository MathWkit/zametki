import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: control

    property url iconSource
    property int iconWidth: Palette.iconSmall
    property int iconHeight: Palette.iconSmall
    property color surfaceColor: Palette.surfaceColor
    property color hoverSurfaceColor: Palette.hover
    property color pressedSurfaceColor: Palette.selected
    property color disabledSurfaceColor: surfaceColor
    property int cornerRadius: Palette.radiusMd
    property bool clickable: true

    signal clicked

    implicitWidth: Palette.buttonHeightBase
    implicitHeight: Palette.buttonHeightBase
    color: {
        if (!control.enabled) {
            return control.disabledSurfaceColor;
        }
        if (mouseArea.pressed) {
            return control.pressedSurfaceColor;
        }
        if (mouseArea.containsMouse) {
            return control.hoverSurfaceColor;
        }
        return control.surfaceColor;
    }
    radius: cornerRadius
    opacity: control.enabled ? 1 : 0.6

    Behavior on color {
        ColorAnimation {
            duration: Palette.animationFast
        }
    }

    Image {
        anchors.centerIn: parent
        source: control.iconSource
        width: control.iconWidth
        height: control.iconHeight
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: control.clickable && control.enabled
        hoverEnabled: control.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: control.clicked()
    }
}
