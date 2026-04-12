import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: control

    property url iconSource
    property int iconWidth: Palette.iconSmall
    property int iconHeight: Palette.iconSmall
    property color surfaceColor: Palette.surfaceColor
    property int cornerRadius: Palette.radiusMd

    signal clicked

    implicitWidth: Palette.buttonHeightBase
    implicitHeight: Palette.buttonHeightBase
    color: mouseArea.containsMouse ? Palette.hover : surfaceColor
    radius: cornerRadius

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
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }
}
