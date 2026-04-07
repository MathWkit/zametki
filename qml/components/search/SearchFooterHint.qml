import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

RowLayout {
    id: control

    required property string iconSource
    required property string textLabel

    spacing: Palette.spacingLg

    Image {
        source: control.iconSource
        Layout.preferredWidth: Palette.iconSmall
        Layout.preferredHeight: Palette.iconSmall
    }

    AppDescriptionText {
        text: control.textLabel
        textPointSize: Palette.fontSizeSm
    }
}
