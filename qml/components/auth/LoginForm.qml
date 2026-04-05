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

    signal loginRequested(string email, string password)
    signal googleAuthRequested
    signal appleAuthRequested
    signal switchToRegisterRequested

    property string emailError: ""
    property string passwordError: ""

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

        AppButton {
            id: loginButton
            Layout.fillWidth: true
            Layout.topMargin: Palette.spacingSm
            text: qsTr("Войти")
            fontFamily: root.fontFamily
            fontPointSize: Palette.fontSizeMd
            fontWeight: Font.DemiBold
            textColor: Palette.backgroundWhite
            backgroundColor: root.accentColor
            hoverBackgroundColor: root.accentHoverColor
            pressedBackgroundColor: root.accentPressedColor
            radius: Palette.radiusLg
            implicitHeight: Palette.buttonHeightLarge
            clickable: true
            onClicked: root.validateAndSubmit()
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

        AppButton {
            id: googleAuthButton
            visible: root.showGoogleAuth
            Layout.fillWidth: true
            text: qsTr("Продолжить с Google")
            fontFamily: root.fontFamily
            fontPointSize: Palette.fontSizeBase
            fontWeight: Font.DemiBold
            textColor: root.textColor
            backgroundColor: root.socialButtonColor
            hoverBackgroundColor: root.socialButtonHoverColor
            pressedBackgroundColor: root.socialButtonHoverColor
            borderWidth: 1
            borderColor: root.socialButtonBorderColor
            hoverBorderColor: root.socialButtonBorderColor
            pressedBorderColor: root.socialButtonBorderColor
            radius: Palette.radiusLg
            implicitHeight: Palette.authSocialButtonHeight
            clickable: true
            onClicked: root.googleAuthRequested()
        }

        AppButton {
            id: appleAuthButton
            visible: root.showAppleAuth
            Layout.fillWidth: true
            text: qsTr("Продолжить с Apple ID")
            fontFamily: root.fontFamily
            fontPointSize: Palette.fontSizeBase
            fontWeight: Font.DemiBold
            textColor: root.textColor
            backgroundColor: root.socialButtonColor
            hoverBackgroundColor: root.socialButtonHoverColor
            pressedBackgroundColor: root.socialButtonHoverColor
            borderWidth: 1
            borderColor: root.socialButtonBorderColor
            hoverBorderColor: root.socialButtonBorderColor
            pressedBorderColor: root.socialButtonBorderColor
            radius: Palette.radiusLg
            implicitHeight: Palette.authSocialButtonHeight
            clickable: true
            onClicked: root.appleAuthRequested()
        }

        AppButton {
            id: registerLinkButton
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Нет аккаунта? Зарегистрироваться")
            fontFamily: root.fontFamily
            fontPointSize: Palette.fontSizeSm
            textColor: root.linkColor
            backgroundColor: "transparent"
            hoverBackgroundColor: "transparent"
            pressedBackgroundColor: "transparent"
            horizontalPadding: 0
            verticalPadding: 0
            underlineOnHover: true
            clickable: true
            onClicked: root.switchToRegisterRequested()
        }
    }
}
