import QtQuick 6.8
import QtQuick.Layouts

Item {
    id: item1
    clip: true
    layer.enabled: false
    Rectangle {
        id: rectangle
        width: 540
        height: 430
        color: "#ffffff"
        radius: 10
        anchors.centerIn: parent
        smooth: false

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // 🔍 Search row

            RowLayout {
                Layout.bottomMargin: 12
                Layout.fillWidth: true
                Layout.topMargin: 12
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                spacing: 20

                Image {
                    source: "qrc:/qt/qml/zametki/assets/icons/sidebar/chosen.svg"
                    fillMode: Image.PreserveAspectFit
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                }

                TextEdit {
                    text: "Search for notes, folders, tags, or commands..."
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Inter"
                    color: "#667085"

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            // 🔲 Divider

            // 📂 Content

            Rectangle {
                color: "#eeeeee"
                height: 1
                Layout.fillWidth: true
            }

            ColumnLayout {
                id: columnLayout1
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true

                spacing: 0

                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    smooth: true
                    Layout.fillWidth: true

                    spacing: 0

                    // RECENT NOTES
                    Text {
                        text: "RECENT NOTES"
                        color: "#667085"
                        font.pixelSize: 8
                        verticalAlignment: Text.AlignVCenter

                        bottomPadding: 12
                        topPadding: 12
                        font.family: "Inter"

                        Layout.fillWidth: true
                        padding: 8
                    }

                    RowLayout {
                        clip: true
                        spacing: 12
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            spacing: 4
                            smooth: false
                            Text {
                                text: "Note 1"
                                font.pixelSize: 10
                                verticalAlignment: Text.AlignVCenter
                                topPadding: 0
                                leftPadding: 0
                                Layout.fillWidth: true
                            }

                            Text {
                                visible: true
                                color: "#707988"
                                text: "path / to / note"
                                font.pixelSize: 8
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.NoWrap
                                topPadding: 0
                                leftPadding: 0
                                layer.enabled: false
                                font.family: "Inter"
                                Layout.fillWidth: true
                            }
                            Layout.topMargin: 0
                            Layout.rightMargin: 0
                            Layout.margins: 0
                            Layout.leftMargin: 0
                            Layout.fillWidth: true

                            Layout.bottomMargin: 0
                        }
                        Layout.topMargin: 12
                        Layout.rightMargin: 12
                        Layout.margins: 0
                        Layout.leftMargin: 12
                        Layout.bottomMargin: 12
                    }

                    RowLayout {
                        spacing: 12
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            spacing: 4
                            smooth: false
                            Text {
                                text: "Note 1"
                                font.pixelSize: 10
                                verticalAlignment: Text.AlignVCenter
                                topPadding: 0
                                leftPadding: 0
                                Layout.fillWidth: true
                            }

                            Text {
                                visible: true
                                color: "#707988"
                                text: "path / to / note"
                                font.pixelSize: 8
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.NoWrap
                                topPadding: 0
                                leftPadding: 0
                                layer.enabled: false
                                font.family: "Inter"
                                Layout.fillWidth: true
                            }
                            Layout.topMargin: 0
                            Layout.rightMargin: 0
                            Layout.margins: 0
                            Layout.leftMargin: 0
                            Layout.fillWidth: true

                            Layout.bottomMargin: 0
                        }
                        clip: true
                        Layout.topMargin: 12
                        Layout.rightMargin: 12
                        Layout.margins: 0
                        Layout.leftMargin: 12
                        Layout.bottomMargin: 12
                    }
                }
                ColumnLayout {
                    spacing: 4
                    Text {
                        color: "#4a5468"
                        text: "FOLDERS"
                        font.pixelSize: 8
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: 8
                        bottomPadding: 12
                        topPadding: 12
                        leftPadding: 8
                        Layout.topMargin: 0
                        Layout.rightMargin: 0
                        Layout.leftMargin: 0
                        Layout.fillWidth: true

                        Layout.bottomMargin: 0
                    }

                    RowLayout {
                        spacing: 12
                        Image {
                            id: image1
                            source: "qrc:/qt/qml/zametki/assets/icons/list/folder.svg"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: "Note 1"
                            font.pixelSize: 10
                            verticalAlignment: Text.AlignVCenter
                            topPadding: 0
                            leftPadding: 0
                            Layout.fillWidth: true
                        }
                        Layout.topMargin: 12
                        Layout.margins: 12
                        Layout.fillWidth: true

                        Layout.bottomMargin: 12
                    }
                    Layout.fillWidth: true
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    spacing: 4
                    // FOLDERS
                    Text {

                        text: "COMMANDS"
                        color: "#4a5468"
                        font.pixelSize: 8
                        verticalAlignment: Text.AlignVCenter
                        font.preferShaping: false
                        rightPadding: 8
                        bottomPadding: 12
                        Layout.rightMargin: 0
                        Layout.leftMargin: 0
                        Layout.bottomMargin: 0
                        Layout.topMargin: 0

                        Layout.fillWidth: true
                        topPadding: 12
                        leftPadding: 8
                    }

                    RowLayout {

                        Layout.margins: 12
                        Layout.bottomMargin: 12
                        Layout.topMargin: 12
                        Layout.fillWidth: true
                        spacing: 12

                        Image {
                            id: image
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
                        }

                        Text {
                            text: "Create New Note"
                            font.pixelSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.fillWidth: true
                            leftPadding: 0
                            topPadding: 0
                        }
                    }

                    RowLayout {

                        Layout.fillWidth: true
                        spacing: 12
                        Image {
                            id: image2
                            source: "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg"
                            fillMode: Image.PreserveAspectFit
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: "Open Graph View"
                            font.pixelSize: 10
                            verticalAlignment: Text.AlignVCenter
                            topPadding: 0
                            leftPadding: 0
                            Layout.fillWidth: true
                        }
                        Layout.topMargin: 12
                        Layout.margins: 12

                        Layout.bottomMargin: 12
                    }
                }

                Rectangle {
                    color: "#fafbfc"
                    border.color: "#14000000"
                    border.width: 1
                    Layout.fillHeight: true

                    Layout.fillWidth: true
                    RowLayout {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 20
                        anchors.topMargin: 12
                        anchors.bottomMargin: 12
                        spacing: 16
                        RowLayout {
                            spacing: 6
                            Image {
                                id: image3
                                width: 100
                                height: 100
                                source: "qrc:/qt/qml/zametki/assets/icons/unused/open-bracket.svg"
                                fillMode: Image.PreserveAspectFit
                                Layout.preferredHeight: 16
                                Layout.preferredWidth: 16
                            }
                            Image {
                                id: image4
                                width: 100
                                height: 100
                                source: "qrc:/qt/qml/zametki/assets/icons/list/closed-bracket.svg"
                                fillMode: Image.PreserveAspectFit
                                Layout.preferredHeight: 16
                                Layout.preferredWidth: 16
                            }
                            Text {
                                id: text1
                                color: "#667085"
                                text: qsTr("Navigate")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Medium"
                                font.family: "Inter"
                            }
                        }

                        RowLayout {

                            Image {
                                id: image6
                                width: 100
                                height: 100
                                source: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
                                fillMode: Image.PreserveAspectFit
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            Text {
                                id: text2
                                color: "#667085"
                                text: qsTr("Open")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Medium"
                                font.family: "Inter"
                            }
                        }

                        RowLayout {
                            Image {
                                id: image7
                                width: 100
                                height: 100
                                source: "qrc:/qt/qml/zametki/assets/icons/header/more.svg"
                                fillMode: Image.PreserveAspectFit
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }

                            Text {
                                id: text3
                                color: "#667085"
                                text: qsTr("Close")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Medium"
                                font.family: "Inter"
                            }
                        }
                    }
                }
            }
        }
    }
}
