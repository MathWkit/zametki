import QtQuick 6.8
import QtQuick.Controls 2.15
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
            "alex1": "Owner",
            "alex2": "Owner"
        })
    property var roleOptions: ["Owner", "Editor", "Viewer"]

    function changeRole(personId, newRole) {
        var updated = Object.assign({}, peopleRoles);
        updated[personId] = newRole;
        peopleRoles = updated;
    }

    onSendClicked: {
        console.log("SEND LOGIC");
    }

    onCancelClicked: {
        console.log("CANCEL LOGIC");
    }

    onDoneClicked: {
        console.log("SAVE DATA");
    }

    onCopyClicked: {
        console.log("COPY LINK");
    }

    onCloseClicked: {
        console.log("CLOSE DIALOG");
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
                        text: "Share"
                    }
                    AppPageTitleText {
                        text: "Share “”"
                    }
                    AppDescriptionText {
                        text: "Invite people, manage access, and copy a link to this note."
                        wrapMode: Text.WordWrap
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
                                            text: "Add people or groups"
                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignTop
                                            Layout.fillWidth: true
                                        }
                                    }
                                }

                                AppActionButton {
                                    text: "Send"
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
                                text: "People with access"
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
                                        text: "Alex Kim"
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
                                    currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["alex1"] || "Viewer"))

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
                                        text: "Alex Kim"
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
                                    currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["alex2"] || "Viewer"))

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
                                text: "General access"
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
                                        text: "Restricted"
                                    }

                                    AppDescriptionText {
                                        text: "Only people added above can open this note."
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                AppDropdown {
                                    model: roleOptions
                                    currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["general"] || "Viewer"))

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
                            text: "Copy link"
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                // Cancel
                AppActionButton {
                    text: "Cancel"
                    textColor: Palette.textPrimary
                    backgroundColor: Palette.surfaceColor
                    radius: Palette.radiusMd
                    onClicked: cancelClicked()
                }

                // Done
                AppActionButton {
                    text: "Done"
                    textColor: Palette.backgroundWhite
                    backgroundColor: Palette.accentPrimary
                    radius: Palette.radiusMd
                    onClicked: doneClicked()
                }
            }
        }
    }
}
