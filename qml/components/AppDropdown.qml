import QtQuick 6.8
import QtQuick.Controls 2.15
import "../scripts/Theme.js" as Palette

ComboBox {
    id: control

    property string uiFontFamily: Palette.fontFamily
    property color dropdownTextColor: Palette.textPrimary
    property color dropdownBackgroundColor: Palette.backgroundWhite
    property color dropdownBorderColor: Palette.border
    property int dropdownBorderWidth: 1
    property color optionHoverColor: Palette.surfaceColor
    property color optionTextColor: Palette.textPrimary
    property string indicatorSource: "qrc:/qt/qml/zametki/assets/icons/unused/open-bracket.svg"
    property int leftTextPadding: Palette.dropdownTextPaddingLeft
    property int rightTextPadding: Palette.dropdownTextPaddingRight

    topPadding: 12
    bottomPadding: 12

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
        width: Palette.dropdownIndicatorSize
        height: Palette.dropdownIndicatorSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Palette.dropdownIndicatorRightInset
    }

    background: Rectangle {
        radius: Palette.radiusMd
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
        y: control.height + Palette.dropdownPopupOffset
        width: control.width
        padding: 0

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
        }

        background: Rectangle {
            radius: Palette.radiusMd
            color: control.dropdownBackgroundColor
            border.color: control.dropdownBorderColor
            border.width: control.dropdownBorderWidth
        }
    }
}
