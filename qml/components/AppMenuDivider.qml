import QtQuick 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    property int lineWidth: parent ? parent.width : 0

    width: lineWidth
    height: 1
    color: Palette.border
}
