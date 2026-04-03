import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "scripts/Theme.js" as Palette

Item {
    id: root
    anchors.fill: parent

    property bool darkTheme: false
    property string fontFamily: "Inter"
    property int mode: 0

    signal loginRequested(string email, string password)
    signal registerRequested(string name, string email, string password)

    readonly property color pageBackground: darkTheme ? "#070B12" : Palette.backgroundLight
    readonly property color cardColor: darkTheme ? "#111827" : Palette.backgroundWhite
    readonly property color cardBorderColor: darkTheme ? "#1F2937" : Palette.border
    readonly property color headingColor: darkTheme ? "#E5E7EB" : Palette.textPrimary
    readonly property color subtitleColor: darkTheme ? "#9CA3AF" : Palette.textSecondary
    readonly property color tabContainerColor: darkTheme ? "#0B1220" : Palette.surfaceColor
    readonly property color tabSelectedColor: darkTheme ? "#1E40AF" : Palette.accentPrimary
    readonly property color tabHoverColor: darkTheme ? "#1F2937" : "#E2E8F0"
    readonly property color tabTextColor: darkTheme ? "#E5E7EB" : Palette.textPrimary

    Rectangle {
        anchors.fill: parent
        color: root.pageBackground
    }

    Rectangle {
        id: card
        width: Math.min(Math.max(320, root.width * 0.42), 400)
        implicitHeight: contentLayout.implicitHeight + 32
        anchors.centerIn: parent
        color: root.cardColor
        radius: 12
        border.width: 1
        border.color: root.cardBorderColor

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            Text {
                text: qsTr("Аккаунт")
                Layout.fillWidth: true
                color: root.headingColor
                font.family: root.fontFamily
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }

            Text {
                text: qsTr("Войдите или создайте новый аккаунт")
                Layout.fillWidth: true
                color: root.subtitleColor
                font.family: root.fontFamily
                font.pixelSize: 12
            }

            TabBar {
                id: modeTabs
                Layout.fillWidth: true
                currentIndex: root.mode
                spacing: 4

                background: Rectangle {
                    color: root.tabContainerColor
                    radius: 10
                }

                onCurrentIndexChanged: root.mode = currentIndex

                TabButton {
                    id: loginTab
                    text: qsTr("Вход")
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    hoverEnabled: true

                    contentItem: Text {
                        text: loginTab.text
                        font: loginTab.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: loginTab.checked ? "#FFFFFF" : root.tabTextColor
                    }

                    background: Rectangle {
                        radius: 8
                        color: loginTab.checked ? root.tabSelectedColor : (loginTab.hovered ? root.tabHoverColor : "transparent")
                    }
                }

                TabButton {
                    id: registerTab
                    text: qsTr("Регистрация")
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    hoverEnabled: true

                    contentItem: Text {
                        text: registerTab.text
                        font: registerTab.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: registerTab.checked ? "#FFFFFF" : root.tabTextColor
                    }

                    background: Rectangle {
                        radius: 8
                        color: registerTab.checked ? root.tabSelectedColor : (registerTab.hovered ? root.tabHoverColor : "transparent")
                    }
                }
            }

            StackLayout {
                id: authStack
                Layout.fillWidth: true
                currentIndex: root.mode

                LoginForm {
                    Layout.fillWidth: true
                    darkTheme: root.darkTheme
                    fontFamily: root.fontFamily
                    onLoginRequested: function (email, password) {
                        root.loginRequested(email, password);
                    }
                    onSwitchToRegisterRequested: {
                        root.mode = 1;
                    }
                }

                RegisterForm {
                    Layout.fillWidth: true
                    darkTheme: root.darkTheme
                    fontFamily: root.fontFamily
                    onRegisterRequested: function (name, email, password) {
                        root.registerRequested(name, email, password);
                    }
                    onSwitchToLoginRequested: {
                        root.mode = 0;
                    }
                }
            }
        }
    }
}
