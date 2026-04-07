import QtQuick 6.8
import QtQuick.Layouts 1.15
import "../../scripts/Theme.js" as Palette

RowLayout {
    property bool compact: false
    property int rowLeftMargin: Palette.contentInset
    property int rowRightMargin: Palette.contentInset
    property int rowTopMargin: compact ? Palette.rowPaddingCompact : Palette.rowPadding
    property int rowBottomMargin: compact ? Palette.rowPaddingCompact : Palette.rowPadding

    Layout.leftMargin: rowLeftMargin
    Layout.rightMargin: rowRightMargin
    Layout.topMargin: rowTopMargin
    Layout.bottomMargin: rowBottomMargin
    Layout.fillWidth: true
    Layout.fillHeight: false
}
