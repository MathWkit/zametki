import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette

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

                Text {
                    text: "Профиль"
                    color: Palette.textPrimary
                    font.pixelSize: Palette.fontSizeXl
                    font.family: root.fontFamily
                    font.weight: 700
                    Layout.fillWidth: true
                }

                Rectangle {
                    radius: Palette.radiusMd
                    Layout.preferredHeight: Palette.buttonHeightBase
                    Layout.preferredWidth: Palette.buttonHeightBase
                    TapHandler {
                        onTapped: {
                            console.log("Кнопка: Закрыть");
                            root.closeClicked();
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: Palette.textPrimary
                        font.pixelSize: Palette.fontSizeLg
                        font.family: root.fontFamily
                    }
                }
            }

            // ==================== 2. Divider ====================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Palette.dividerColor
            }

            // ==================== 3. Current Account ====================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                Text {
                    text: "Текущий аккаунт"
                    color: Palette.textPrimary
                    font.family: root.fontFamily
                    font.weight: 600
                    font.pixelSize: Palette.fontSizeMd
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: currentAccountContent.implicitHeight + Palette.spacingLg
                    radius: Palette.radiusMd

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

                            Text {
                                text: root.currentAccount.firstName + " " + root.currentAccount.lastName
                                color: Palette.textPrimary
                                font.family: root.fontFamily
                                font.weight: 600
                                font.pixelSize: Palette.fontSizeMd
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            Text {
                                text: root.currentAccount.email
                                color: Palette.textSecondary
                                font.family: root.fontFamily
                                font.pixelSize: Palette.fontSizeSm
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

                        Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: Palette.buttonHeightBase
                            color: Palette.backgroundWhite
                            radius: Palette.radiusMd
                            border.color: Palette.borderSoft
                            border.width: 1

                            TapHandler {
                                onTapped: {
                                    console.log("Кнопка: " + parent.modelData.label);
                                    switch (parent.modelData.signal) {
                                    case "changeNameClicked":
                                        root.changeNameClicked();
                                        break;
                                    case "changePasswordClicked":
                                        root.changePasswordClicked();
                                        break;
                                    }
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.label
                                color: Palette.textPrimary
                                font.family: root.fontFamily
                                font.weight: 600
                                font.pixelSize: Palette.fontSizeSm
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

                    Text {
                        text: "Аккаунты"
                        color: Palette.textPrimary
                        font.family: root.fontFamily
                        font.weight: 600
                        font.pixelSize: Palette.fontSizeMd
                    }

                    Text {
                        text: "Switch between your local and work profiles"
                        color: Palette.textSecondary
                        font.family: root.fontFamily
                        font.pixelSize: Palette.fontSizeSm
                        wrapMode: Text.WordWrap
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: Palette.buttonHeightBase
                    color: Palette.accentPrimary
                    radius: Palette.radiusMd

                    TapHandler {
                        onTapped: {
                            console.log("Кнопка: Добавить");
                            root.addAccountClicked();
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Добавить"
                        color: Palette.backgroundWhite
                        font.family: root.fontFamily
                        font.weight: 600
                        font.pixelSize: Palette.fontSizeSm
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

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Palette.avatarSmall + Palette.spacingLg + Palette.spacingLg
                                color: modelData.isCurrent ? Palette.accentSidebar : Palette.surfaceColor
                                radius: Palette.radiusMd

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

                                        Text {
                                            text: modelData.firstName + " " + modelData.lastName
                                            color: Palette.textPrimary
                                            font.family: root.fontFamily
                                            font.weight: 600
                                            font.pixelSize: Palette.fontSizeSm
                                        }

                                        Text {
                                            text: modelData.email
                                            color: Palette.textSecondary
                                            font.family: root.fontFamily
                                            font.pixelSize: Palette.fontSizeXs
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Rectangle {
                                        Layout.preferredWidth: 85
                                        Layout.preferredHeight: switchText.implicitHeight + 20
                                        color: modelData.isCurrent ? Palette.accentPrimary : Palette.backgroundWhite
                                        radius: 100
                                        border.color: modelData.isCurrent ? Palette.accentPrimary : Palette.borderSoft
                                        border.width: 1

                                        TapHandler {
                                            onTapped: {
                                                console.log("Кнопка: " + (modelData.isCurrent ? "Текущий" : "Выбрать"));
                                                if (!modelData.isCurrent) {
                                                    root.switchAccountClicked(modelData.id);
                                                }
                                            }
                                        }

                                        Text {
                                            id: switchText
                                            anchors.centerIn: parent
                                            text: modelData.isCurrent ? "Текущий" : "Выбрать"
                                            color: modelData.isCurrent ? Palette.backgroundWhite : Palette.textPrimary
                                            font.family: root.fontFamily
                                            font.weight: 600
                                            font.pixelSize: Palette.fontSizeXs
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ==================== 6. Divider ====================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Palette.dividerColor
            }

            // ==================== 7. Footer ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                Text {
                    text: "You can stay signed in to several accounts and switch instantly."
                    color: Palette.textSecondary
                    font.family: root.fontFamily
                    font.pixelSize: Palette.fontSizeSm
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: Palette.buttonHeightBase
                    color: Palette.backgroundWhite
                    radius: Palette.radiusMd

                    TapHandler {
                        onTapped: {
                            console.log("Кнопка: Log Out");
                            root.logoutClicked();
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Log Out"
                        color: Palette.errorColor
                        font.family: root.fontFamily
                        font.weight: 600
                        font.pixelSize: Palette.fontSizeSm
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
