import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette

Item {
    id: control

    property string labelText: qsTr("или")
    property string uiFontFamily: Palette.fontFamily
    property color lineColor: Palette.authInputBorder
    property color labelColor: Palette.textSecondary

    Layout.fillWidth: true
    implicitHeight: Palette.spacingHuge

    Rectangle {
        anchors.left: parent.left
        anchors.right: label.left
        anchors.rightMargin: Palette.spacingLg
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: control.lineColor
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: control.labelText
        color: control.labelColor
        font.family: control.uiFontFamily
        font.pixelSize: Palette.fontSizeSm
    }

    Rectangle {
        anchors.left: label.right
        anchors.leftMargin: Palette.spacingLg
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: control.lineColor
    }
}
