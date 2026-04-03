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

    signal registerRequested(string name, string email, string password)
    signal switchToLoginRequested()

    property string nameError: ""
    property string emailError: ""
    property string passwordError: ""
    property string confirmPasswordError: ""

    readonly property color textColor: darkTheme ? "#E5E7EB" : Palette.textPrimary
    readonly property color secondaryTextColor: darkTheme ? "#94A3B8" : Palette.textSecondary
    readonly property color inputBackground: darkTheme ? "#0B1220" : Palette.backgroundWhite
    readonly property color inputBorder: darkTheme ? "#334155" : "#D1D5DB"
    readonly property color inputBorderHover: darkTheme ? "#475569" : "#9CA3AF"
    readonly property color accentColor: darkTheme ? "#60A5FA" : Palette.accentPrimary
    readonly property color accentHoverColor: darkTheme ? "#3B82F6" : "#0A67C7"
    readonly property color accentPressedColor: darkTheme ? "#2563EB" : "#08539F"
    readonly property color errorColor: Palette.errorColor
    readonly property color linkColor: darkTheme ? "#93C5FD" : Palette.accentPrimary

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
        spacing: 12

        Text {
            text: qsTr("Регистрация")
            Layout.fillWidth: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 20
            font.weight: Font.DemiBold
        }

        Text {
            text: qsTr("Создайте новый аккаунт")
            Layout.fillWidth: true
            color: root.secondaryTextColor
            font.family: root.fontFamily
            font.pixelSize: 12
        }

        TextField {
            id: nameField
            Layout.fillWidth: true
            placeholderText: qsTr("Имя пользователя")
            selectByMouse: true
            hoverEnabled: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 14
            placeholderTextColor: root.secondaryTextColor
            leftPadding: 12
            rightPadding: 12
            topPadding: 10
            bottomPadding: 10
            onTextChanged: {
                if (root.nameError.length > 0) {
                    root.nameError = "";
                }
            }
            onAccepted: emailField.forceActiveFocus()

            background: Rectangle {
                radius: 8
                color: root.inputBackground
                border.width: nameField.activeFocus ? 2 : 1
                border.color: root.nameError.length > 0 ? root.errorColor : (nameField.activeFocus ? root.accentColor : (nameField.hovered ? root.inputBorderHover : root.inputBorder))
            }
        }

        Text {
            visible: root.nameError.length > 0
            text: root.nameError
            color: root.errorColor
            Layout.fillWidth: true
            font.family: root.fontFamily
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }

        TextField {
            id: emailField
            Layout.fillWidth: true
            placeholderText: qsTr("Email или логин")
            selectByMouse: true
            hoverEnabled: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 14
            placeholderTextColor: root.secondaryTextColor
            leftPadding: 12
            rightPadding: 12
            topPadding: 10
            bottomPadding: 10
            onTextChanged: {
                if (root.emailError.length > 0) {
                    root.emailError = "";
                }
            }
            onAccepted: passwordField.forceActiveFocus()

            background: Rectangle {
                radius: 8
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
            font.pixelSize: 12
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
            font.pixelSize: 14
            placeholderTextColor: root.secondaryTextColor
            leftPadding: 12
            rightPadding: 12
            topPadding: 10
            bottomPadding: 10
            onTextChanged: {
                if (root.passwordError.length > 0) {
                    root.passwordError = "";
                }
                if (root.confirmPasswordError.length > 0 && confirmPasswordField.text.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: confirmPasswordField.forceActiveFocus()

            background: Rectangle {
                radius: 8
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
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }

        TextField {
            id: confirmPasswordField
            Layout.fillWidth: true
            placeholderText: qsTr("Подтверждение пароля")
            echoMode: TextInput.Password
            selectByMouse: true
            hoverEnabled: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 14
            placeholderTextColor: root.secondaryTextColor
            leftPadding: 12
            rightPadding: 12
            topPadding: 10
            bottomPadding: 10
            onTextChanged: {
                if (root.confirmPasswordError.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: root.validateAndSubmit()

            background: Rectangle {
                radius: 8
                color: root.inputBackground
                border.width: confirmPasswordField.activeFocus ? 2 : 1
                border.color: root.confirmPasswordError.length > 0 ? root.errorColor : (confirmPasswordField.activeFocus ? root.accentColor : (confirmPasswordField.hovered ? root.inputBorderHover : root.inputBorder))
            }
        }

        Text {
            visible: root.confirmPasswordError.length > 0
            text: root.confirmPasswordError
            color: root.errorColor
            Layout.fillWidth: true
            font.family: root.fontFamily
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }

        Button {
            id: createButton
            Layout.fillWidth: true
            Layout.topMargin: 4
            text: qsTr("Создать аккаунт")
            hoverEnabled: true
            font.family: root.fontFamily
            font.pixelSize: 14
            onClicked: root.validateAndSubmit()

            contentItem: Text {
                text: createButton.text
                color: "#FFFFFF"
                font.family: root.fontFamily
                font.pixelSize: 14
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitHeight: 40
                radius: 8
                color: createButton.down ? root.accentPressedColor : (createButton.hovered ? root.accentHoverColor : root.accentColor)
            }
        }

        Button {
            id: loginLinkButton
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Уже есть аккаунт? Войти")
            hoverEnabled: true
            flat: true
            onClicked: root.switchToLoginRequested()

            contentItem: Text {
                text: loginLinkButton.text
                color: root.linkColor
                font.family: root.fontFamily
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.underline: loginLinkButton.hovered
            }

            background: Rectangle {
                color: "transparent"
            }
        }
    }
}
