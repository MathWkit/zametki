import QtQuick 6.8
import QtQuick.Layouts 1.15
import "../../scripts/Theme.js" as Palette
import ".."

RowLayout {
    id: control

    required property string keyText
    required property string valueText

    property string uiFontFamily: Palette.fontFamily
    property color keyColor: Palette.textPrimary
    property color valueColor: Palette.textSecondary
    property int leftMargin: Palette.contentInset

    Layout.leftMargin: leftMargin
    Layout.fillWidth: true
    Layout.fillHeight: false

    Text {
        text: control.keyText
        color: control.keyColor
        font.family: control.uiFontFamily
    }

    AppDescriptionText {
        text: control.valueText
        uiFontFamily: control.uiFontFamily
        textColor: control.valueColor
    }

    Item {
        Layout.fillWidth: true
    }
}
