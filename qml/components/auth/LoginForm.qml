import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

Item {
    id: root

    implicitWidth: formLayout.implicitWidth
    implicitHeight: formLayout.implicitHeight

    property bool showGoogleAuth: true
    property bool showAppleAuth: Qt.platform.os === "osx"

    signal loginRequested(string email, string password)
    signal googleAuthRequested
    signal appleAuthRequested
    signal switchToRegisterRequested

    property string emailError: ""
    property string passwordError: ""

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

        AppPageTitleText {
            text: qsTr("Вход")
            textPixelSize: Palette.fontSizeXxl
            Layout.fillWidth: true
        }

        AppDescriptionText {
            text: qsTr("Используйте существующий аккаунт")
            textPixelSize: Palette.fontSizeSm
            Layout.fillWidth: true
        }

        AuthInputField {
            id: emailField
            Layout.fillWidth: true
            placeholderText: qsTr("Email или логин")
            hasError: root.emailError.length > 0
            onTextChanged: {
                if (root.emailError.length > 0) {
                    root.emailError = "";
                }
            }
            onAccepted: passwordField.forceActiveFocus()
        }

        AppDescriptionText {
            text: root.emailError
            visible: text.length > 0
            textColor: Palette.errorColor
            textPixelSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        AuthInputField {
            id: passwordField
            Layout.fillWidth: true
            placeholderText: qsTr("Пароль")
            echoMode: TextInput.Password
            hasError: root.passwordError.length > 0
            onTextChanged: {
                if (root.passwordError.length > 0) {
                    root.passwordError = "";
                }
            }
            onAccepted: root.validateAndSubmit()
        }

        AppDescriptionText {
            text: root.passwordError
            visible: text.length > 0
            textColor: Palette.errorColor
            textPixelSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        CheckBox {
            id: rememberCheckBox
            text: qsTr("Запомнить меня")
            Layout.fillWidth: true
            font.family: Palette.fontFamily
            font.pixelSize: Palette.fontSizeSm
            hoverEnabled: true
            spacing: Palette.spacingLg
            implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)

            indicator: Rectangle {
                implicitWidth: Palette.iconMedium
                implicitHeight: Palette.iconMedium
                y: (rememberCheckBox.height - height) / 2
                radius: Palette.radiusMd
                color: rememberCheckBox.checked ? Palette.accentPrimary : Palette.backgroundWhite
                border.width: 1
                border.color: rememberCheckBox.checked ? Palette.accentPrimary : (rememberCheckBox.hovered ? Palette.authInputBorderHover : Palette.authInputBorder)

                Text {
                    anchors.centerIn: parent
                    text: rememberCheckBox.checked ? "\u2713" : ""
                    color: Palette.backgroundWhite
                    font.pixelSize: Palette.fontSizeSm
                    font.family: Palette.fontFamily
                    font.weight: Font.DemiBold
                }
            }

            contentItem: Text {
                text: rememberCheckBox.text
                color: Palette.textSecondary
                font.family: Palette.fontFamily
                font.pixelSize: Palette.fontSizeSm
                leftPadding: rememberCheckBox.indicator.width + rememberCheckBox.spacing
                verticalAlignment: Text.AlignVCenter
            }
        }

        AuthPrimaryButton {
            id: loginButton
            Layout.fillWidth: true
            Layout.topMargin: Palette.spacingSm
            text: qsTr("Войти")
            onClicked: root.validateAndSubmit()
        }

        AuthDivider {
            Layout.fillWidth: true
        }

        AuthSocialButton {
            id: googleAuthButton
            visible: root.showGoogleAuth
            Layout.fillWidth: true
            text: qsTr("Продолжить с Google")
            onClicked: root.googleAuthRequested()
        }

        AuthSocialButton {
            id: appleAuthButton
            visible: root.showAppleAuth
            Layout.fillWidth: true
            text: qsTr("Продолжить с Apple ID")
            onClicked: root.appleAuthRequested()
        }

        AuthLinkButton {
            id: registerLinkButton
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Нет аккаунта? Зарегистрироваться")
            onClicked: root.switchToRegisterRequested()
        }
    }
}
