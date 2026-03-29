import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
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
