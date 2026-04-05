import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components/settings"

Item {
    id: item1
    anchors.fill: parent
    clip: false

    // ===== COLORS =====
    property color colorBackground: "#ffffff"
    property color colorSurface: "#f1f5f9"
    property color colorTextPrimary: "#0f1724"
    property color colorAccent: "#0b74de"

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
        color: colorBackground
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

                    SettingsSidebarLabelText {
                        text: "Share"
                    }
                    SettingsPageTitleText {
                        text: "Share “”"
                    }
                    SettingsDescriptionText {
                        text: "Invite people, manage access, and copy a link to this note."
                        wrapMode: Text.WordWrap
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                Rectangle {
                    color: colorSurface
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
            SettingsSectionCard {
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
                                SettingsSidebarLabelText {
                                    text: "Add people or groups"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignTop
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        SettingsActionButton {
                            text: "Send"
                            textColor: colorTextPrimary
                            backgroundColor: colorBackground
                            onClicked: sendClicked()
                        }
                    }
                }
            }

            // ==================== 3. People with access ====================
            SettingsSectionCard {
                Layout.fillWidth: true
                implicitHeight: peopleColumn.implicitHeight + 28

                ColumnLayout {
                    id: peopleColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 16

                    SettingsSidebarLabelText {
                        text: "People with access"
                    }

                    // ── Первая строка (Alex) ──
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        Rectangle {
                            radius: 100
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                            Text {
                                text: "AK"
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Bold"
                                font.family: "Inter"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            SettingsBodyPrimaryText {
                                text: "Alex Kim"
                            }
                            SettingsDescriptionText {
                                text: "alex@vault.app"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        SettingsDropdown {
                            model: roleOptions
                            currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["alex1"] || "Viewer"))

                            onActivated: changeRole("alex1", currentText)
                        }
                    }

                    // ── Вторая строка (Alex) ──
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Rectangle {
                            radius: 100
                            Text {
                                text: "AK"
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.styleName: "Bold"
                                font.family: "Inter"
                            }
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            SettingsBodyPrimaryText {
                                text: "Alex Kim"
                            }
                            SettingsDescriptionText {
                                text: "alex@vault.app"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        SettingsDropdown {
                            model: roleOptions
                            currentIndex: Math.max(0, roleOptions.indexOf(peopleRoles["alex2"] || "Viewer"))

                            onActivated: changeRole("alex2", currentText)
                        }
                    }
                }
            }

            // ==================== 4. General access ====================
            SettingsSectionCard {
                Layout.fillWidth: true
                implicitHeight: generalColumn.implicitHeight + 28

                ColumnLayout {
                    id: generalColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    SettingsSidebarLabelText {
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

                            SettingsBodyPrimaryText {
                                text: "Restricted"
                            }
                            SettingsDescriptionText {
                                text: "Only people added above can open this note."
                                wrapMode: Text.WordWrap
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        SettingsDropdown {
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
                    color: colorSurface
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
                        SettingsSidebarLabelText {
                            text: "Copy link"
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                // Cancel
                SettingsActionButton {
                    text: "Cancel"
                    textColor: colorTextPrimary
                    backgroundColor: colorSurface
                    onClicked: cancelClicked()
                }

                // Done
                SettingsActionButton {
                    text: "Done"
                    textColor: colorBackground
                    backgroundColor: colorAccent
                    onClicked: doneClicked()
                }
            }
        }
    }
}
