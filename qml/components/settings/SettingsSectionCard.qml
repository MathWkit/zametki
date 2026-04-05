import QtQuick 6.8
import QtQuick.Layouts 1.15

Rectangle {
    property color cardColor: "#FFFFFF"
    property color borderLineColor: "#14000000"
    property int borderLineWidth: 1
    property int cornerRadius: 8

    radius: cornerRadius
    color: cardColor
    border.color: borderLineColor
    border.width: borderLineWidth
    Layout.fillWidth: true
}
