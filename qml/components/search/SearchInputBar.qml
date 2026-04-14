import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

AppSectionCard {
    id: control

    property alias text: searchField.text
    property string placeholderText: qsTr("Поиск по заметкам, папкам, тегам и командам...")
    property string iconSource: "qrc:/qt/qml/zametki/assets/icons/sidebar/search.svg"

    signal accepted(string query)
    signal queryChanged(string query)

    Layout.fillWidth: true
    implicitHeight: Math.max(Palette.controlHeightBase, searchField.implicitHeight)
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

        AppInputField {
            id: searchField
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText: control.placeholderText
            fieldBackgroundColor: "transparent"
            fieldBorderColor: "transparent"
            fieldHoverBorderColor: "transparent"
            fieldFocusBorderColor: "transparent"
            borderWidthNormal: 0
            borderWidthFocused: 0
            fieldLeftPadding: Palette.spacingSm
            fieldRightPadding: Palette.spacingSm
            fieldTopPadding: Palette.spacingLg
            fieldBottomPadding: Palette.spacingLg
            fieldFontPixelSize: Palette.fontSizeMd
            onAccepted: control.accepted(text)
            onTextChanged: control.queryChanged(text)
        }
    }
}
