import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette
import "components"

Item {
    id: item1
    anchors.fill: parent
    clip: false

    readonly property int dialogHorizontalMargin: Palette.space2

    signal sendClicked
    signal cancelClicked
    signal doneClicked
    signal copyClicked
    signal closeClicked

    readonly property Item dialogItem: rectangle

    // ===== STATE FOR ROLES =====
    property var peopleRoles: ({
            "alex1": qsTr("Владелец"),
            "alex2": qsTr("Владелец")
        })
    property var roleOptions: [qsTr("Владелец"), qsTr("Редактор"), qsTr("Читатель")]

    function changeRole(personId, newRole) {
        var updated = Object.assign({}, peopleRoles);
        updated[personId] = newRole;
        peopleRoles = updated;
    }

    onSendClicked: {
        console.log("Действие: отправка приглашения");
    }

    onCancelClicked: {
        console.log("Действие: отмена приглашения");
    }

    onDoneClicked: {
        console.log("Действие: сохранение изменений");
    }

    onCopyClicked: {
        console.log("Действие: копирование ссылки");
    }

    onCloseClicked: {
        console.log("Действие: закрытие диалога");
    }

    Rectangle {
        id: rectangle
        width: Math.min(Palette.dialogMaxWidth, Math.max(Palette.authCardMinWidth, parent.width - (item1.dialogHorizontalMargin * 2)))
        height: Math.min(Palette.dialogMaxHeight, Math.max(0, parent.height - (item1.dialogHorizontalMargin * 2)))
        color: Palette.backgroundWhite
        radius: Palette.radiusXl
        anchors.centerIn: parent
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Palette.spacingMassive
            spacing: Palette.spacingXl

            // ==================== 1. Заголовок Share ====================
            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: Palette.spacingSm
                    Layout.fillWidth: true

                    AppSidebarLabelText {
                        text: qsTr("Доступ")
                    }
                    AppPageTitleText {
                        text: qsTr("Поделиться заметкой")
                    }
                    AppDescriptionText {
                        text: qsTr("Приглашайте участников, управляйте правами и копируйте ссылку на заметку.")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                Rectangle {
                    color: Palette.surfaceColor
                    radius: Palette.radiusMd
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredHeight: Palette.buttonHeightBase
                    Layout.preferredWidth: Palette.buttonHeightBase
                    TapHandler {
                        onTapped: closeClicked()
                    }
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg"
                        width: Palette.iconSmall
                        height: Palette.iconSmall
                    }
                }
            }

            Flickable {
                id: bodyScroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: width
                contentHeight: bodyContent.implicitHeight

                ColumnLayout {
                    id: bodyContent
                    width: bodyScroll.width
                    spacing: Palette.spacingXl

                    // ==================== 2. Add people or groups ====================
                    AppSectionCard {
                        Layout.fillWidth: true
                        implicitHeight: addPeopleLayout.implicitHeight + (Palette.spacingXl * 2)

                        ColumnLayout {
                            id: addPeopleLayout
                            anchors.fill: parent
                            anchors.margins: Palette.spacingXl
                            spacing: Palette.spacingLg

                            RowLayout {
                                spacing: Palette.spacingLg
                                Layout.fillWidth: true

                                Rectangle {
                                    id: addPeopleInputContainer
                                    color: "transparent"
                                    radius: Palette.radiusMd
                                    Layout.fillWidth: true
                                    implicitHeight: addPeopleInputRow.implicitHeight + (Palette.spacingXl * 2)

                                    RowLayout {
                                        id: addPeopleInputRow
                                        anchors.fill: parent
                                        anchors.margins: Palette.spacingXl
                                        spacing: Palette.spacingLg

                                        Image {
                                            source: "qrc:/qt/qml/zametki/assets/icons/share/people.svg"
                                            Layout.preferredWidth: Palette.iconSmall
                                            Layout.preferredHeight: Palette.iconSmall
                                        }

                                        AppSidebarLabelText {
                                            text: qsTr("Добавьте людей или группы")
                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignVCenter
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }
                                }

                                AppActionButton {
                                    text: qsTr("Отправить")
                                    onClicked: sendClicked()
                                }
                            }
                        }
                    }

                    // ==================== 3. People with access ====================
                    AppSectionCard {
                        Layout.fillWidth: true
                        implicitHeight: peopleColumn.implicitHeight + (Palette.spacingXl * 2)

                        ColumnLayout {
                            id: peopleColumn
                            anchors.fill: parent
                            anchors.margins: Palette.spacingXl
                            spacing: Palette.spacingXl

                            AppSidebarLabelText {
                                text: qsTr("Люди с доступом")
                            }

                            // ── Первая строка (Alex) ──
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Palette.spacingXl

                                AppInitialsAvatar {
                                    initials: "AK"
                                    avatarSize: Palette.avatarMedium
                                    initialsPixelSize: Palette.fontSizeSm
                                    Layout.preferredWidth: Palette.avatarMedium
                                    Layout.preferredHeight: Palette.avatarMedium
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Palette.spacingSm

                                    AppBodyText {
                                        text: qsTr("Алекс Ким")
                                    }

                                    AppDescriptionText {
                                        text: "alex@vault.app"
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                AppDropdown {
                                    model: roleOptions
                                    currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["alex1"] || qsTr("Читатель")))

                                    onActivated: changeRole("alex1", currentText)
                                }
                            }

                            // ── Вторая строка (Alex) ──
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Palette.spacingXl

                                AppInitialsAvatar {
                                    initials: "AK"
                                    avatarSize: Palette.avatarMedium
                                    initialsPixelSize: Palette.fontSizeSm
                                    Layout.preferredWidth: Palette.avatarMedium
                                    Layout.preferredHeight: Palette.avatarMedium
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Palette.spacingSm

                                    AppBodyText {
                                        text: qsTr("Алекс Ким")
                                    }

                                    AppDescriptionText {
                                        text: "alex@vault.app"
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                AppDropdown {
                                    model: roleOptions
                                    currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["alex2"] || qsTr("Читатель")))

                                    onActivated: changeRole("alex2", currentText)
                                }
                            }
                        }
                    }

                    // ==================== 4. General access ====================
                    AppSectionCard {
                        Layout.fillWidth: true
                        implicitHeight: generalColumn.implicitHeight + (Palette.spacingXl * 2)

                        ColumnLayout {
                            id: generalColumn
                            anchors.fill: parent
                            anchors.margins: Palette.spacingXl
                            spacing: Palette.spacingXl

                            AppSidebarLabelText {
                                text: qsTr("Общий доступ")
                            }

                            RowLayout {
                                spacing: Palette.spacingXl
                                Layout.fillWidth: true

                                Image {
                                    source: "qrc:/qt/qml/zametki/assets/icons/share/link.svg"
                                    Layout.preferredWidth: Palette.avatarMedium
                                    Layout.preferredHeight: Palette.avatarMedium
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                ColumnLayout {
                                    spacing: Palette.spacingSm
                                    Layout.fillWidth: true

                                    AppBodyText {
                                        text: qsTr("Ограничен")
                                    }

                                    AppDescriptionText {
                                        text: qsTr("Открыть заметку смогут только люди, добавленные выше.")
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                        Layout.minimumWidth: 0
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                AppDropdown {
                                    model: roleOptions
                                    currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["general"] || qsTr("Читатель")))

                                    onActivated: changeRole("general", currentText)
                                }
                            }
                        }
                    }
                }
            }

            // ==================== 5. Нижние кнопки ====================
            RowLayout {
                spacing: Palette.spacingXl
                Layout.fillWidth: true

                // Copy link
                Rectangle {
                    color: Palette.surfaceColor
                    radius: Palette.radiusMd
                    implicitWidth: copyRow.implicitWidth + (Palette.spacingXxl * 2)
                    implicitHeight: copyRow.implicitHeight + Palette.spacingXxl
                    Layout.maximumWidth: item1.width * 0.5
                    clip: true
                    TapHandler {
                        onTapped: copyClicked()
                    }

                    RowLayout {
                        id: copyRow
                        anchors.centerIn: parent
                        spacing: Palette.spacingLg
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/share/copy.svg"
                            Layout.preferredWidth: Palette.iconTiny
                            Layout.preferredHeight: Palette.iconTiny
                        }
                        AppSidebarLabelText {
                            text: qsTr("Копировать ссылку")
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                // Cancel
                AppActionButton {
                    text: qsTr("Отмена")
                    textColor: Palette.textPrimary
                    backgroundColor: Palette.surfaceColor
                    radius: Palette.radiusMd
                    onClicked: cancelClicked()
                }

                // Done
                AppActionButton {
                    text: qsTr("Готово")
                    textColor: Palette.backgroundWhite
                    backgroundColor: Palette.accentPrimary
                    radius: Palette.radiusMd
                    onClicked: doneClicked()
                }
            }
        }
    }
}
