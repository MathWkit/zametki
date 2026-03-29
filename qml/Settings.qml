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
                ColumnLayout{
                    id: accountSettings
                    Text{
                        text: "account"
                    }
                    Rectangle{
                        Layout.preferredHeight: accountSettingsLayout.implicitHeight
                        Layout.preferredWidth: accountSettingsLayout.implicitWidth

                        RowLayout{
                            id: accountSettingsLayout
                            Rectangle{
                                Layout.preferredHeight: 56
                                Layout.preferredWidth: 56
                                Text{
                                    text: "AK"
                                }

                            }
                            ColumnLayout{
                                Text{
                                    text: "Alex Kim"

                                }
                                Text{
                                    text: "alex@vault.app"
                                }

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
                        Layout.preferredHeight: applicationLayout.implicitHeight
                        Layout.preferredWidth: applicationLayout.implicitWidth
                        RowLayout{
                            id: applicationLayout
                            Image{
                                Layout.preferredHeight: 24
                                Layout.preferredWidth: 24

                            }
                            Text{
                                text: "Appearance"

                            }
                            Item{

                            }
                            Text{
                                text: "Dark"

                            }
                            Image{
                                Layout.preferredHeight: 16
                                Layout.preferredWidth: 16

                            }

                        }
                    }
                }
                ColumnLayout{
                    id: dataSeetings
                }
                ColumnLayout{
                    id: aboutSettings
                }

    }

    }
}
}
