import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    Row{
        id: row
        anchors.fill: parent

        ColumnLayout{
            id: sidebar
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 0
        anchors.bottomMargin: 0
        Text{
            text: "settings"
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        Rectangle {
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
                    text: "Account"
                    font.pointSize: 14
                    font.family: "Inter"
                }
            }
        }
        Rectangle {
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
                    text: "Account"
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
                    text: "Account"
                    font.pointSize: 14
                    font.family: "Inter"
                }
            }
        }
        Rectangle {
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
                    text: "Account"
                    font.pointSize: 14
                    font.family: "Inter"
                }
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
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        RowLayout{
            Text{
                    text: "Account"
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
            Layout.preferredWidth: -1
            Layout.fillWidth: true
            ColumnLayout{
                id: accountSettings
                Layout.fillWidth: true
                    Text{
                        text: "account"
                    }
                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: accountSettingsLayout.implicitHeight
                        Layout.preferredWidth: accountSettingsLayout.implicitWidth

                        RowLayout{
                            id: accountSettingsLayout
                            anchors.fill: parent
                            Rectangle{
                                Layout.fillWidth: false
                                Layout.preferredHeight: 56
                                Layout.preferredWidth: 56
                                Text{
                                    text: "AK"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                            }
                            ColumnLayout{
                                Layout.fillWidth: false
                                Text{
                                    text: "Alex Kim"

                                }
                                Text{
                                    text: "alex@vault.app"
                                }

                            }

                            Item{
                                Layout.fillWidth: true

                            }

                            Rectangle{
                                Layout.preferredHeight: manageText.implicitHeight
                                Layout.preferredWidth: manageText.implicitWidth

                                Text{
                                    id: manageText
                                    text:"Manege"

                                }
                            }
                        }
                    }
                }
                ColumnLayout{
                    id: applicationSettings
                    Text{
                        text: "Application"
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
                        text: "Application"
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
