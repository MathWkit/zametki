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
    property color rowPressedColor: Palette.selected
    property color titleColor: Palette.textPrimary
    property color subtitleColor: Palette.textSecondary
    property bool showHover: true

    signal clicked

    Layout.fillWidth: true
    implicitHeight: subtitleText.length > 0 ? Palette.searchResultRowHeightWithSubtitle : Palette.searchResultRowHeight
    color: {
        if (!showHover) {
            return rowColor;
        }
        if (rowMouseArea.pressed) {
            return rowPressedColor;
        }
        if (rowMouseArea.containsMouse) {
            return rowHoverColor;
        }
        return rowColor;
    }
    radius: Palette.radiusMd

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Palette.searchInset
        anchors.rightMargin: Palette.searchInset
        spacing: Palette.searchCompactGap

        Image {
            source: control.iconSource
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: Palette.iconSmall
            Layout.preferredHeight: Palette.iconSmall
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: Palette.spacingXs
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
                textPixelSize: Palette.fontSizeSm
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
