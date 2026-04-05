import QtQuick 6.8
import QtQuick.Layouts 1.15

RowLayout {
    property int rowLeftMargin: 18
        property int rowRightMargin: 0
            property int rowTopMargin: 16
                property int rowBottomMargin: 16

                    Layout.leftMargin: rowLeftMargin
                    Layout.rightMargin: rowRightMargin
                    Layout.topMargin: rowTopMargin
                    Layout.bottomMargin: rowBottomMargin
                }
