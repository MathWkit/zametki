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
        width: 540
        height: 430
        color: Palette.headerBackground
        radius: 8
        border.width: 1
        border.color: Palette.border
        anchors.centerIn: parent

        antialiasing: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            AppSectionCard {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 16
                Layout.bottomMargin: 16
                implicitHeight: 40
                cardColor: Palette.backgroundLight
                borderLineColor: Palette.border

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 10

                    Image {
                        source: "qrc:/qt/qml/zametki/assets/icons/sidebar/search.svg"
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                    }

                    TextField {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        placeholderText: qsTr("Search for notes, folders, tags, or commands...")
                        color: Palette.textPrimary
                        placeholderTextColor: Palette.textSecondary
                        font.pixelSize: 14
                        font.family: Palette.fontFamily
                        background: Rectangle {
                            color: "transparent"
                            border.width: 0
                        }
                    }
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
                        text: qsTr("RECENT NOTES")
                        Layout.leftMargin: 24
                        Layout.topMargin: 16
                    }

                    Repeater {
                        model: root.recentNotes

                        SearchResultRow {
                            required property var modelData

                            Layout.leftMargin: 20
                            Layout.rightMargin: 20
                            Layout.topMargin: index === 0 ? 12 : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                            subtitleText: modelData.subtitle
                        }
                    }

                    SearchSectionHeader {
                        text: qsTr("FOLDERS")
                        Layout.leftMargin: 24
                        Layout.topMargin: 18
                    }

                    Repeater {
                        model: root.folders

                        SearchResultRow {
                            required property var modelData

                            Layout.leftMargin: 20
                            Layout.rightMargin: 20
                            Layout.topMargin: index === 0 ? 12 : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                        }
                    }

                    SearchSectionHeader {
                        text: qsTr("COMMANDS")
                        Layout.leftMargin: 24
                        Layout.topMargin: 18
                    }

                    Repeater {
                        model: root.commands

                        SearchResultRow {
                            required property var modelData

                            Layout.leftMargin: 20
                            Layout.rightMargin: 20
                            Layout.topMargin: index === 0 ? 12 : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: Palette.backgroundLight
                border.width: 1
                border.color: Palette.border
                implicitHeight: 44

                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 14
                    spacing: 14

                    Repeater {
                        model: root.footerHints

                        SearchFooterHint {
                            required property var modelData

                            iconSource: modelData.icon
                            textLabel: modelData.label
                        }
                    }
                }
            }
        }
    }
}
