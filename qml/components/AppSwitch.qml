import QtQuick 6.8
import QtQuick.Controls 6.8
import "../scripts/Theme.js" as Palette

Switch {
    id: control

    property color activeColor: Palette.accentPrimary
    property color inactiveTrackColor: Palette.backgroundWhite
    property color inactiveHandleColor: Palette.border

    indicator: Rectangle {
        width: Palette.switchTrackWidth
        height: Palette.switchTrackHeight
        radius: height / 2

        color: control.checked ? control.activeColor : control.inactiveTrackColor
        border.color: control.checked ? control.inactiveTrackColor : control.inactiveHandleColor

        Rectangle {
            readonly property int margin: Palette.switchHandleMargin
            width: parent.height - margin * 2
            height: width
            radius: width / 2
            x: control.checked ? parent.width - width - margin : margin
            y: (parent.height - height) / 2
            color: control.checked ? control.inactiveTrackColor : control.inactiveHandleColor
        }
    }
}
