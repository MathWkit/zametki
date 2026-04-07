import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette

Item {
    id: root

    implicitWidth: formLayout.implicitWidth
    implicitHeight: formLayout.implicitHeight

    property bool showGoogleAuth: true
    property bool showAppleAuth: Qt.platform.os === "osx"

    signal registerRequested(string name, string email, string password)
    signal googleAuthRequested
    signal appleAuthRequested
    signal switchToLoginRequested

    property string nameError: ""
    property string emailError: ""
    property string passwordError: ""
    property string confirmPasswordError: ""

    function validateAndSubmit() {
        const userName = nameField.text.trim();
        const email = emailField.text.trim();
        const password = passwordField.text;
        const confirmation = confirmPasswordField.text;

        nameError = userName.length === 0 ? qsTr("Введите имя пользователя") : "";
        emailError = email.length === 0 ? qsTr("Введите email или логин") : "";

        if (password.length === 0) {
            passwordError = qsTr("Введите пароль");
        } else if (password.length < 6) {
            passwordError = qsTr("Минимальная длина пароля: 6 символов");
        } else {
            passwordError = "";
        }

        if (confirmation.length === 0) {
            confirmPasswordError = qsTr("Подтвердите пароль");
        } else if (confirmation !== password) {
            confirmPasswordError = qsTr("Пароли не совпадают");
        } else {
            confirmPasswordError = "";
        }

        if (nameError.length > 0 || emailError.length > 0 || passwordError.length > 0 || confirmPasswordError.length > 0) {
            return;
        }

        registerRequested(userName, email, password);
    }

    ColumnLayout {
        id: formLayout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Palette.spacingXl

        AuthFormTitleText {
            text: qsTr("Регистрация")
            Layout.fillWidth: true
        }

        AuthFormSubtitleText {
            text: qsTr("Создайте новый аккаунт")
            Layout.fillWidth: true
        }

        AuthInputField {
            id: nameField
            Layout.fillWidth: true
            placeholderText: qsTr("Имя пользователя")
            hasError: root.nameError.length > 0
            onTextChanged: {
                if (root.nameError.length > 0) {
                    root.nameError = "";
                }
            }
            onAccepted: emailField.forceActiveFocus()
        }

        AuthErrorText {
            text: root.nameError
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

        AuthErrorText {
            text: root.emailError
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
                if (root.confirmPasswordError.length > 0 && confirmPasswordField.text.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: confirmPasswordField.forceActiveFocus()
        }

        AuthErrorText {
            text: root.passwordError
            Layout.fillWidth: true
        }

        AuthInputField {
            id: confirmPasswordField
            Layout.fillWidth: true
            placeholderText: qsTr("Подтверждение пароля")
            echoMode: TextInput.Password
            hasError: root.confirmPasswordError.length > 0
            onTextChanged: {
                if (root.confirmPasswordError.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: root.validateAndSubmit()
        }

        AuthErrorText {
            text: root.confirmPasswordError
            Layout.fillWidth: true
        }

        AuthPrimaryButton {
            id: createButton
            Layout.fillWidth: true
            Layout.topMargin: Palette.spacingSm
            text: qsTr("Создать аккаунт")
            onClicked: root.validateAndSubmit()
        }

        AuthDivider {
            Layout.fillWidth: true
        }

        AuthSocialButton {
            id: googleAuthButton
            visible: root.showGoogleAuth
            Layout.fillWidth: true
            text: qsTr("Зарегистрироваться через Google")
            onClicked: root.googleAuthRequested()
        }

        AuthSocialButton {
            id: appleAuthButton
            visible: root.showAppleAuth
            Layout.fillWidth: true
            text: qsTr("Зарегистрироваться через Apple ID")
            onClicked: root.appleAuthRequested()
        }

        AuthLinkButton {
            id: loginLinkButton
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Уже есть аккаунт? Войти")
            onClicked: root.switchToLoginRequested()
        }
    }
}
