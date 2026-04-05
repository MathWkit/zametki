import QtQuick 6.8

Rectangle {
    id: control

    property alias text: label.text
    property color textColor: "#0f1724"
    property color backgroundColor: "#f1f5f9"
    property string fontFamily: "Inter"
    property string fontStyleName: "Regular"
    property int fontPointSize: 14
    property int horizontalPadding: 12
    property int verticalPadding: 12
    property bool clickable: false

    signal clicked

    radius: 6
    color: backgroundColor
    implicitWidth: label.implicitWidth + horizontalPadding * 2
    implicitHeight: label.implicitHeight + verticalPadding * 2

    Text {
        id: label
        anchors.centerIn: parent
        color: control.textColor
        font.family: control.fontFamily
        font.styleName: control.fontStyleName
        font.pointSize: control.fontPointSize
    }

    MouseArea {
        anchors.fill: parent
        enabled: control.clickable
        hoverEnabled: enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: control.clicked()
    }
}
