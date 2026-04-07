import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

AppSectionCard {
    id: control

    property alias text: searchField.text
    property string placeholderText: qsTr("Search for notes, folders, tags, or commands...")
    property string iconSource: "qrc:/qt/qml/zametki/assets/icons/sidebar/search.svg"

    signal accepted(string query)
    signal queryChanged(string query)

    Layout.fillWidth: true
    implicitHeight: 40
    cardColor: Palette.backgroundLight
    borderLineColor: Palette.border

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 10

        Image {
            source: control.iconSource
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText: control.placeholderText
            color: Palette.textPrimary
            placeholderTextColor: Palette.textSecondary
            font.pixelSize: Palette.fontSizeMd
            font.family: Palette.fontFamily
            onAccepted: control.accepted(text)
            onTextChanged: control.queryChanged(text)

            background: Rectangle {
                color: "transparent"
                border.width: 0
            }
        }
    }
}
