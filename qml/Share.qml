import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette
import "components"

Item {
    id: item1
    anchors.fill: parent
    clip: false

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
        width: 540
        height: 561
        color: Palette.backgroundWhite
        radius: 10
        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            // ==================== 1. Заголовок Share ====================
            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 4
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
                    radius: 6
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredHeight: 36
                    Layout.preferredWidth: 36
                    TapHandler {
                        onTapped: closeClicked()
                    }
                    Image {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        anchors.topMargin: 8
                        anchors.bottomMargin: 8
                        source: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg"
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        Layout.fillWidth: false
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 10
                    }
                }
            }

            // ==================== 2. Add people or groups ====================
            AppSectionCard {
                Layout.fillWidth: true
                implicitHeight: addPeopleLayout.implicitHeight + 28

                ColumnLayout {
                    id: addPeopleLayout
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 0

                    RowLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        Rectangle {
                            radius: 6
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            RowLayout {
                                anchors.fill: parent
                                spacing: 8
                                Image {
                                    source: "qrc:/qt/qml/zametki/assets/icons/share/people.svg"
                                    Layout.leftMargin: 12
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
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
                implicitHeight: peopleColumn.implicitHeight + 28

                ColumnLayout {
                    id: peopleColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 16

                    AppSidebarLabelText {
                        text: "People with access"
                    }

                    // ── Первая строка (Alex) ──
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        AppInitialsAvatar {
                            initials: "AK"
                            avatarSize: 36
                            initialsPixelSize: 12
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
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
                        spacing: 12

                        AppInitialsAvatar {
                            initials: "AK"
                            avatarSize: 36
                            initialsPixelSize: 12
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
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
                implicitHeight: generalColumn.implicitHeight + 28

                ColumnLayout {
                    id: generalColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    AppSidebarLabelText {
                        text: "General access"
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/share/link.svg"
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            spacing: 2
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

            // ==================== 5. Нижние кнопки ====================
            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                // Copy link
                Rectangle {
                    color: Palette.surfaceColor
                    radius: 6
                    implicitWidth: copyRow.implicitWidth + 32
                    implicitHeight: copyRow.implicitHeight + 16
                    TapHandler {
                        onTapped: copyClicked()
                    }

                    RowLayout {
                        id: copyRow
                        anchors.centerIn: parent
                        spacing: 8
                        Image {
                            source: "qrc:/qt/qml/zametki/assets/icons/share/copy.svg"
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
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
                    onClicked: cancelClicked()
                }

                // Done
                AppActionButton {
                    text: "Done"
                    textColor: Palette.backgroundWhite
                    backgroundColor: Palette.accentPrimary
                    onClicked: doneClicked()
                }
            }
        }
    }
}
