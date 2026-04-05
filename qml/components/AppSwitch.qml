import QtQuick 6.8
import QtQuick.Controls 2.15

Switch {
    id: control

    property color activeColor: "#0B74DE"
    property color inactiveTrackColor: "#ffffff"
    property color inactiveHandleColor: Qt.rgba(0, 0, 0, 0.08)

    indicator: Rectangle {
        width: 45
        height: 25
        radius: height / 2

        color: control.checked ? control.activeColor : control.inactiveTrackColor
        border.color: control.checked ? control.inactiveTrackColor : control.inactiveHandleColor

        Rectangle {
            width: parent.height - 6
            height: width
            radius: width / 2
            x: control.checked ? parent.width - width - 3 : 3
            y: (parent.height - height) / 2
            color: control.checked ? control.inactiveTrackColor : control.inactiveHandleColor
        }
    }
}
