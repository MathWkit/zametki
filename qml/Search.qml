import QtQuick 6.8
import QtQuick.Layouts 6.8
import QtQuick.Controls 6.8
import "scripts/Theme.js" as Palette
import "components"
import "components/search"

Item {
    id: root
    clip: true

    readonly property Item dialogItem: dialog

    property var recentNotes: [
        {
            title: "Note 1",
            subtitle: "path / to / note",
            icon: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
        },
        {
            title: "Note 2",
            subtitle: "path / to / second note",
            icon: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
        }
    ]

    property var folders: [
        {
            title: "Project Notes",
            icon: "qrc:/qt/qml/zametki/assets/icons/list/folder.svg"
        }
    ]

    property var commands: [
        {
            title: "Create New Note",
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
        },
        {
            title: "Open Graph View",
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg"
        }
    ]

    property var footerHints: [
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/unused/open-bracket.svg",
            label: qsTr("Navigate")
        },
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg",
            label: qsTr("Open")
        },
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/header/more.svg",
            label: qsTr("Close")
        }
    ]

    Rectangle {
        id: dialog
        width: Math.min(Palette.dialogMaxWidth, Math.max(Palette.authCardMinWidth, parent.width - (Palette.spacingXxl * 2)))
        height: Math.min(430, Math.max(0, parent.height - (Palette.spacingXxl * 2)))
        color: Palette.headerBackground
        radius: Palette.radiusLg
        border.width: 1
        border.color: Palette.border
        anchors.centerIn: parent

        antialiasing: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            SearchInputBar {
                Layout.fillWidth: true
                Layout.leftMargin: Palette.spacingXxl
                Layout.rightMargin: Palette.spacingXxl
                Layout.topMargin: Palette.spacingXxl
                Layout.bottomMargin: Palette.spacingXxl
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
                        text: qsTr("RECENT NOTES")
                        Layout.leftMargin: Palette.spacingMassive
                        Layout.topMargin: Palette.spacingXxl
                    }

                    Repeater {
                        model: root.recentNotes

                        SearchResultRow {
                            required property var modelData

                            Layout.leftMargin: Palette.spacingXxl
                            Layout.rightMargin: Palette.spacingXxl
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                            subtitleText: modelData.subtitle
                        }
                    }

                    SearchSectionHeader {
                        text: qsTr("FOLDERS")
                        Layout.leftMargin: Palette.spacingMassive
                        Layout.topMargin: Palette.spacingXxl
                    }

                    Repeater {
                        model: root.folders

                        SearchResultRow {
                            required property var modelData

                            Layout.leftMargin: Palette.spacingXxl
                            Layout.rightMargin: Palette.spacingXxl
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                        }
                    }

                    SearchSectionHeader {
                        text: qsTr("COMMANDS")
                        Layout.leftMargin: Palette.spacingMassive
                        Layout.topMargin: Palette.spacingXxl
                    }

                    Repeater {
                        model: root.commands

                        SearchResultRow {
                            required property var modelData

                            Layout.leftMargin: Palette.spacingXxl
                            Layout.rightMargin: Palette.spacingXxl
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
