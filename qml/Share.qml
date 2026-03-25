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
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            anchors.topMargin: 24
            anchors.bottomMargin: 24
            spacing: 20

            // 🔍 Search row

            RowLayout {
                Layout.fillHeight: false
                Layout.fillWidth: false
                ColumnLayout {
                    Layout.fillWidth: false
                    Text{
                        color: "#667085"
                        text: "Share"
                        font.styleName: "SemiBold"
                        font.family: "Inter"

                    }
                    Text{
                        color: "#0f1724"
                        text: "Share “”"
                        font.pointSize: 18
                        font.styleName: "Bold"
                        font.family: "Inter"

                    }
                    Text{
                        color: "#667085"
                        text: "Invite people, manage access, and copy a link to this note."
                        font.styleName: "Regular"
                        font.family: "Inter"

                    }
                }
                Image{
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.fillWidth: false
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20

                }
            }
            Rectangle{
                id: rectangle1
                color: "#f1f5f9"
                radius: 8
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: 70
                Layout.fillHeight: false
                Layout.fillWidth: true
                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    anchors.topMargin: 14
                    anchors.bottomMargin: 14
                    ColumnLayout {
                        Layout.fillWidth: true
                        RowLayout{
                            spacing: 10
                            Layout.fillWidth: true
                            Rectangle{
                                radius: 6
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                RowLayout{
                                    anchors.fill: parent
                                    Image{
                                        id: image
                                        source: "../assets/icons/share/people.svg"
                                        Layout.fillWidth: false
                                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: 16
                                    Layout.preferredWidth: 16

                                }
                                    Text{
                                        color: "#667085"
                                    text: "Add people or groups"

                                }
                            }
                            }
                            Rectangle{
                                radius: 6
                                Layout.preferredHeight: 36
                                Layout.preferredWidth: 60
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                                Text{
                                    text: "Send"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.styleName: "SemiBold"
                                    font.family: "Inter"

                            }
                            }

                        }
                    }
                }
            }

            Rectangle{
                Layout.fillWidth: true
                Text{
                    text: "People with access"
                }
                ColumnLayout{
                    RowLayout{

                    }
                    RowLayout{

                    }
                }

            }

            RowLayout {
            }

        }
    }
}
