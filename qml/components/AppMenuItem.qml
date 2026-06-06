pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../scripts/Theme.js" as Palette

Rectangle {
    id: root

    property string uiFontFamily: Palette.fontFamily
    property string labelText: ""
    property string iconSource: ""
    property bool destructive: false

    signal clicked

    implicitHeight: Palette.buttonHeightBase + Palette.spacingSm
    width: parent ? parent.width : implicitWidth
    radius: Palette.radiusSm
    color: {
        if (rowMouse.pressed) {
            return Palette.selected;
        }
        if (rowMouse.containsMouse) {
            return Palette.hover;
        }
        return "transparent";
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Palette.spacingXl
        anchors.rightMargin: Palette.spacingXl
        spacing: Palette.spacingLg

        Image {
            visible: root.iconSource.length > 0
            source: root.iconSource
            width: Palette.iconSmall
            height: Palette.iconSmall
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: visible ? Palette.iconSmall : 0
        }

        AppBodyText {
            uiFontFamily: root.uiFontFamily
            textPixelSize: Palette.fontSizeMd
            text: root.labelText
            textColor: root.destructive ? Palette.errorColor : Palette.textPrimary
            Layout.fillWidth: true
        }
    }

    MouseArea {
        id: rowMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
