import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette

Item {
    id: root
    anchors.fill: parent
    clip: false

    // ===== STYLE PROPERTIES =====
    readonly property string uiFontFamily: "Inter"

    // ===== COLORS =====
    property color colorBackground: "#ffffff"
    property color colorSurface: "#F1F5F9"
    property color colorTextPrimary: Palette.textPrimary
    property color colorTextSecondary: Palette.textSecondary
    property color colorAccent: "#0b74de"
    property color colorBorder: Palette.border
    property color colorDivider: "#f3f4f6"

    signal closeClicked
    signal logoutClicked
    signal addAccountClicked
    signal switchAccountClicked(string accountId)

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
        width: 540
        height: contentLayout.implicitHeight + 48
        color: colorBackground
        radius: 10
        anchors.centerIn: parent

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: 24
            spacing: 0

            // ==================== 1. Header ====================
            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 20
                spacing: 12

                Text {
                    text: "Профиль"
                    color: colorTextPrimary
                    font.pointSize: 18
                    font.family: root.uiFontFamily
                    font.styleName: "Bold"
                    Layout.fillWidth: true
                }

                Rectangle {
                    radius: 6
                    Layout.preferredHeight: 36
                    Layout.preferredWidth: 36
                    TapHandler {
                        onTapped: root.closeClicked()
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: colorTextPrimary
                        font.pointSize: 16
                        font.family: root.uiFontFamily
                    }
                }
            }

            // ==================== 2. Divider ====================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: colorDivider
                Layout.bottomMargin: 20
            }

            // ==================== 3. Current Account ====================
            ColumnLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 24
                spacing: 12

                Text {
                    text: "Текущий аккаунт"
                    color: colorTextPrimary
                    font.family: root.uiFontFamily
                    font.styleName: "SemiBold"
                    font.pointSize: 14
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: currentAccountContent.implicitHeight + 24
                    radius: 6

                    RowLayout {
                        id: currentAccountContent
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        // Avatar or Initials
                        Rectangle {
                            Layout.preferredWidth: 64
                            Layout.preferredHeight: 64
                            radius: 32
                            color: colorAccent
                            clip: true

                            Text {
                                anchors.centerIn: parent
                                text: getInitials(root.currentAccount.firstName, root.currentAccount.lastName)
                                color: colorBackground
                                font.pointSize: 18
                                font.family: root.uiFontFamily
                                font.styleName: "Bold"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft
                            spacing: 2

                            Text {
                                text: root.currentAccount.firstName + " " + root.currentAccount.lastName
                                color: colorTextPrimary
                                font.family: root.uiFontFamily
                                font.styleName: "SemiBold"
                                font.pointSize: 14
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            Text {
                                text: root.currentAccount.email
                                color: colorTextSecondary
                                font.family: root.uiFontFamily
                                font.pointSize: 12
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Layout.topMargin: 12

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        color: "#FFFFFF"
                        radius: 6
                        border.color: colorBorder
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Сменить Имя"
                            color: colorTextPrimary
                            font.family: root.uiFontFamily
                            font.styleName: "SemiBold"
                            font.pointSize: 12
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        color: "#FFFFFF"
                        radius: 6
                        border.color: colorBorder
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Сменить пароль"
                            color: colorTextPrimary
                            font.family: root.uiFontFamily
                            font.styleName: "SemiBold"
                            font.pointSize: 12
                        }
                    }
                }
            }

            // ==================== 4. Accounts Section ====================
            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 12
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "Аккаунты"
                        color: colorTextPrimary
                        font.family: root.uiFontFamily
                        font.styleName: "SemiBold"
                        font.pointSize: 14
                    }

                    Text {
                        text: "Switch between your local and work profiles"
                        color: colorTextSecondary
                        font.family: root.uiFontFamily
                        font.pointSize: 12
                        wrapMode: Text.WordWrap
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 36
                    color: colorAccent
                    radius: 6

                    TapHandler {
                        onTapped: root.addAccountClicked()
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Добавить"
                        color: colorBackground
                        font.family: root.uiFontFamily
                        font.styleName: "SemiBold"
                        font.pointSize: 12
                    }
                }
            }

            // ==================== 5. Accounts List ====================
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: accountsList.implicitHeight
                Layout.bottomMargin: 24
                contentWidth: availableWidth

                ColumnLayout {
                    id: accountsList
                    width: parent.width
                    spacing: 12

                    Repeater {
                        model: root.accounts

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 68
                                color: modelData.isCurrent ? "#E6F0FF" : colorSurface
                                radius: 6

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 12

                                    // Account Avatar
                                    Rectangle {
                                        Layout.preferredWidth: 44
                                        Layout.preferredHeight: 44
                                        radius: 22
                                        color: colorAccent
                                        clip: true

                                        Text {
                                            anchors.centerIn: parent
                                            text: getInitials(modelData.firstName, modelData.lastName)
                                            color: colorBackground
                                            font.pointSize: 12
                                            font.family: root.uiFontFamily
                                            font.styleName: "Bold"
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        Text {
                                            text: modelData.firstName + " " + modelData.lastName
                                            color: colorTextPrimary
                                            font.family: root.uiFontFamily
                                            font.styleName: "SemiBold"
                                            font.pointSize: 12
                                        }

                                        Text {
                                            text: modelData.email
                                            color: colorTextSecondary
                                            font.family: root.uiFontFamily
                                            font.pointSize: 11
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Rectangle {
                                        Layout.preferredWidth: 85
                                        Layout.preferredHeight: 36
                                        color: modelData.isCurrent ? colorAccent : colorBackground
                                        radius: 100
                                        border.color: modelData.isCurrent ? colorAccent : colorBorder
                                        border.width: 1

                                        TapHandler {
                                            onTapped: {
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
                                            font.pointSize: 11
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
                Layout.bottomMargin: 20
            }

            // ==================== 7. Footer ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: "You can stay signed in to several accounts and switch instantly."
                    color: colorTextSecondary
                    font.family: root.uiFontFamily
                    font.pointSize: 12
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 36
                    color: "#FFFFFF"
                    radius: 6

                    TapHandler {
                        onTapped: root.logoutClicked()
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Log Out"
                        color: "#DC2626"
                        font.family: root.uiFontFamily
                        font.styleName: "SemiBold"
                        font.pointSize: 12
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
