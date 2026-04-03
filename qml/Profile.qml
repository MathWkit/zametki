import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent
    clip: false

    // ===== COLORS =====
    property color colorBackground: "#ffffff"
    property color colorSurface: "#f1f5f9"
    property color colorTextPrimary: "#0f1724"
    property color colorTextSecondary: "#667085"
    property color colorAccent: "#0b74de"
    property color colorBorder: "#e5e7eb"
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
        height: 700
        color: colorBackground
        radius: 10
        anchors.centerIn: parent

        ColumnLayout {
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
                    font.family: "Inter"
                    font.styleName: "Bold"
                    Layout.fillWidth: true
                }

                Rectangle {
                    color: colorSurface
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
                        font.family: "Inter"
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
                spacing: 16

                Text {
                    text: "Текущий аккаунт"
                    color: colorTextSecondary
                    font.family: "Inter"
                    font.styleName: "Medium"
                    font.pointSize: 12
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

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
                            font.pointSize: 20
                            font.family: "Inter"
                            font.styleName: "Bold"
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: root.currentAccount.firstName + " " + root.currentAccount.lastName
                            color: colorTextPrimary
                            font.family: "Inter"
                            font.styleName: "SemiBold"
                            font.pointSize: 14
                        }

                        Text {
                            text: root.currentAccount.email
                            color: colorTextSecondary
                            font.family: "Inter"
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
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                        font.pointSize: 14
                    }

                    Text {
                        text: "Switch between your local and work profiles"
                        color: colorTextSecondary
                        font.family: "Inter"
                        font.pointSize: 12
                        wrapMode: Text.WordWrap
                    }
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
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                    }
                }
            }

            // ==================== 5. Accounts List ====================
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                Layout.bottomMargin: 24
                contentWidth: availableWidth

                ColumnLayout {
                    width: parent.width
                    spacing: 12

                    Repeater {
                        model: root.accounts

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            RowLayout {
                                Layout.fillWidth: true
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
                                        font.pointSize: 14
                                        font.family: "Inter"
                                        font.styleName: "Bold"
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: modelData.firstName + " " + modelData.lastName
                                        color: colorTextPrimary
                                        font.family: "Inter"
                                        font.styleName: "SemiBold"
                                        font.pointSize: 12
                                    }

                                    Text {
                                        text: modelData.email
                                        color: colorTextSecondary
                                        font.family: "Inter"
                                        font.pointSize: 11
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 80
                                    Layout.preferredHeight: 32
                                    color: modelData.isCurrent ? colorSurface : colorAccent
                                    radius: 6
                                    border.color: modelData.isCurrent ? colorBorder : colorAccent
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
                                        text: modelData.isCurrent ? "текущий" : "выбрать"
                                        color: modelData.isCurrent ? colorTextPrimary : colorBackground
                                        font.family: "Inter"
                                        font.styleName: "SemiBold"
                                        font.pointSize: 11
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
                    font.family: "Inter"
                    font.pointSize: 12
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 36
                    color: colorSurface
                    radius: 6
                    border.color: colorBorder
                    border.width: 1

                    TapHandler {
                        onTapped: root.logoutClicked()
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Log Out"
                        color: colorTextPrimary
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
