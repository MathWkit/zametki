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
    color: surfaceColor
    radius: cornerRadius

    TapHandler {
        onTapped: control.clicked()
    }

    Image {
        anchors.centerIn: parent
        source: control.iconSource
        width: control.iconWidth
        height: control.iconHeight
        fillMode: Image.PreserveAspectFit
    }
}
