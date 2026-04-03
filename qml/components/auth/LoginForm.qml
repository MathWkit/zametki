import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette

Item {
    id: root

    implicitWidth: formLayout.implicitWidth
    implicitHeight: formLayout.implicitHeight

    property bool darkTheme: false
    property string fontFamily: "Inter"
    property bool showGoogleAuth: true
    property bool showAppleAuth: Qt.platform.os === "osx"

    signal loginRequested(string email, string password)
    signal googleAuthRequested
    signal appleAuthRequested
    signal switchToRegisterRequested

    property string emailError: ""
    property string passwordError: ""

    readonly property color textColor: darkTheme ? Palette.authPrimaryTextDark : Palette.textPrimary
    readonly property color secondaryTextColor: darkTheme ? Palette.authSecondaryTextDark : Palette.textSecondary
    readonly property color inputBackground: darkTheme ? Palette.authTabContainerDark : Palette.backgroundWhite
    readonly property color inputBorder: darkTheme ? Palette.authInputBorderDark : Palette.authInputBorderLight
    readonly property color inputBorderHover: darkTheme ? Palette.authInputBorderHoverDark : Palette.authInputBorderHoverLight
    readonly property color accentColor: darkTheme ? Palette.authAccentDark : Palette.accentPrimary
    readonly property color accentHoverColor: darkTheme ? Palette.authAccentHoverDark : Palette.authAccentHoverLight
    readonly property color accentPressedColor: darkTheme ? Palette.authAccentPressedDark : Palette.authAccentPressedLight
    readonly property color errorColor: Palette.errorColor
    readonly property color linkColor: darkTheme ? Palette.authLinkDark : Palette.accentPrimary
    readonly property color socialButtonColor: darkTheme ? Palette.authSocialButtonDark : Palette.backgroundWhite
    readonly property color socialButtonBorderColor: darkTheme ? Palette.authInputBorderDark : Palette.authInputBorderLight
    readonly property color socialButtonHoverColor: darkTheme ? Palette.authSocialButtonHoverDark : Palette.authSocialButtonHoverLight

    function validateAndSubmit() {
        const email = emailField.text.trim();
        const password = passwordField.text;

        emailError = email.length === 0 ? qsTr("Введите email или логин") : "";

        if (password.length === 0) {
            passwordError = qsTr("Введите пароль");
        } else if (password.length < 6) {
            passwordError = qsTr("Минимальная длина пароля: 6 символов");
        } else {
            passwordError = "";
        }

        if (emailError.length > 0 || passwordError.length > 0) {
            return;
        }

        loginRequested(email, password);
    }

    ColumnLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Palette.spacingXl

        Text {
            text: qsTr("Вход")
            Layout.fillWidth: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeXxl
            font.weight: Font.DemiBold
        }

        Text {
            text: qsTr("Используйте существующий аккаунт")
            Layout.fillWidth: true
            color: root.secondaryTextColor
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeSm
        }

        TextField {
            id: emailField
            Layout.fillWidth: true
            placeholderText: qsTr("Email или логин")
            selectByMouse: true
            hoverEnabled: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeMd
            placeholderTextColor: root.secondaryTextColor
            leftPadding: Palette.spacingXl
            rightPadding: Palette.spacingXl
            topPadding: Palette.authFieldVerticalPadding
            bottomPadding: Palette.authFieldVerticalPadding
            onTextChanged: {
                if (root.emailError.length > 0) {
                    root.emailError = "";
                }
            }
            onAccepted: passwordField.forceActiveFocus()

            background: Rectangle {
                radius: Palette.radiusLg
                color: root.inputBackground
                border.width: emailField.activeFocus ? 2 : 1
                border.color: root.emailError.length > 0 ? root.errorColor : (emailField.activeFocus ? root.accentColor : (emailField.hovered ? root.inputBorderHover : root.inputBorder))
            }
        }

        Text {
            visible: root.emailError.length > 0
            text: root.emailError
            color: root.errorColor
            Layout.fillWidth: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
        }

        TextField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: qsTr("Пароль")
            echoMode: TextInput.Password
            selectByMouse: true
            hoverEnabled: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeMd
            placeholderTextColor: root.secondaryTextColor
            leftPadding: Palette.spacingXl
            rightPadding: Palette.spacingXl
            topPadding: Palette.authFieldVerticalPadding
            bottomPadding: Palette.authFieldVerticalPadding
            onTextChanged: {
                if (root.passwordError.length > 0) {
                    root.passwordError = "";
                }
            }
            onAccepted: root.validateAndSubmit()

            background: Rectangle {
                radius: Palette.radiusLg
                color: root.inputBackground
                border.width: passwordField.activeFocus ? 2 : 1
                border.color: root.passwordError.length > 0 ? root.errorColor : (passwordField.activeFocus ? root.accentColor : (passwordField.hovered ? root.inputBorderHover : root.inputBorder))
            }
        }

        Text {
            visible: root.passwordError.length > 0
            text: root.passwordError
            color: root.errorColor
            Layout.fillWidth: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
        }

        CheckBox {
            id: rememberCheckBox
            text: qsTr("Запомнить меня")
            Layout.fillWidth: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeSm
            hoverEnabled: true
            spacing: Palette.spacingLg
            implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)

            indicator: Rectangle {
                implicitWidth: Palette.iconMedium
                implicitHeight: Palette.iconMedium
                y: (rememberCheckBox.height - height) / 2
                radius: Palette.radiusMd
                color: rememberCheckBox.checked ? root.accentColor : root.inputBackground
                border.width: 1
                border.color: rememberCheckBox.checked ? root.accentColor : (rememberCheckBox.hovered ? root.inputBorderHover : root.inputBorder)

                Text {
                    anchors.centerIn: parent
                    text: rememberCheckBox.checked ? "\u2713" : ""
                    color: Palette.backgroundWhite
                    font.pixelSize: Palette.fontSizeSm
                    font.family: root.fontFamily
                    font.weight: Font.DemiBold
                }
            }

            contentItem: Text {
                text: rememberCheckBox.text
                color: root.secondaryTextColor
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeSm
                leftPadding: rememberCheckBox.indicator.width + rememberCheckBox.spacing
                verticalAlignment: Text.AlignVCenter
            }
        }

        Button {
            id: loginButton
            Layout.fillWidth: true
            Layout.topMargin: Palette.spacingSm
            text: qsTr("Войти")
            hoverEnabled: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeMd
            onClicked: root.validateAndSubmit()

            contentItem: Text {
                text: loginButton.text
                color: Palette.backgroundWhite
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeMd
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitHeight: Palette.buttonHeightLarge
                radius: Palette.radiusLg
                color: loginButton.down ? root.accentPressedColor : (loginButton.hovered ? root.accentHoverColor : root.accentColor)
            }
        }

        Item {
            Layout.fillWidth: true
            implicitHeight: Palette.spacingHuge

            Rectangle {
                anchors.left: parent.left
                anchors.right: dividerLabel.left
                anchors.rightMargin: Palette.spacingLg
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: root.inputBorder
            }

            Text {
                id: dividerLabel
                anchors.centerIn: parent
                text: qsTr("или")
                color: root.secondaryTextColor
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeSm
            }

            Rectangle {
                anchors.left: dividerLabel.right
                anchors.leftMargin: Palette.spacingLg
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: root.inputBorder
            }
        }

        Button {
            id: googleAuthButton
            visible: root.showGoogleAuth
            Layout.fillWidth: true
            text: qsTr("Продолжить с Google")
            hoverEnabled: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeBase
            onClicked: root.googleAuthRequested()

            contentItem: Text {
                text: googleAuthButton.text
                color: root.textColor
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeBase
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitHeight: Palette.authSocialButtonHeight
                radius: Palette.radiusLg
                color: googleAuthButton.hovered ? root.socialButtonHoverColor : root.socialButtonColor
                border.width: 1
                border.color: root.socialButtonBorderColor
            }
        }

        Button {
            id: appleAuthButton
            visible: root.showAppleAuth
            Layout.fillWidth: true
            text: qsTr("Продолжить с Apple ID")
            hoverEnabled: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeBase
            onClicked: root.appleAuthRequested()

            contentItem: Text {
                text: appleAuthButton.text
                color: root.textColor
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeBase
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitHeight: Palette.authSocialButtonHeight
                radius: Palette.radiusLg
                color: appleAuthButton.hovered ? root.socialButtonHoverColor : root.socialButtonColor
                border.width: 1
                border.color: root.socialButtonBorderColor
            }
        }

        Button {
            id: registerLinkButton
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Нет аккаунта? Зарегистрироваться")
            hoverEnabled: true
            flat: true
            onClicked: root.switchToRegisterRequested()

            contentItem: Text {
                text: registerLinkButton.text
                color: root.linkColor
                font.family: root.fontFamily
                font.pixelSize: Palette.fontSizeSm
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.underline: registerLinkButton.hovered
            }

            background: Rectangle {
                color: "transparent"
            }
        }
    }
}
