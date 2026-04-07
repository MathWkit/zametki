import QtQuick 6.8
import QtQuick.Layouts 1.15
import ".."

RowLayout {
    id: control

    required property string keyText
    required property string valueText

    property string uiFontFamily: "Inter"
    property color keyColor: "#0F1724"
    property color valueColor: "#6B7280"
    property int leftMargin: 18

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
