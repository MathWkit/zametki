import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "scripts/Theme.js" as Palette

Item {
    id: root
    anchors.fill: parent

    property string fontFamily: "Inter"
    property int mode: 0
    property bool googleAuthAvailable: true
    property bool appleAuthAvailable: Qt.platform.os === "osx"
    property bool closeOnOutsideClick: false

    signal loginRequested(string email, string password)
    signal registerRequested(string name, string email, string password)
    signal googleAuthRequested
    signal appleAuthRequested
    signal closeRequested

    readonly property color pageBackground: Palette.backgroundLight
    readonly property color cardColor: Palette.backgroundWhite
    readonly property color cardBorderColor: Palette.border
    readonly property color headingColor: Palette.textPrimary
    readonly property color subtitleColor: Palette.textSecondary
    readonly property color tabContainerColor: Palette.surfaceColor
    readonly property color tabSelectedColor: Palette.accentPrimary
    readonly property color tabHoverColor: Palette.selected
    readonly property color tabTextColor: Palette.textPrimary

    Rectangle {
        anchors.fill: parent
        color: root.pageBackground
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
        implicitHeight: contentLayout.implicitHeight + (Palette.spacingXxl * 2)
        anchors.centerIn: parent
        color: root.cardColor
        radius: Palette.authCardRadius
        border.width: 1
        border.color: root.cardBorderColor

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Palette.spacingXxl
            spacing: Palette.spacingXxl

            Text {
                text: qsTr("Аккаунт")
                Layout.fillWidth: true
                color: root.headingColor
                font.family: root.fontFamily
                font.pixelSize: Palette.authTitleSize
                font.weight: Font.DemiBold
            }

            Text {
                text: qsTr("Войдите или создайте новый аккаунт")
                Layout.fillWidth: true
                color: root.subtitleColor
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeSm
            }

            TabBar {
                id: modeTabs
                Layout.fillWidth: true
                currentIndex: root.mode
                spacing: Palette.spacingSm

                background: Rectangle {
                    color: root.tabContainerColor
                    radius: Palette.radiusXl
                }

                onCurrentIndexChanged: root.mode = currentIndex

                TabButton {
                    id: loginTab
                    text: qsTr("Вход")
                    font.family: root.fontFamily
                    font.pixelSize: Palette.fontSizeBase
                    hoverEnabled: true

                    contentItem: Text {
                        text: loginTab.text
                        font: loginTab.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: loginTab.checked ? Palette.backgroundWhite : root.tabTextColor
                    }

                    background: Rectangle {
                        radius: Palette.radiusLg
                        color: loginTab.checked ? root.tabSelectedColor : (loginTab.hovered ? root.tabHoverColor : "transparent")
                    }
                }

                TabButton {
                    id: registerTab
                    text: qsTr("Регистрация")
                    font.family: root.fontFamily
                    font.pixelSize: Palette.fontSizeBase
                    hoverEnabled: true

                    contentItem: Text {
                        text: registerTab.text
                        font: registerTab.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: registerTab.checked ? Palette.backgroundWhite : root.tabTextColor
                    }

                    background: Rectangle {
                        radius: Palette.radiusLg
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
                    fontFamily: root.fontFamily
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
                    fontFamily: root.fontFamily
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
