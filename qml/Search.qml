import QtQuick 6.8
import QtQuick.Layouts 6.8
import QtQuick.Controls 6.8
import "scripts/Theme.js" as Palette

Item {
    id: root
    clip: true
    layer.enabled: true

    readonly property string uiFontFamily: "Inter"
    readonly property color colorWhite: Palette.headerBackground
    readonly property color colorTextPrimary: Palette.textPrimary
    readonly property color colorTextSecondary: Palette.textSecondary
    readonly property color colorDivider: Palette.border
    readonly property color colorSurface: "#fafbfc"
    readonly property color colorHover: Palette.hover
    readonly property real rowRadius: 6

    Rectangle {
        id: dialog
        width: 540
        height: 430
        color: root.colorWhite
        radius: 8
        border.width: 1
        border.color: root.colorDivider
        anchors.centerIn: parent

        antialiasing: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 16
                Layout.bottomMargin: 16
                implicitHeight: 40
                color: root.colorSurface
                radius: root.rowRadius
                border.width: 1
                border.color: root.colorDivider

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
                        placeholderText: "Search for notes, folders, tags, or commands..."
                        color: root.colorTextPrimary
                        placeholderTextColor: root.colorTextSecondary
                        font.pixelSize: 14
                        font.family: root.uiFontFamily
                        background: Rectangle {
                            color: "transparent"
                            border.width: 0
                        }
                    }
                }
            }

            Rectangle {
                color: root.colorDivider
                height: 1
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

                    Text {
                        text: "RECENT NOTES"
                        color: root.colorTextSecondary
                        font.pixelSize: 10
                        font.family: root.uiFontFamily
                        font.weight: Font.DemiBold
                        Layout.leftMargin: 24
                        Layout.topMargin: 16
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Layout.topMargin: 12
                        implicitHeight: 44
                        color: mouseRecent1.containsMouse ? root.colorHover : "transparent"
                        radius: root.rowRadius

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            Image {
                                source: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            ColumnLayout {
                                spacing: 1
                                Layout.fillWidth: true

                                Text {
                                    text: "Note 1"
                                    color: root.colorTextPrimary
                                    font.pixelSize: 13
                                    font.family: root.uiFontFamily
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "path / to / note"
                                    color: root.colorTextSecondary
                                    font.pixelSize: 11
                                    font.family: root.uiFontFamily
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        MouseArea {
                            id: mouseRecent1
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        implicitHeight: 44
                        color: mouseRecent2.containsMouse ? root.colorHover : "transparent"
                        radius: root.rowRadius

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            Image {
                                source: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            ColumnLayout {
                                spacing: 1
                                Layout.fillWidth: true

                                Text {
                                    text: "Note 2"
                                    color: root.colorTextPrimary
                                    font.pixelSize: 13
                                    font.family: root.uiFontFamily
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "path / to / second note"
                                    color: root.colorTextSecondary
                                    font.pixelSize: 11
                                    font.family: root.uiFontFamily
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        MouseArea {
                            id: mouseRecent2
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Text {
                        text: "FOLDERS"
                        color: root.colorTextSecondary
                        font.pixelSize: 10
                        font.family: root.uiFontFamily
                        font.weight: Font.DemiBold
                        Layout.leftMargin: 24
                        Layout.topMargin: 18
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Layout.topMargin: 12
                        implicitHeight: 36
                        color: mouseFolder.containsMouse ? root.colorHover : "transparent"
                        radius: root.rowRadius

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            Image {
                                source: "qrc:/qt/qml/zametki/assets/icons/list/folder.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            Text {
                                text: "Project Notes"
                                color: root.colorTextPrimary
                                font.pixelSize: 13
                                font.family: root.uiFontFamily
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: mouseFolder
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Text {
                        text: "COMMANDS"
                        color: root.colorTextSecondary
                        font.pixelSize: 10
                        font.family: root.uiFontFamily
                        font.weight: Font.DemiBold
                        Layout.leftMargin: 24
                        Layout.topMargin: 18
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Layout.topMargin: 12
                        implicitHeight: 36
                        color: mouseCmd1.containsMouse ? root.colorHover : "transparent"
                        radius: root.rowRadius

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            Image {
                                source: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            Text {
                                text: "Create New Note"
                                color: root.colorTextPrimary
                                font.pixelSize: 13
                                font.family: root.uiFontFamily
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: mouseCmd1
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Layout.topMargin: 12
                        implicitHeight: 36
                        color: mouseCmd2.containsMouse ? root.colorHover : "transparent"
                        radius: root.rowRadius

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            Image {
                                source: "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            Text {
                                text: "Open Graph View"
                                color: root.colorTextPrimary
                                font.pixelSize: 13
                                font.family: root.uiFontFamily
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: mouseCmd2
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: root.colorSurface
                border.width: 1
                border.color: root.colorDivider
                implicitHeight: 44

                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 14
                    spacing: 14

                    RowLayout {
                        spacing: 6
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/unused/open-bracket.svg"
                            Layout.preferredHeight: 14
                            Layout.preferredWidth: 14
                        }
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/list/closed-bracket.svg"
                            Layout.preferredHeight: 14
                            Layout.preferredWidth: 14
                        }
                        Text {
                            color: root.colorTextSecondary
                            text: qsTr("Navigate")
                            font.pixelSize: 12
                            font.family: root.uiFontFamily
                        }
                    }

                    RowLayout {
                        spacing: 6
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
                        }
                        Text {
                            color: root.colorTextSecondary
                            text: qsTr("Open")
                            font.pixelSize: 12
                            font.family: root.uiFontFamily
                        }
                    }

                    RowLayout {
                        spacing: 6
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/header/more.svg"
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
                        }
                        Text {
                            color: root.colorTextSecondary
                            text: qsTr("Close")
                            font.pixelSize: 12
                            font.family: root.uiFontFamily
                        }
                    }
                }
            }
        }
    }
}
