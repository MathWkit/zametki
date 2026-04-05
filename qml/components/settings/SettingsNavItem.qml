import QtQuick 6.8
import QtQuick.Layouts 1.15

Rectangle {
    id: control

    required property string iconSource
    required property string titleText
    property bool active: false

    property string uiFontFamily: "Inter"
    property color activeBackgroundColor: "#E6F0FF"
    property color activeTextColor: "#0B74DE"
    property color textColor: "#6B7280"

    color: active ? activeBackgroundColor : "transparent"
    radius: 6
    Layout.fillWidth: true
    implicitHeight: navLayout.implicitHeight + 24
    implicitWidth: navLayout.implicitWidth + 24

    RowLayout {
        id: navLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Image {
            source: control.iconSource
            Layout.preferredHeight: 18
            Layout.preferredWidth: 18
        }

        SettingsSidebarLabelText {
            text: control.titleText
            uiFontFamily: control.uiFontFamily
            textColor: control.active ? control.activeTextColor : control.textColor
        }
    }
}
