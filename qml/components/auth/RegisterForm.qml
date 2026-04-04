import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette

Item {
    id: root

    implicitWidth: formLayout.implicitWidth
    implicitHeight: formLayout.implicitHeight

    property string fontFamily: "Inter"
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

    readonly property color textColor: Palette.textPrimary
    readonly property color secondaryTextColor: Palette.textSecondary
    readonly property color inputBackground: Palette.backgroundWhite
    readonly property color inputBorder: Palette.authInputBorder
    readonly property color inputBorderHover: Palette.authInputBorderHover
    readonly property color accentColor: Palette.accentPrimary
    readonly property color accentHoverColor: Palette.authAccentHover
    readonly property color accentPressedColor: Palette.authAccentPressed
    readonly property color errorColor: Palette.errorColor
    readonly property color linkColor: Palette.accentPrimary
    readonly property color socialButtonColor: Palette.backgroundWhite
    readonly property color socialButtonBorderColor: Palette.authInputBorder
    readonly property color socialButtonHoverColor: Palette.authSocialButtonHover

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

        Text {
            text: qsTr("Регистрация")
            Layout.fillWidth: true
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeXxl
            font.weight: Font.DemiBold
        }

        Text {
            text: qsTr("Создайте новый аккаунт")
            Layout.fillWidth: true
            color: root.secondaryTextColor
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeSm
        }

        TextField {
            id: nameField
            Layout.fillWidth: true
            placeholderText: qsTr("Имя пользователя")
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
                if (root.nameError.length > 0) {
                    root.nameError = "";
                }
            }
            onAccepted: emailField.forceActiveFocus()

            background: Rectangle {
                radius: Palette.radiusLg
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
            font.pixelSize: Palette.fontSizeSm
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
                if (root.confirmPasswordError.length > 0 && confirmPasswordField.text.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: confirmPasswordField.forceActiveFocus()

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

        TextField {
            id: confirmPasswordField
            Layout.fillWidth: true
            placeholderText: qsTr("Подтверждение пароля")
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
                if (root.confirmPasswordError.length > 0) {
                    root.confirmPasswordError = "";
                }
            }
            onAccepted: root.validateAndSubmit()

            background: Rectangle {
                radius: Palette.radiusLg
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
            font.pixelSize: Palette.fontSizeSm
            wrapMode: Text.WordWrap
        }

        Button {
            id: createButton
            Layout.fillWidth: true
            Layout.topMargin: Palette.spacingSm
            text: qsTr("Создать аккаунт")
            hoverEnabled: true
            font.family: root.fontFamily
            font.pixelSize: Palette.fontSizeMd
            onClicked: root.validateAndSubmit()

            contentItem: Text {
                text: createButton.text
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
                color: createButton.down ? root.accentPressedColor : (createButton.hovered ? root.accentHoverColor : root.accentColor)
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
            text: qsTr("Зарегистрироваться через Google")
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
            text: qsTr("Зарегистрироваться через Apple ID")
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
                font.pixelSize: Palette.fontSizeSm
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
