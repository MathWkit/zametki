import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    Row{
        id: row
        anchors.fill: parent
        spacing: 0




        ColumnLayout{
            id: sidebar
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16
            anchors.topMargin: 24
            anchors.bottomMargin: 24

            Text {
                text: "Settings"
                font.styleName: "SemiBold"
                font.pointSize: 18
                font.family: "Inter"
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: accountLayout.implicitHeight + 24
                    implicitWidth: accountLayout.implicitWidth + 24

                    RowLayout {
                        id: accountLayout
                        anchors.fill: parent
                        anchors.margins: 12   // ← вот это и есть padding

                        spacing: 12

                        Image {
                            source: "../assets/icons/settings/account.svg"
                            Layout.preferredHeight: 18
                            Layout.preferredWidth: 18
                        }

                        Text {
                            color: "#0f1724"
                            text: "Account"
                            font.styleName: "Medium"
                            font.pointSize: 14
                            font.family: "Inter"
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: aplicationLayout.implicitHeight + 24
                    implicitWidth: aplicationLayout.implicitWidth + 24

                    RowLayout {
                        id: aplicationLayout
                        anchors.fill: parent
                        anchors.margins: 12   // ← вот это и есть padding

                        spacing: 12

                        Image {
                            source: "../assets/icons/settings/account.svg"
                            Layout.preferredHeight: 18
                            Layout.preferredWidth: 18
                        }

                        Text {
                            color: "#667085"
                            text: "Application"
                            font.styleName: "Medium"
                            font.pointSize: 14
                            font.family: "Inter"
                        }
                    }
                }
                Rectangle {
                    implicitHeight: dataLayout.implicitHeight + 24
                    implicitWidth: dataLayout.implicitWidth + 24

                    RowLayout {
                        id: dataLayout
                        anchors.fill: parent
                        anchors.margins: 12   // ← вот это и есть padding

                        spacing: 12

                        Image {
                            source: "../assets/icons/settings/account.svg"
                            Layout.preferredHeight: 18
                            Layout.preferredWidth: 18
                        }

                        Text {
                            color: "#667085"
                            text: "Data & Storage"
                            font.styleName: "Medium"
                            font.pointSize: 14
                            font.family: "Inter"
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: aboutLayout.implicitHeight + 24
                    implicitWidth: aboutLayout.implicitWidth + 24

                    RowLayout {
                        id: aboutLayout
                        anchors.fill: parent
                        anchors.margins: 12   // ← вот это и есть padding

                        spacing: 12

                        Image {
                            source: "../assets/icons/settings/account.svg"
                            Layout.preferredHeight: 18
                            Layout.preferredWidth: 18
                        }

                        Text {
                            color: "#667085"
                            text: "About"
                            font.styleName: "Medium"
                            font.pointSize: 14
                            font.family: "Inter"
                        }
                    }
                }
                Item{
                    Layout.fillHeight: true

                }
                RowLayout{
                    Image{
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18


                    }
                    Text{
                        text: "Log out"
                    }

                }


            }

        }



        ColumnLayout{
            id: mainContent
            anchors.left: sidebar.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0

            RowLayout{
                Text{
                    color: "#0f1724"
                    text: "Account"
                    font.pointSize: 16
                    font.styleName: "SemiBold"
                    font.family: "Inter"
                }
                Item{
                    Layout.fillWidth: true

                }
                Image{
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 32
                }

            }

            ColumnLayout{
                width: 363
                spacing: 48
                Layout.rightMargin: 40
                Layout.leftMargin: 40
                Layout.bottomMargin: 20
                Layout.topMargin: 20
                Layout.preferredWidth: -1
                Layout.fillWidth: true
                ColumnLayout{
                    id: accountSettings
                    spacing: 16
                    Layout.fillWidth: true
                    Text{
                        color: "#667085"
                        text: "Account"
                        font.styleName: "SemiBold"
                        font.family: "Inter"
                    }
                    Rectangle{
                        id: rectangle
                        Layout.fillWidth: true
                        Layout.preferredHeight: accountSettingsLayout.implicitHeight+ 40
                        Layout.preferredWidth: accountSettingsLayout.implicitWidth+ 40

                        RowLayout{
                            id: accountSettingsLayout
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            anchors.topMargin: 20
                            anchors.bottomMargin: 20
                            spacing: 16
                            Rectangle{
                                color: "#f1f5f9"
                                radius: 100
                                topLeftRadius: 100
                                Layout.fillWidth: false
                                Layout.preferredHeight: 56
                                Layout.preferredWidth: 56
                                Text{
                                    text: "AK"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pointSize: 20
                                    font.styleName: "SemiBold"
                                    font.family: "Inter"
                                }

                            }
                            ColumnLayout{
                                Layout.fillWidth: false
                                Text{
                                    text: "Alex Kim"
                                    font.pointSize: 18
                                    font.styleName: "SemiBold"
                                    font.family: "Inter"

                                }
                                Text{
                                    color: "#667085"
                                    text: "alex@vault.app"
                                    font.pointSize: 14
                                    font.styleName: "SemiBold"
                                    font.family: "Inter"
                                }

                            }

                            Item{
                                Layout.fillWidth: true

                            }

                            Rectangle{
                                color: "#f1f5f9"
                                Layout.preferredHeight: manageText.implicitHeight
                                Layout.preferredWidth: manageText.implicitWidth

                                Text{
                                    id: manageText
                                    text:"Manege"
                                    leftPadding: 16
                                    rightPadding: 16
                                    bottomPadding: 8
                                    topPadding: 8

                                }
                            }
                        }
                    }
                }
                ColumnLayout{
                    id: applicationSettings
                    Text{
                        color: "#667085"
                        text: "Application"
                        font.styleName: "SemiBold"
                        font.family: "Inter"
                    }
                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: columnLayout.implicitHeight
                        Layout.preferredWidth: columnLayout.implicitWidth

                        ColumnLayout {
                            id: columnLayout
                            anchors.fill: parent
                            RowLayout {
                                id: applicationLayout
                                Layout.fillHeight: false
                                Layout.fillWidth: true
                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }

                                Text {
                                    text: "Appearance"
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: "Dark"
                                }

                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }
                            }

                            RowLayout {
                                id: editorLayout
                                Layout.fillWidth: true
                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }

                                Text {
                                    text: "Editor"
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }
                            }

                            RowLayout {
                                id: cloudLayout
                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }

                                ColumnLayout {
                                    id: columnLayout1
                                    x: 29
                                    y: 4
                                    Text {
                                        text: "Cloud Sync"
                                    }

                                    Text {
                                        text: "Sync across devices"
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }



                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }

                                Layout.fillWidth: true
                            }
                        }
                    }
                }
                ColumnLayout{
                    id: dataSeetings
                    Layout.fillWidth: true

                    Text {
                        color: "#667085"
                        text: "Application"
                        font.styleName: "SemiBold"
                        font.family: "Inter"
                    }

                    Rectangle {
                        ColumnLayout {
                            id: columnLayout2
                            anchors.fill: parent
                            RowLayout {
                                id: applicationLayout1
                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }

                                Text {
                                    text: "Appearance"
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: "Dark"
                                }

                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                            }

                            RowLayout {
                                id: editorLayout1
                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }

                                Text {
                                    text: "Editor"
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                id: cloudLayout1
                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }

                                ColumnLayout {
                                    id: columnLayout3
                                    x: 29
                                    y: 4
                                    Text {
                                        text: "Cloud Sync"
                                    }

                                    Text {
                                        text: "Sync across devices"
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }
                                Layout.fillWidth: true
                            }
                        }
                        Layout.preferredWidth: columnLayout2.implicitWidth
                        Layout.preferredHeight: columnLayout2.implicitHeight
                        Layout.fillWidth: true
                    }
                }
                ColumnLayout{
                    id: aboutSettings
                }

            }

        }

    }
}
