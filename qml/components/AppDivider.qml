import QtQuick 6.8
import QtQuick.Layouts 1.15
import "../scripts/Theme.js" as Palette

Rectangle {
    property color dividerColor: Palette.dividerColor

    color: dividerColor
    Layout.preferredHeight: 1
    Layout.fillWidth: true
}
