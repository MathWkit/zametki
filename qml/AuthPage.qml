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
    readonly property int cardOuterMargin: Palette.space3
    readonly property int cardContentPadding: Palette.dialogPadding
    readonly property int cardContentSpacing: Palette.space2

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
        width: Math.min(Math.max(Palette.authCardMinWidth, root.width * 0.42), Palette.authCardMaxWidth)
        height: Math.min(contentLayout.implicitHeight + (root.cardContentPadding * 2), Math.max(Palette.authCardMinWidth, root.height - (root.cardOuterMargin * 2)))
        anchors.centerIn: parent
        color: Palette.backgroundWhite
        radius: Palette.modalSurfaceRadius
        border.width: 1
        border.color: Palette.border
        clip: true

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: root.cardContentPadding
            spacing: root.cardContentSpacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                AppPageTitleText {
                    text: qsTr("Аккаунт")
                    textPixelSize: Palette.authTitleSize
                    Layout.fillWidth: true
                }

                AppIconSurfaceButton {
                    iconSource: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: root.closeRequested()
                }
            }

            AppDescriptionText {
                text: qsTr("Войдите или создайте новый аккаунт")
                textPixelSize: Palette.fontSizeSm
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

            ScrollView {
                id: formsScroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: authStack.implicitHeight
                clip: true
                contentWidth: availableWidth
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                StackLayout {
                    id: authStack
                    width: formsScroll.availableWidth
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
}
