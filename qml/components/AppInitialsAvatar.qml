import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: control

    property string initials: ""
    property int avatarSize: Palette.avatarBase
    property color avatarColor: Palette.accentPrimary
    property color initialsColor: Palette.textPrimary
    property string uiFontFamily: Palette.fontFamily
    property int initialsPixelSize: Palette.fontSizeXl
    property int initialsWeight: 700

    implicitWidth: avatarSize
    implicitHeight: avatarSize
    width: avatarSize
    height: avatarSize
    radius: avatarSize / 2
    color: avatarColor
    clip: true

    Text {
        anchors.centerIn: parent
        text: control.initials
        color: control.initialsColor
        font.pixelSize: control.initialsPixelSize
        font.family: control.uiFontFamily
        font.weight: control.initialsWeight
    }
}
