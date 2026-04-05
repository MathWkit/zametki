import QtQuick 6.8
import QtQuick.Layouts 1.15

Rectangle {
    property color cardColor: "#ffffff"
        property color borderLineColor: "#14000000"
            property int cornerRadius: 8

                radius: cornerRadius
                color: cardColor
                border.color: borderLineColor
                border.width: 1
                Layout.fillWidth: true
            }
