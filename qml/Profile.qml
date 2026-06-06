import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette
import "components"

Item {
    id: root
    anchors.fill: parent
    clip: false

    // ===== LAYOUT HELPERS =====
    // Max height for accounts list to allow scrolling when there are many accounts (~2 items visible)
    readonly property int maxAccountsListHeight: (Palette.avatarSmall + Palette.spacingLg * 2) * 2 + Palette.spacingXl
    // Max height for the entire dialog to fit on screen with padding
    readonly property int maxDialogHeight: Math.min(Palette.dialogMaxHeight, root.height * 0.9)
    readonly property int dialogHorizontalMargin: Palette.space2

    signal closeClicked
    signal logoutClicked
    signal addAccountClicked
    signal switchAccountClicked(string accountId)
    signal changeNameClicked
    signal changePasswordClicked

    readonly property Item dialogItem: mainRectangle

    property var currentAccount: ({
            username: SyncState.isLoggedIn ? SyncState.username : qsTr("Не вошли"),
            serverUrl: SyncState.isLoggedIn ? SyncState.serverUrl : ""
        })

    property var accounts: SyncState.isLoggedIn ? [
        {
            id: "current",
            username: SyncState.username,
            serverUrl: SyncState.serverUrl,
            isCurrent: true
        }
    ] : []

    function getInitials(username) {
        return username ? username.charAt(0).toUpperCase() : "?";
    }

    Rectangle {
        id: mainRectangle
        width: Math.min(Palette.dialogMaxWidth, Math.max(Palette.authCardMinWidth, root.width - (root.dialogHorizontalMargin * 2)))
        height: Math.min(contentLayout.implicitHeight + Palette.spacingHuge, root.maxDialogHeight)
        color: Palette.backgroundWhite
        radius: Palette.modalSurfaceRadius
        anchors.centerIn: parent
        clip: true

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Palette.dialogPadding
            spacing: Palette.spacingHuge

            // ==================== 1. Header ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                AppPageTitleText {
                    text: qsTr("Профиль")
                    Layout.fillWidth: true
                }

                AppIconSurfaceButton {
                    iconSource: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg"
                    Layout.alignment: Qt.AlignVCenter
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
                    text: qsTr("Текущий аккаунт")
                }

                AppSectionCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(currentAccountContent.implicitHeight + Palette.spacingXl,
                                                     Palette.avatarBase + Palette.spacingXl * 2)

                    RowLayout {
                        id: currentAccountContent
                        anchors.fill: parent
                        anchors.margins: Palette.spacingLg
                        spacing: Palette.spacingXl

                        // Avatar or Initials
                        AppInitialsAvatar {
                            initials: getInitials(root.currentAccount.username)
                            avatarSize: Palette.avatarBase
                            Layout.preferredWidth: Palette.avatarBase
                            Layout.preferredHeight: Palette.avatarBase
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft
                            spacing: Palette.spacingSm

                            AppPageTitleText {
                                text: root.currentAccount.username
                                textPixelSize: Palette.fontSizeMd
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            AppDescriptionText {
                                text: root.currentAccount.serverUrl
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                                visible: root.currentAccount.serverUrl.length > 0
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
                                label: qsTr("Сменить Имя"),
                                signal: "changeNameClicked"
                            },
                            {
                                label: qsTr("Сменить пароль"),
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
                            fontPixelSize: Palette.fontSizeSm
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
                        text: qsTr("Аккаунты")
                    }

                    AppDescriptionText {
                        text: qsTr("Переключайтесь между личным и рабочим профилями")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                AppActionButton {
                    text: qsTr("Добавить")
                    Layout.preferredWidth: Palette.actionButtonMediumWidth
                    Layout.preferredHeight: Palette.buttonHeightBase
                    textColor: Palette.textPrimary
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
                                    AppInitialsAvatar {
                                        initials: getInitials(modelData.username)
                                        avatarSize: Palette.avatarSmall
                                        initialsPixelSize: Palette.fontSizeSm
                                        Layout.preferredWidth: Palette.avatarSmall
                                        Layout.preferredHeight: Palette.avatarSmall
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: Palette.spacingSm

                                        AppBodyText {
                                            text: modelData.username
                                        }

                                        AppDescriptionText {
                                            text: modelData.serverUrl
                                            visible: modelData.serverUrl && modelData.serverUrl.length > 0
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    AppActionButton {
                                        text: modelData.isCurrent ? qsTr("Текущий") : qsTr("Выбрать")
                                        textColor: Palette.textPrimary
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

            // ==================== 7. Sync row ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl
                visible: SyncState.isLoggedIn

                AppDescriptionText {
                    text: SyncState.isSyncing ? qsTr("Синхронизация…") : qsTr("Синхронизировать заметки с сервером")
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                }

                AppActionButton {
                    text: qsTr("Синхронизировать")
                    enabled: !SyncState.isSyncing
                    backgroundColor: Palette.backgroundWhite
                    borderColor: Palette.borderSoft
                    borderWidth: 1
                    onClicked: SyncState.syncNow()
                }
            }

            // ==================== 8. Footer ====================
            RowLayout {
                Layout.fillWidth: true
                spacing: Palette.spacingXl

                AppDescriptionText {
                    text: SyncState.isLoggedIn
                          ? qsTr("Заметки автоматически сохраняются на сервере при редактировании.")
                          : qsTr("Войдите в аккаунт, чтобы синхронизировать заметки между устройствами.")
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                }

                AppActionButton {
                    text: SyncState.isLoggedIn ? qsTr("Выйти") : qsTr("Войти")
                    textColor: SyncState.isLoggedIn ? Palette.errorColor : Palette.textPrimary
                    backgroundColor: Palette.backgroundWhite
                    borderColor: SyncState.isLoggedIn ? "transparent" : Palette.borderSoft
                    borderWidth: SyncState.isLoggedIn ? 0 : 1
                    onClicked: {
                        if (SyncState.isLoggedIn) {
                            root.logoutClicked();
                        } else {
                            root.closeClicked();
                            root.addAccountClicked();
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
