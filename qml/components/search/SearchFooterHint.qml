import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

RowLayout {
    id: control

    required property string iconSource
    required property string textLabel

    spacing: 6

    Image {
        source: control.iconSource
        Layout.preferredWidth: 14
        Layout.preferredHeight: 14
    }

    AppDescriptionText {
        text: control.textLabel
        textPointSize: Palette.fontSizeSm
    }
}
