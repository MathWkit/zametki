pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Window 6.8

Window {
    id: settingsWindow
    width: 1200
    height: 800
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr("Settings")

    Settings {
        anchors.fill: parent
    }
}
