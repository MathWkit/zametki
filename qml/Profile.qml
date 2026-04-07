import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette
import "components"

Item {
    id: root
    anchors.fill: parent
    clip: false

    // ===== LAYOUT HELPERS =====
    readonly property int avatarRadius: Palette.avatarBase / 2
    readonly property int avatarSmallRadius: Palette.avatarSmall / 2
    readonly property string fontFamily: "Inter"
    // Max height for accounts list to allow scrolling when there are many accounts (~2 items visible)
    readonly property int maxAccountsListHeight: (Palette.avatarSmall + Palette.spacingLg * 2) * 2 + Palette.spacingXl
    // Max height for the entire dialog to fit on screen with padding
    readonly property int maxDialogHeight: Math.min(600, root.height * 0.9)

    signal closeClicked
    signal logoutClicked
    signal addAccountClicked
    signal switchAccountClicked(string accountId)
    signal changeNameClicked
    signal changePasswordClicked

    readonly property Item dialogItem: mainRectangle

    // ===== SAMPLE DATA =====
    property var currentAccount: ({
            firstName: "John",
            lastName: "Doe",
            email: "john.doe@example.com",
            avatar: ""
        })

    property var accounts: [
        {
            id: "account1",
            firstName: "John",
            lastName: "Doe",
            email: "john.doe@example.com",
            avatar: "",
            isCurrent: true
        },
        {
            id: "account2",
            firstName: "Jane",
            lastName: "Smith",
            email: "jane.smith@work.com",
            avatar: "",
            isCurrent: false
        }
    ]

    function getInitials(firstName, lastName) {
        const first = firstName ? firstName.charAt(0).toUpperCase() : "";
        const last = lastName ? lastName.charAt(0).toUpperCase() : "";
        return first + last;
    }

    Rectangle {
        id: mainRectangle
        width: Palette.dialogMaxWidth
        height: Math.min(contentLayout.implicitHeight + Palette.spacingHuge, root.maxDialogHeight)
        color: Palette.backgroundWhite
        radius: Palette.radiusXl
        anchors.centerIn: parent

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Palette.spacingMassive
            spacing: Palette.spacingHuge

            // ==================== 1. Header ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                AppPageTitleText {
                    text: "Профиль"
                    Layout.fillWidth: true
                }

                AppActionButtonCompact {
                    text: "✕"
                    backgroundColor: Palette.surfaceColor
                    Layout.preferredHeight: Palette.buttonHeightBase
                    Layout.preferredWidth: Palette.buttonHeightBase
                    onClicked: {
                        console.log("Кнопка: Закрыть");
                        root.closeClicked();
                    }
                }
            }

            // ==================== 2. Divider ====================
            AppDivider {}

            // ==================== 3. Current Account ====================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                AppSectionTitleText {
                    text: "Текущий аккаунт"
                }

                AppSectionCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: currentAccountContent.implicitHeight + Palette.spacingLg

                    RowLayout {
                        id: currentAccountContent
                        anchors.fill: parent
                        anchors.margins: Palette.spacingLg
                        spacing: Palette.spacingXl

                        // Avatar or Initials
                        Rectangle {
                            Layout.preferredWidth: Palette.avatarBase
                            Layout.preferredHeight: Palette.avatarBase
                            radius: root.avatarRadius
                            color: Palette.accentPrimary
                            clip: true

                            Text {
                                anchors.centerIn: parent
                                text: getInitials(root.currentAccount.firstName, root.currentAccount.lastName)
                                color: Palette.backgroundWhite
                                font.pixelSize: Palette.fontSizeXl
                                font.family: root.fontFamily
                                font.weight: 700
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft
                            spacing: Palette.spacingSm

                            AppBodyText {
                                text: root.currentAccount.firstName + " " + root.currentAccount.lastName
                                font.pointSize: Palette.fontSizeMd
                                font.styleName: "SemiBold"
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            AppDescriptionText {
                                text: root.currentAccount.email
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Palette.spacingXl
                    Layout.topMargin: Palette.spacingXl

                    Repeater {
                        model: [
                            {
                                label: "Сменить Имя",
                                signal: "changeNameClicked"
                            },
                            {
                                label: "Сменить пароль",
                                signal: "changePasswordClicked"
                            }
                        ]

                        AppActionButton {
                            required property var modelData
                            text: modelData.label
                            Layout.fillWidth: true
                            Layout.preferredHeight: Palette.buttonHeightBase
                            backgroundColor: Palette.backgroundWhite
                            borderColor: Palette.borderSoft
                            borderWidth: 1
                            fontPointSize: Palette.fontSizeSm
                            onClicked: {
                                console.log("Кнопка: " + modelData.label);
                                switch (modelData.signal) {
                                case "changeNameClicked":
                                    root.changeNameClicked();
                                    break;
                                case "changePasswordClicked":
                                    root.changePasswordClicked();
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            // ==================== 4. Accounts Section ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Palette.spacingSm

                    AppSectionTitleText {
                        text: "Аккаунты"
                    }

                    AppDescriptionText {
                        text: "Switch between your local and work profiles"
                        wrapMode: Text.WordWrap
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                AppActionButton {
                    text: "Добавить"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: Palette.buttonHeightBase
                    textColor: Palette.backgroundWhite
                    backgroundColor: Palette.accentPrimary
                    onClicked: {
                        console.log("Кнопка: Добавить");
                        root.addAccountClicked();
                    }
                }
            }

            // ==================== 5. Accounts List ====================
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(accountsList.implicitHeight, root.maxAccountsListHeight)
                Layout.fillHeight: false
                contentWidth: availableWidth

                ColumnLayout {
                    id: accountsList
                    width: parent.width
                    spacing: Palette.spacingXl

                    Repeater {
                        model: root.accounts

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Palette.spacingLg

                            AppSectionCard {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Palette.avatarSmall + Palette.spacingLg + Palette.spacingLg
                                cardColor: modelData.isCurrent ? Palette.accentSidebar : Palette.surfaceColor
                                borderLineColor: "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Palette.spacingLg
                                    spacing: Palette.spacingXl

                                    // Account Avatar
                                    Rectangle {
                                        Layout.preferredWidth: Palette.avatarSmall
                                        Layout.preferredHeight: Palette.avatarSmall
                                        radius: root.avatarSmallRadius
                                        color: Palette.accentPrimary
                                        clip: true

                                        Text {
                                            anchors.centerIn: parent
                                            text: getInitials(modelData.firstName, modelData.lastName)
                                            color: Palette.backgroundWhite
                                            font.pixelSize: Palette.fontSizeSm
                                            font.family: root.fontFamily
                                            font.weight: 700
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: Palette.spacingSm

                                        AppBodyText {
                                            text: modelData.firstName + " " + modelData.lastName
                                        }

                                        AppDescriptionText {
                                            text: modelData.email
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    AppActionButton {
                                        text: modelData.isCurrent ? "Текущий" : "Выбрать"
                                        textColor: modelData.isCurrent ? Palette.backgroundWhite : Palette.textPrimary
                                        backgroundColor: modelData.isCurrent ? Palette.accentPrimary : Palette.backgroundWhite
                                        borderColor: modelData.isCurrent ? Palette.accentPrimary : Palette.borderSoft
                                        borderWidth: 1
                                        clickable: !modelData.isCurrent
                                        onClicked: {
                                            console.log("Кнопка: " + (modelData.isCurrent ? "Текущий" : "Выбрать"));
                                            if (!modelData.isCurrent) {
                                                root.switchAccountClicked(modelData.id);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ==================== 6. Divider ====================
            AppDivider {}

            // ==================== 7. Footer ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                AppDescriptionText {
                    text: "You can stay signed in to several accounts and switch instantly."
                    wrapMode: Text.WordWrap
                }

                AppActionButton {
                    text: "Log Out"
                    textColor: Palette.errorColor
                    backgroundColor: Palette.backgroundWhite
                    onClicked: {
                        console.log("Кнопка: Log Out");
                        root.logoutClicked();
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
