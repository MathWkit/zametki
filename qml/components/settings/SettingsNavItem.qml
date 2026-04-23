import QtQuick 6.8
import QtQuick.Layouts 1.15
import "../../scripts/Theme.js" as Palette
import ".."

Rectangle {
    id: control

    required property string iconSource
    required property string titleText
    property bool active: false

    property string uiFontFamily: Palette.fontFamily
    property color activeBackgroundColor: Palette.accentSidebar
    property color hoverBackgroundColor: Palette.hover
    property color pressedBackgroundColor: Palette.selected
    property color activeTextColor: Palette.textPrimary
    property color textColor: Palette.textSecondary
    property bool clickable: true

    signal clicked

    color: {
        if (active) {
            return activeBackgroundColor;
        }
        if (navMouseArea.pressed && clickable) {
            return pressedBackgroundColor;
        }
        if (navMouseArea.containsMouse && clickable) {
            return hoverBackgroundColor;
        }
        return "transparent";
    }
    radius: Palette.radiusMd
    Layout.fillWidth: true
    implicitHeight: navLayout.implicitHeight + (Palette.spacingXl * 2)
    implicitWidth: navLayout.implicitWidth + (Palette.spacingXl * 2)

    RowLayout {
        id: navLayout
        anchors.fill: parent
        anchors.margins: Palette.spacingXl
        spacing: Palette.spacingXl

        Image {
            source: control.iconSource
            Layout.preferredHeight: Palette.iconMedium
            Layout.preferredWidth: Palette.iconMedium
        }

        AppSidebarLabelText {
            text: control.titleText
            uiFontFamily: control.uiFontFamily
            textColor: control.active ? control.activeTextColor : control.textColor
        }
    }

    MouseArea {
        id: navMouseArea
        anchors.fill: parent
        enabled: control.clickable
        hoverEnabled: control.clickable
        cursorShape: control.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: control.clicked()
    }
}
