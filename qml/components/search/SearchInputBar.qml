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
    implicitHeight: Palette.controlHeightBase
    cardColor: Palette.backgroundLight
    borderLineColor: Palette.border

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
