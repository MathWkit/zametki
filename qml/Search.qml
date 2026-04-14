import QtQuick 6.8
import QtQuick.Layouts 6.8
import QtQuick.Controls 6.8
import "scripts/Theme.js" as Palette
import "components"
import "components/search"

Item {
    id: root
    clip: true

    signal closeClicked

    readonly property Item dialogItem: dialog
    readonly property int dialogMargin: Palette.space2
    readonly property int dialogMinHeight: Palette.controlHeightBase + Palette.searchHintBarHeight + Palette.space4

    property var recentNotes: [
        {
            title: qsTr("Заметка 1"),
            subtitle: "путь / к / заметке",
            icon: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
        },
        {
            title: qsTr("Заметка 2"),
            subtitle: "путь / ко / второй заметке",
            icon: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
        }
    ]

    property var folders: [
        {
            title: qsTr("Проектные заметки"),
            icon: "qrc:/qt/qml/zametki/assets/icons/list/folder.svg"
        }
    ]

    property var commands: [
        {
            title: qsTr("Создать заметку"),
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
        },
        {
            title: qsTr("Открыть граф"),
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg"
        }
    ]

    property var footerHints: [
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/list/closed-bracket.svg",
            label: qsTr("Навигация")
        },
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg",
            label: qsTr("Открыть")
        },
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg",
            label: qsTr("Закрыть")
        }
    ]

    Rectangle {
        id: dialog
        width: Math.min(Palette.dialogMaxWidth, Math.max(Palette.searchDialogMinWidth, root.width - (root.dialogMargin * 2)))
        height: Math.min(Palette.searchDialogHeight, Math.max(root.dialogMinHeight, root.height - (root.dialogMargin * 2)))
        color: Palette.headerBackground
        radius: Palette.modalSurfaceRadius
        border.width: 1
        border.color: Palette.border
        anchors.centerIn: parent

        antialiasing: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Palette.searchInset
                Layout.rightMargin: Palette.searchInset
                Layout.topMargin: Palette.space2
                Layout.bottomMargin: Palette.space2
                spacing: Palette.spacingXl

                SearchInputBar {
                    Layout.fillWidth: true
                }

                AppIconSurfaceButton {
                    iconSource: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: root.closeClicked()
                }
            }

            AppDivider {
                Layout.fillWidth: true
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: contentColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: contentColumn
                    width: parent.width
                    spacing: 0

                    SearchSectionHeader {
                        text: qsTr("ПОСЛЕДНИЕ ЗАМЕТКИ")
                        Layout.leftMargin: Palette.searchSectionInset
                        Layout.topMargin: Palette.space2
                    }

                    Repeater {
                        model: root.recentNotes

                        SearchResultRow {
                            required property var modelData
                            required property int index

                            Layout.leftMargin: Palette.searchInset
                            Layout.rightMargin: Palette.searchInset
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                            subtitleText: modelData.subtitle
                        }
                    }

                    SearchSectionHeader {
                        text: qsTr("ПАПКИ")
                        Layout.leftMargin: Palette.searchSectionInset
                        Layout.topMargin: Palette.space2
                    }

                    Repeater {
                        model: root.folders

                        SearchResultRow {
                            required property var modelData
                            required property int index

                            Layout.leftMargin: Palette.searchInset
                            Layout.rightMargin: Palette.searchInset
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                        }
                    }

                    SearchSectionHeader {
                        text: qsTr("КОМАНДЫ")
                        Layout.leftMargin: Palette.searchSectionInset
                        Layout.topMargin: Palette.space2
                    }

                    Repeater {
                        model: root.commands

                        SearchResultRow {
                            required property var modelData
                            required property int index

                            Layout.leftMargin: Palette.searchInset
                            Layout.rightMargin: Palette.searchInset
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            SearchHintsBar {
                hintsModel: root.footerHints
            }
        }
    }
}
