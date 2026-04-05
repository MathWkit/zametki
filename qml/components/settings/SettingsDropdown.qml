import QtQuick 6.8
import QtQuick.Controls 2.15

ComboBox {
    id: control

    property string uiFontFamily: "Inter"
    property color dropdownTextColor: "#0F1724"
    property color dropdownSecondaryTextColor: "#667085"
    property color dropdownBackgroundColor: "#FFFFFF"
    property color dropdownBorderColor: "#14000000"
    property int dropdownBorderWidth: 1
    property color optionHoverColor: "#F1F5F9"
    property color optionTextColor: "#0F1724"
    property string indicatorSource: "qrc:/qt/qml/zametki/assets/icons/unused/open-bracket.svg"
    property int leftTextPadding: 12
    property int rightTextPadding: 28

    topPadding: 8
    bottomPadding: 8

    contentItem: Text {
        text: control.displayText
        color: control.dropdownTextColor
        leftPadding: control.leftTextPadding
        rightPadding: control.rightTextPadding
        verticalAlignment: Text.AlignVCenter
        font.family: control.uiFontFamily
    }

    indicator: Image {
        source: control.indicatorSource
        width: 12
        height: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
    }

    background: Rectangle {
        radius: 6
        color: control.dropdownBackgroundColor
        border.color: control.dropdownBorderColor
        border.width: control.dropdownBorderWidth
    }

    delegate: ItemDelegate {
        id: optionDelegate
        required property string modelData

        width: ListView.view ? ListView.view.width : implicitWidth

        background: Rectangle {
            color: optionDelegate.hovered ? control.optionHoverColor : control.dropdownBackgroundColor
        }

        contentItem: Text {
            text: optionDelegate.modelData
            color: control.optionTextColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: 12
            font.family: control.uiFontFamily
        }
    }

    popup: Popup {
        y: control.height + 6
        width: control.width
        padding: 0

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
        }

        background: Rectangle {
            radius: 6
            color: control.dropdownBackgroundColor
            border.color: control.dropdownBorderColor
            border.width: control.dropdownBorderWidth
        }
    }
}
