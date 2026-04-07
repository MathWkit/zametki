import QtQuick 6.8
import QtQuick.Controls 2.15
import "../scripts/Theme.js" as Palette

TextField {
	id: control

	property color fieldTextColor: Palette.textPrimary
	property color fieldBackgroundColor: Palette.backgroundWhite
	property color fieldBorderColor: Palette.border
	property int cornerRadius: Palette.radiusMd
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
