import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

Rectangle {
    id: control

    required property string iconSource
    required property string titleText
    property string subtitleText: ""
    property color rowColor: "transparent"
    property color rowHoverColor: Palette.hover
    property color titleColor: Palette.textPrimary
    property color subtitleColor: Palette.textSecondary
    property bool showHover: true

    signal clicked

    Layout.fillWidth: true
    implicitHeight: subtitleText.length > 0 ? 48 : 40
    color: rowMouseArea.containsMouse && showHover ? rowHoverColor : rowColor
    radius: Palette.radiusMd

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Palette.spacingXxl
        anchors.rightMargin: Palette.spacingXxl
        spacing: Palette.spacingLg

        Image {
            source: control.iconSource
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 1
            Layout.fillWidth: true

            AppBodyText {
                text: control.titleText
                textColor: control.titleColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            AppDescriptionText {
                visible: control.subtitleText.length > 0
                text: control.subtitleText
                textColor: control.subtitleColor
                textPointSize: Palette.fontSizeSm
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    MouseArea {
        id: rowMouseArea
        anchors.fill: parent
        hoverEnabled: control.showHover
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }
}
