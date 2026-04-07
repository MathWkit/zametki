import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette

Rectangle {
    id: control

    property var hintsModel: []

    Layout.fillWidth: true
    implicitHeight: 44
    color: Palette.backgroundLight
    border.width: 1
    border.color: Palette.border

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 14
        spacing: 14

        Repeater {
            model: control.hintsModel

            SearchFooterHint {
                required property var modelData

                iconSource: modelData.icon
                textLabel: modelData.label
            }
        }
    }
}
