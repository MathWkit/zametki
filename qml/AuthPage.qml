import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "scripts/Theme.js" as Palette
import "components"
import "components/auth"

Item {
    id: root
    anchors.fill: parent

    // Backward compatibility for Main.qml assignment.
    property string fontFamily: Palette.fontFamily
    property int mode: 0
    property bool googleAuthAvailable: true
    property bool appleAuthAvailable: Qt.platform.os === "osx"
    property bool closeOnOutsideClick: false

    signal loginRequested(string email, string password)
    signal registerRequested(string name, string email, string password)
    signal googleAuthRequested
    signal appleAuthRequested
    signal closeRequested

    Rectangle {
        anchors.fill: parent
        color: Palette.backgroundLight
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (root.closeOnOutsideClick) {
                root.closeRequested();
            }
        }
    }

    Rectangle {
        id: card
        width: Math.min(Palette.authCardMaxWidth, Math.max(Palette.authCardMinWidth, root.width - (Palette.spacingXxl * 2)))
        implicitHeight: contentLayout.implicitHeight + (Palette.spacingXxl * 2)
        anchors.centerIn: parent
        color: Palette.backgroundWhite
        radius: Palette.authCardRadius
        border.width: 1
        border.color: Palette.border

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Palette.spacingXxl
            spacing: Palette.spacingXxl

            AppPageTitleText {
                text: qsTr("Аккаунт")
                textPointSize: Palette.authTitleSize
                Layout.fillWidth: true
            }

            AppDescriptionText {
                text: qsTr("Войдите или создайте новый аккаунт")
                textPointSize: Palette.fontSizeSm
                Layout.fillWidth: true
            }

            TabBar {
                id: modeTabs
                Layout.fillWidth: true
                currentIndex: root.mode
                spacing: Palette.spacingSm

                background: Rectangle {
                    color: Palette.surfaceColor
                    radius: Palette.radiusXl
                }

                onCurrentIndexChanged: root.mode = currentIndex

                AuthModeTabButton {
                    id: loginTab
                    text: qsTr("Вход")
                }

                AuthModeTabButton {
                    id: registerTab
                    text: qsTr("Регистрация")
                }
            }

            StackLayout {
                id: authStack
                Layout.fillWidth: true
                currentIndex: root.mode

                LoginForm {
                    Layout.fillWidth: true
                    showGoogleAuth: root.googleAuthAvailable
                    showAppleAuth: root.appleAuthAvailable
                    onLoginRequested: function (email, password) {
                        root.loginRequested(email, password);
                    }
                    onGoogleAuthRequested: {
                        root.googleAuthRequested();
                    }
                    onAppleAuthRequested: {
                        root.appleAuthRequested();
                    }
                    onSwitchToRegisterRequested: {
                        root.mode = 1;
                    }
                }

                RegisterForm {
                    Layout.fillWidth: true
                    showGoogleAuth: root.googleAuthAvailable
                    showAppleAuth: root.appleAuthAvailable
                    onRegisterRequested: function (name, email, password) {
                        root.registerRequested(name, email, password);
                    }
                    onGoogleAuthRequested: {
                        root.googleAuthRequested();
                    }
                    onAppleAuthRequested: {
                        root.appleAuthRequested();
                    }
                    onSwitchToLoginRequested: {
                        root.mode = 0;
                    }
                }
            }
        }
    }
}
