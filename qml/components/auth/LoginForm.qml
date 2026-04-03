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

    signal loginRequested(string email, string password)
    signal switchToRegisterRequested()

    property string emailError: ""
    property string passwordError: ""

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
        spacing: 12

        Text {
            text: qsTr("Вход")
            Layout.fillWidth: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 20
            font.weight: Font.DemiBold
        }

        Text {
            text: qsTr("Используйте существующий аккаунт")
            Layout.fillWidth: true
            color: root.secondaryTextColor
            font.family: root.fontFamily
            font.pixelSize: 12
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
            }
            onAccepted: root.validateAndSubmit()

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

        CheckBox {
            id: rememberCheckBox
            text: qsTr("Запомнить меня")
            Layout.fillWidth: true
            font.family: root.fontFamily
            font.pixelSize: 12
            hoverEnabled: true

            indicator: Rectangle {
                implicitWidth: 18
                implicitHeight: 18
                radius: 5
                color: rememberCheckBox.checked ? root.accentColor : root.inputBackground
                border.width: 1
                border.color: rememberCheckBox.checked ? root.accentColor : (rememberCheckBox.hovered ? root.inputBorderHover : root.inputBorder)

                Text {
                    anchors.centerIn: parent
                    text: rememberCheckBox.checked ? "\u2713" : ""
                    color: "#FFFFFF"
                    font.pixelSize: 12
                    font.family: root.fontFamily
                    font.weight: Font.DemiBold
                }
            }

            contentItem: Text {
                text: rememberCheckBox.text
                color: root.secondaryTextColor
                font.family: root.fontFamily
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }
        }

        Button {
            id: loginButton
            Layout.fillWidth: true
            Layout.topMargin: 4
            text: qsTr("Войти")
            hoverEnabled: true
            font.family: root.fontFamily
            font.pixelSize: 14
            onClicked: root.validateAndSubmit()

            contentItem: Text {
                text: loginButton.text
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
                color: loginButton.down ? root.accentPressedColor : (loginButton.hovered ? root.accentHoverColor : root.accentColor)
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
                font.pixelSize: 12
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
