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

        AppPageTitleText {
            text: qsTr("Регистрация")
            textPointSize: Palette.fontSizeXxl
            Layout.fillWidth: true
        }

        AppDescriptionText {
            text: qsTr("Создайте новый аккаунт")
            textPointSize: Palette.fontSizeSm
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

        AppDescriptionText {
            text: root.nameError
            visible: text.length > 0
            textColor: Palette.errorColor
            textPointSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
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
            textPointSize: Palette.fontSizeSm
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
                if (root.confirmPasswordError.length > 0 && confirmPasswordField.text.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: confirmPasswordField.forceActiveFocus()
        }

        AppDescriptionText {
            text: root.passwordError
            visible: text.length > 0
            textColor: Palette.errorColor
            textPointSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
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

        AppDescriptionText {
            text: root.confirmPasswordError
            visible: text.length > 0
            textColor: Palette.errorColor
            textPointSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
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
