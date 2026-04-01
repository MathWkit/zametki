import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: item1
    width: 1920
    height: 1080
    clip: true

    // ===== COLORS =====
    property color colorBackground: "#ffffff"
    property color colorSurface: "#f1f5f9"
    property color colorTextPrimary: "#0f1724"
    property color colorTextSecondary: "#667085"
    property color colorAccent: "#0b74de"

    signal sendClicked
    signal cancelClicked
    signal doneClicked
    signal copyClicked
    signal closeClicked

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

                    Text {
                        text: "Share"
                        color: colorTextSecondary
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                    }
                    Text {
                        text: "Share “”"
                        color: colorTextPrimary
                        font.pointSize: 18
                        font.family: "Inter"
                        font.styleName: "Bold"
                    }
                    Text {
                        text: "Invite people, manage access, and copy a link to this note."
                        color: colorTextSecondary
                        font.family: "Inter"
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
                        source: "../assets/icons/share/close-btn.svg"
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        Layout.fillWidth: false // ← замени на свою иконку
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 10
                    }
                }
            }

            // ==================== 2. Add people or groups ====================
            Rectangle {
                color: colorSurface
                radius: 8
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
                                    source: "../assets/icons/share/people.svg"
                                    Layout.leftMargin: 12
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                }
                                Text {
                                    text: "Add people or groups"
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignTop
                                    Layout.fillWidth: true
                                    color: colorTextSecondary
                                    font.family: "Inter"
                                }
                            }
                        }

                        Rectangle {
                            radius: 6
                            color: colorBackground
                            implicitWidth: sendText.implicitWidth + 24
                            implicitHeight: 36
                            TapHandler {
                                onTapped: sendClicked()
                            }

                            Text {
                                id: sendText
                                anchors.centerIn: parent
                                text: "Send"
                                font.family: "Inter"
                                font.styleName: "SemiBold"
                            }
                        }
                    }
                }
            }

            // ==================== 3. People with access ====================
            Rectangle {
                color: colorSurface
                radius: 8
                Layout.fillWidth: true
                implicitHeight: peopleColumn.implicitHeight + 28

                ColumnLayout {
                    id: peopleColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 16

                    Text {
                        text: "People with access"
                        color: colorTextSecondary
                        font.family: "Inter"
                        font.styleName: "SemiBold"
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
                            Text {
                                text: "Alex Kim"
                                font.family: "Inter"
                            }
                            Text {
                                text: "alex@vault.app"
                                color: colorTextSecondary
                                font.family: "Inter"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            color: colorBackground
                            radius: 6
                            implicitWidth: ownerRow1.implicitWidth + 24
                            implicitHeight: 32

                            RowLayout {
                                id: ownerRow1
                                anchors.centerIn: parent
                                spacing: 6
                                Text {
                                    text: "Owner"
                                    font.family: "Inter"
                                    font.styleName: "SemiBold"
                                }
                                Image {
                                    source: "../assets/icons/unused/open-bracket.svg"
                                    Layout.preferredWidth: 12
                                    Layout.preferredHeight: 12
                                }
                            }
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
                            Text {
                                text: "Alex Kim"
                                font.family: "Inter"
                            }
                            Text {
                                text: "alex@vault.app"
                                color: colorTextSecondary
                                font.family: "Inter"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            color: colorBackground
                            radius: 6
                            implicitWidth: ownerRow2.implicitWidth + 24
                            implicitHeight: 32

                            RowLayout {
                                id: ownerRow2
                                anchors.centerIn: parent
                                spacing: 6
                                Text {
                                    text: "Owner"
                                    font.family: "Inter"
                                    font.styleName: "SemiBold"
                                }
                                Image {
                                    source: "../assets/icons/unused/open-bracket.svg"
                                    Layout.preferredWidth: 12
                                    Layout.preferredHeight: 12
                                }
                            }
                        }
                    }
                }
            }

            // ==================== 4. General access ====================
            Rectangle {
                color: colorSurface
                radius: 8
                Layout.fillWidth: true
                implicitHeight: generalColumn.implicitHeight + 28

                ColumnLayout {
                    id: generalColumn
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    Text {
                        text: "General access"
                        color: colorTextSecondary
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Image {
                            source: "../assets/icons/share/link.svg"
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            spacing: 2
                            Layout.fillWidth: true

                            Text {
                                text: "Restricted"
                                font.family: "Inter"
                            }
                            Text {
                                color: colorTextSecondary
                                text: "Only people added above can open this note."
                                font.family: "Inter"
                                wrapMode: Text.WordWrap
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            color: colorBackground
                            radius: 6
                            implicitWidth: viewerRow.implicitWidth + 24
                            implicitHeight: 32

                            RowLayout {
                                id: viewerRow
                                anchors.centerIn: parent
                                spacing: 6
                                Text {
                                    text: "Viewer"
                                    font.family: "Inter"
                                    font.styleName: "SemiBold"
                                }
                                Image {
                                    source: "../assets/icons/unused/open-bracket.svg"
                                    Layout.preferredWidth: 12
                                    Layout.preferredHeight: 12
                                }
                            }
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
                            source: "../assets/icons/share/copy.svg"
                            Layout.preferredWidth: 14
                            Layout.preferredHeight: 14
                        }
                        Text {
                            text: "Copy link"
                            font.family: "Inter"
                            font.styleName: "SemiBold"
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                // Cancel
                Rectangle {
                    color: colorSurface
                    radius: 6
                    implicitWidth: cancelText.implicitWidth + 32
                    implicitHeight: cancelText.implicitHeight + 16

                    TapHandler {
                        onTapped: cancelClicked()
                    }
                    Text {
                        id: cancelText
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                    }
                }

                // Done
                Rectangle {
                    color: colorAccent
                    radius: 6
                    implicitWidth: doneText.implicitWidth + 32
                    implicitHeight: doneText.implicitHeight + 16

                    TapHandler {
                        onTapped: doneClicked()
                    }

                    Text {
                        id: doneText
                        anchors.centerIn: parent
                        color: colorBackground
                        text: "Done"
                        font.family: "Inter"
                        font.styleName: "SemiBold"
                    }
                }
            }
        }
    }
}
