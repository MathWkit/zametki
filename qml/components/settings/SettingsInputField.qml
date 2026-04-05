import QtQuick 6.8
import QtQuick.Controls 2.15

TextField {
    id: control

    property color fieldTextColor: "#0F1724"
        property color fieldBackgroundColor: "#FFFFFF"
            property color fieldBorderColor: "#14000000"
                property int cornerRadius: 6
                    property int fieldTopPadding: 12
                        property int fieldBottomPadding: 12

                            color: fieldTextColor
                            topPadding: fieldTopPadding
                            bottomPadding: fieldBottomPadding

                            background: Rectangle {
                                radius: control.cornerRadius
                                color: control.fieldBackgroundColor
                                border.color: control.fieldBorderColor
                                border.width: 1
                            }
                        }
