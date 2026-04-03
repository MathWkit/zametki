import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette

Item {
    id: root
    anchors.fill: parent
    clip: false

    // ===== STYLE PROPERTIES =====
    readonly property string uiFontFamily: Palette.fontFamily

    // ===== COLORS =====
    property color colorBackground: Palette.backgroundWhite
    property color colorSurface: Palette.surfaceColor
    property color colorTextPrimary: Palette.textPrimary
    property color colorTextSecondary: Palette.textSecondary
    property color colorAccent: Palette.accentPrimary
    property color colorBorder: Palette.borderSoft
    property color colorDivider: Palette.dividerColor

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
        height: contentLayout.implicitHeight + Palette.spacingHuge
        color: colorBackground
        radius: Palette.radiusXl
        anchors.centerIn: parent

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Palette.spacingMassive
            spacing: 0

            // ==================== 1. Header ====================
            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: Palette.spacingHuge
                spacing: Palette.spacingXl

                Text {
                    text: "Профиль"
                    color: colorTextPrimary
                    font.pixelSize: Palette.fontSizeXl
                    font.family: root.uiFontFamily
                    font.styleName: "Bold"
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
                        color: colorTextPrimary
                        font.pixelSize: Palette.fontSizeLg
                        font.family: root.uiFontFamily
                    }
                }
            }

            // ==================== 2. Divider ====================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: colorDivider
                Layout.bottomMargin: Palette.spacingHuge
            }

            // ==================== 3. Current Account ====================
            ColumnLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: Palette.spacingMassive
                spacing: Palette.spacingXl

                Text {
                    text: "Текущий аккаунт"
                    color: colorTextPrimary
                    font.family: root.uiFontFamily
                    font.styleName: "SemiBold"
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
                            radius: Math.ceil(Palette.avatarBase / 2)
                            color: colorAccent
                            clip: true

                            Text {
                                anchors.centerIn: parent
                                text: getInitials(root.currentAccount.firstName, root.currentAccount.lastName)
                                color: colorBackground
                                font.pixelSize: Palette.fontSizeXl
                                font.family: root.uiFontFamily
                                font.styleName: "Bold"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft
                            spacing: Palette.spacingSm

                            Text {
                                text: root.currentAccount.firstName + " " + root.currentAccount.lastName
                                color: colorTextPrimary
                                font.family: root.uiFontFamily
                                font.styleName: "SemiBold"
                                font.pixelSize: Palette.fontSizeMd
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            Text {
                                text: root.currentAccount.email
                                color: colorTextSecondary
                                font.family: root.uiFontFamily
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

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Palette.buttonHeightBase
                        color: colorBackground
                        radius: Palette.radiusMd
                        border.color: colorBorder
                        border.width: 1

                        TapHandler {
                            onTapped: {
                                console.log("Кнопка: Сменить Имя");
                                root.changeNameClicked();
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Сменить Имя"
                            color: colorTextPrimary
                            font.family: root.uiFontFamily
                            font.styleName: "SemiBold"
                            font.pixelSize: Palette.fontSizeSm
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Palette.buttonHeightBase
                        color: colorBackground
                        radius: Palette.radiusMd
                        border.color: colorBorder
                        border.width: 1

                        TapHandler {
                            onTapped: {
                                console.log("Кнопка: Сменить пароль");
                                root.changePasswordClicked();
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Сменить пароль"
                            color: colorTextPrimary
                            font.family: root.uiFontFamily
                            font.styleName: "SemiBold"
                            font.pixelSize: Palette.fontSizeSm
                        }
                    }
                }
            }

            // ==================== 4. Accounts Section ====================
            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: Palette.spacingXl
                spacing: Palette.spacingXl

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Palette.spacingSm

                    Text {
                        text: "Аккаунты"
                        color: colorTextPrimary
                        font.family: root.uiFontFamily
                        font.styleName: "SemiBold"
                        font.pixelSize: Palette.fontSizeMd
                    }

                    Text {
                        text: "Switch between your local and work profiles"
                        color: colorTextSecondary
                        font.family: root.uiFontFamily
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
                    color: colorAccent
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
                        color: colorBackground
                        font.family: root.uiFontFamily
                        font.styleName: "SemiBold"
                        font.pixelSize: Palette.fontSizeSm
                    }
                }
            }

            // ==================== 5. Accounts List ====================
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: accountsList.implicitHeight
                Layout.bottomMargin: Palette.spacingMassive
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
                                color: modelData.isCurrent ? Palette.accentSidebar : colorSurface
                                radius: Palette.radiusMd

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Palette.spacingLg
                                    spacing: Palette.spacingXl

                                    // Account Avatar
                                    Rectangle {
                                        Layout.preferredWidth: Palette.avatarSmall
                                        Layout.preferredHeight: Palette.avatarSmall
                                        radius: Math.ceil(Palette.avatarSmall / 2)
                                        color: colorAccent
                                        clip: true

                                        Text {
                                            anchors.centerIn: parent
                                            text: getInitials(modelData.firstName, modelData.lastName)
                                            color: colorBackground
                                            font.pixelSize: Palette.fontSizeSm
                                            font.family: root.uiFontFamily
                                            font.styleName: "Bold"
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: Palette.spacingSm

                                        Text {
                                            text: modelData.firstName + " " + modelData.lastName
                                            color: colorTextPrimary
                                            font.family: root.uiFontFamily
                                            font.styleName: "SemiBold"
                                            font.pixelSize: Palette.fontSizeSm
                                        }

                                        Text {
                                            text: modelData.email
                                            color: colorTextSecondary
                                            font.family: root.uiFontFamily
                                            font.pixelSize: Palette.fontSizeXs
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Rectangle {
                                        Layout.preferredWidth: 85
                                        Layout.preferredHeight: Palette.buttonHeightBase
                                        color: modelData.isCurrent ? colorAccent : colorBackground
                                        radius: 100
                                        border.color: modelData.isCurrent ? colorAccent : colorBorder
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
                                            anchors.centerIn: parent
                                            text: modelData.isCurrent ? "Текущий" : "Выбрать"
                                            color: modelData.isCurrent ? colorBackground : colorTextPrimary
                                            font.family: root.uiFontFamily
                                            font.styleName: "SemiBold"
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
                color: colorDivider
                Layout.bottomMargin: Palette.spacingHuge
            }

            // ==================== 7. Footer ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                Text {
                    text: "You can stay signed in to several accounts and switch instantly."
                    color: colorTextSecondary
                    font.family: root.uiFontFamily
                    font.pixelSize: Palette.fontSizeSm
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: Palette.buttonHeightBase
                    color: colorBackground
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
                        font.family: root.uiFontFamily
                        font.styleName: "SemiBold"
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
