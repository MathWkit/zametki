import QtQuick 6.8
import QtQuick.Layouts

Item {
    width: 1920
    height: 1080
    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            Layout.rightMargin: 12
            Layout.leftMargin: 12
            Layout.bottomMargin: 10
            Layout.topMargin: 10
            Text {
                text: "Settings"
                font.pointSize: 18
                font.styleName: "SemiBold"
                font.family: "Inter"
                Layout.bottomMargin: 20
                Layout.rightMargin: 12
                Layout.leftMargin: 12
            }
            ColumnLayout {

                RowLayout {
                    Layout.rightMargin: 12
                    Layout.leftMargin: 12
                    Layout.bottomMargin: 10
                    Layout.topMargin: 10
                    spacing: 12
                    Image {
                        source: "../assets/icons/settings/account.svg"
                        Layout.preferredHeight: 18
                        Layout.preferredWidth: 18
                    }
                    Text {
                        text: "Account"
                        font.pointSize: 14
                        font.styleName: "Medium"
                        font.family: "Inter"
                    }
                }
            }

            ColumnLayout {
                RowLayout {
                    spacing: 12
                    Image {
                        source: "../assets/icons/settings/application.svg"
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                    }

                    Text {
                        color: "#667085"
                        text: "Application"
                        font.styleName: "Medium"
                        font.pointSize: 14
                        font.family: "Inter"
                    }
                    Layout.topMargin: 10
                    Layout.rightMargin: 12
                    Layout.leftMargin: 12
                    Layout.bottomMargin: 10
                }
            }

            ColumnLayout {
                RowLayout {
                    spacing: 12
                    Image {
                        source: "../assets/icons/settings/data.svg"
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                    }

                    Text {
                        color: "#667085"
                        text: "Data & Storage"
                        font.styleName: "Medium"
                        font.pointSize: 14
                        font.family: "Inter"
                    }
                    Layout.topMargin: 10
                    Layout.rightMargin: 12
                    Layout.leftMargin: 12
                    Layout.bottomMargin: 10
                }
            }

            ColumnLayout {
                RowLayout {
                    spacing: 12
                    Image {
                        source: "../assets/icons/settings/about.svg"
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                    }

                    Text {
                           color: "#667085"
                        text: "About"
                        font.styleName: "Medium"
                        font.pointSize: 14
                        font.family: "Inter"
                    }
                    Layout.topMargin: 10
                    Layout.rightMargin: 12
                    Layout.leftMargin: 12
                    Layout.bottomMargin: 10
                }
            }
            Item{
                Layout.fillHeight: true

            }
            ColumnLayout {
                RowLayout {
                    spacing: 12
                    Image {
                        source: "log-out.vg"
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                        // color : "#sDC2626"
                    }

                    Text {
                           color: "#DC2626"
                        text: "Log out"
                        font.styleName: "Medium"
                        font.pointSize: 14
                        font.family: "Inter"
                    }
                    Layout.topMargin: 10
                    Layout.rightMargin: 12
                    Layout.leftMargin: 12
                    Layout.bottomMargin: 10
                }
            }

        }

        ColumnLayout {
        }





    }
}
