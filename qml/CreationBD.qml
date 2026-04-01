pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Dialogs 6.8
import "scripts/Theme.js" as Palette

Rectangle {
	id: root

	property string fontFamily: ""
	property string selectedDirectoryPath: ""
	property string errorText: ""

	signal createDatabaseRequested(string databaseName, string parentDirectoryPath)

	color: Qt.rgba(0, 0, 0, 0.35)

	Rectangle {
		width: Math.min(parent.width - 40, 480)
		height: implicitHeight
		anchors.centerIn: parent
		color: Palette.headerBackground
		radius: 8
		border.width: 1
		border.color: Palette.border

		Column {
			anchors.fill: parent
			anchors.margins: 20
			spacing: 12

			Text {
				text: "CreationBD"
				font.family: root.fontFamily
				font.pixelSize: 20
				font.weight: Font.DemiBold
				color: Palette.textPrimary
			}

			Text {
				text: "Введите название базы и выберите папку, где она будет храниться"
				font.family: root.fontFamily
				font.pixelSize: 13
				color: Palette.textSecondary
				wrapMode: Text.WordWrap
			}

			TextField {
				id: databaseNameField
				placeholderText: "Название базы данных"
				font.family: root.fontFamily
				selectByMouse: true
			}

			Row {
				spacing: 8
				width: parent.width

				Button {
					text: "Выбрать папку"
					font.family: root.fontFamily
					onClicked: folderDialog.open()
				}

				Text {
					width: parent.width - 140
					anchors.verticalCenter: parent.verticalCenter
					text: root.selectedDirectoryPath === "" ? "Папка не выбрана" : root.selectedDirectoryPath
					font.family: root.fontFamily
					font.pixelSize: 12
					color: Palette.textSecondary
					elide: Text.ElideMiddle
				}
			}

			Text {
				visible: root.errorText.length > 0
				text: root.errorText
				font.family: root.fontFamily
				font.pixelSize: 12
				color: "#B91C1C"
				wrapMode: Text.WordWrap
			}

			Button {
				text: "Создать"
				font.family: root.fontFamily
				enabled: databaseNameField.text.trim().length > 0 && root.selectedDirectoryPath.length > 0
				onClicked: {
					root.errorText = "";
					root.createDatabaseRequested(databaseNameField.text, root.selectedDirectoryPath);
				}
			}
		}
	}

	FolderDialog {
		id: folderDialog
		title: "Выберите папку для базы данных"
		onAccepted: {
			root.selectedDirectoryPath = String(selectedFolder);
			root.errorText = "";
		}
	}
}
