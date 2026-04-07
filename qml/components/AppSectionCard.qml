import QtQuick 6.8
import QtQuick.Layouts 1.15
import "../scripts/Theme.js" as Palette

Rectangle {
    property color cardColor: Palette.backgroundWhite
    property color borderLineColor: Palette.border
    property int borderLineWidth: 1
    property int cornerRadius: Palette.radiusLg

    radius: cornerRadius
    color: cardColor
    border.color: borderLineColor
    border.width: borderLineWidth
    Layout.fillWidth: true
}
