import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent

    readonly property string uiFontFamily: "Inter"
    readonly property color colorBackground: "#fafbfc"
    readonly property color colorSidebarActive: "#e6f0ff"
    readonly property color colorTextPrimary: "#0f1724"
    readonly property color colorTextSecondary: "#667085"
    readonly property color colorDivider: "#14000000"
    readonly property color colorPrimary: "#0B74DE"
    readonly property color colorWhite: "#ffffff"
    readonly property color colorSurface: "#f1f5f9"
    readonly property color colorBorderSoft: Qt.rgba(0, 0, 0, 0.08)

    Rectangle {
        color: root.colorBackground
        anchors.fill: parent
        Row {
            id: row
            anchors.fill: parent
            spacing: 0

            ColumnLayout {
                id: sidebar
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 16
                anchors.topMargin: 24
                anchors.bottomMargin: 24
                spacing: 20

                Text {
                    text: "Настройки"
                    font.styleName: "SemiBold"
                    font.pointSize: 18
                    font.family: root.uiFontFamily
                }

                ColumnLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Rectangle {
                        color: root.colorSidebarActive
                        radius: 6
                        Layout.fillWidth: true
                        implicitHeight: accountLayout.implicitHeight + 24
                        implicitWidth: accountLayout.implicitWidth + 24

                        RowLayout {
                            id: accountLayout
                            anchors.fill: parent
                            anchors.margins: 12 // ← вот это и есть padding

                            spacing: 12

                            Image {
                                source: "../assets/icons/settings/account.svg"
                                Layout.preferredHeight: 18
                                Layout.preferredWidth: 18
                            }

                            Text {
                                color: root.colorPrimary
                                text: "Общие"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        implicitHeight: applicationLayout.implicitHeight + 24
                        implicitWidth: applicationLayout.implicitWidth + 24

                        RowLayout {
                            id: applicationLayout
                            anchors.fill: parent
                            anchors.margins: 12 // ← вот это и есть padding

                            spacing: 12

                            Image {
                                source: "../assets/icons/settings/application.svg"
                                Layout.preferredHeight: 18
                                Layout.preferredWidth: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Редактор"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        implicitHeight: dataLayout.implicitHeight + 24
                        implicitWidth: dataLayout.implicitWidth + 24

                        RowLayout {
                            id: dataLayout
                            anchors.fill: parent
                            anchors.margins: 12 // ← вот это и есть padding

                            spacing: 12

                            Image {
                                source: "../assets/icons/list/note.svg"
                                Layout.preferredHeight: 18
                                Layout.preferredWidth: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Заметки"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        implicitHeight: aboutLayout.implicitHeight + 24
                        implicitWidth: aboutLayout.implicitWidth + 24

                        RowLayout {
                            id: aboutLayout
                            anchors.fill: parent
                            anchors.margins: 12 // ← вот это и есть padding

                            spacing: 12

                            Image {
                                source: "../assets/icons/settings/search.svg"
                                Layout.preferredHeight: 18
                                Layout.preferredWidth: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Поиск"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        implicitWidth: aboutLayout1.implicitWidth + 24
                        implicitHeight: aboutLayout1.implicitHeight + 24
                        RowLayout {
                            id: aboutLayout1
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            Image {
                                source: "../assets/icons/settings/graph.svg"
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Граф"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "transparent"
                        implicitWidth: aboutLayout2.implicitWidth + 24
                        implicitHeight: aboutLayout2.implicitHeight + 24
                        RowLayout {
                            id: aboutLayout2
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            Image {
                                source: "../assets/icons/settings/tasks.svg"
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Задачи"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "transparent"
                        implicitWidth: aboutLayout3.implicitWidth + 24
                        implicitHeight: aboutLayout3.implicitHeight + 24
                        RowLayout {
                            id: aboutLayout3
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            Image {
                                source: "../assets/icons/settings/security.svg"
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Безопасность"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "transparent"
                        implicitWidth: aboutLayout4.implicitWidth + 24
                        implicitHeight: aboutLayout4.implicitHeight + 24
                        RowLayout {
                            id: aboutLayout4
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            Image {
                                source: "../assets/icons/settings/hot-keys.svg"
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Горячие клавиши"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "transparent"
                        implicitWidth: aboutLayout5.implicitWidth + 24
                        implicitHeight: aboutLayout5.implicitHeight + 24
                        RowLayout {
                            id: aboutLayout5
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12
                            Image {
                                source: "../assets/icons/settings/about.svg"
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "О программе"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            ScrollView {
                id: mainContentScroll
                anchors.left: sidebar.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                ColumnLayout {
                    id: mainContent
                    width: mainContentScroll.width

                    RowLayout {
                        Layout.rightMargin: 24

                        ColumnLayout {
                            id: columnLayout4
                            Layout.rightMargin: 24
                            Layout.leftMargin: 24
                            Layout.bottomMargin: 0
                            Layout.topMargin: 24
                            Text {
                                color: root.colorTextPrimary
                                text: "Общие настройки"
                                font.styleName: "SemiBold"
                                font.pointSize: 16
                                font.family: root.uiFontFamily
                            }

                            Text {
                                color: root.colorTextSecondary
                                text: "Настройте внешний вид, поведение редактора и локальное хранение данных"
                                font.styleName: "Regular"
                                font.pointSize: 13
                                font.family: root.uiFontFamily
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            color: root.colorSurface
                            radius: 6
                            Layout.preferredHeight: doneText.implicitHeight + 20
                            Layout.preferredWidth: doneText.implicitWidth + 20
                            Text {
                                id: doneText
                                text: "Done"
                                anchors.centerIn: parent
                                color: root.colorTextPrimary
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: root.uiFontFamily
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        spacing: 48
                        Layout.rightMargin: 40
                        Layout.leftMargin: 40
                        Layout.bottomMargin: 20
                        Layout.topMargin: 20
                        Layout.preferredWidth: -1
                        Layout.fillWidth: true
                        ColumnLayout {
                            id: aboutSettings

                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                border.width: 1
                                Layout.fillWidth: true
                                Layout.preferredHeight: columnLayout5.implicitHeight
                                Layout.preferredWidth: columnLayout5.implicitWidth

                                ColumnLayout {
                                    id: columnLayout5
                                    anchors.fill: parent
                                    anchors.topMargin: 0
                                    anchors.bottomMargin: 0
                                    RowLayout {
                                        id: applicationLayout2
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16

                                        Layout.leftMargin: 18
                                        ColumnLayout {
                                            id: columnLayout6

                                            Text {
                                                text: "Общие"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Базовые параметры интерфейса и запуска приложения"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout3
                                        Layout.leftMargin: 18
                                        Layout.rightMargin: 18
                                        Layout.bottomMargin: 6
                                        Layout.topMargin: 6
                                        ColumnLayout {
                                            id: columnLayout7

                                            Text {
                                                text: "Appearance"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Выберите оформление приложения"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        ComboBox {
                                            id: appearanceCombo
                                            topPadding: 12
                                            bottomPadding: 12
                                            Layout.preferredWidth: 160

                                            contentItem: Text {
                                                text: appearanceCombo.displayText
                                                color: root.colorTextPrimary
                                                leftPadding: 12
                                                rightPadding: 28
                                                verticalAlignment: Text.AlignVCenter
                                                font.family: root.uiFontFamily
                                            }

                                            indicator: Text {
                                                text: "▼"
                                                color: root.colorTextSecondary
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.right: parent.right
                                                anchors.rightMargin: 10
                                                font.pixelSize: 10
                                            }

                                            background: Rectangle {
                                                radius: 6
                                                color: root.colorWhite
                                                border.color: root.colorDivider
                                                border.width: 1
                                            }

                                            delegate: ItemDelegate {
                                                id: appearanceDelegate
                                                required property string modelData

                                                width: ListView.view ? ListView.view.width : implicitWidth

                                                background: Rectangle {
                                                    color: appearanceDelegate.hovered ? "#f1f5f9" : "#ffffff"
                                                }

                                                contentItem: Text {
                                                    text: appearanceDelegate.modelData
                                                    color: "#0f1724"
                                                    verticalAlignment: Text.AlignVCenter
                                                    leftPadding: 12
                                                    font.family: "Inter"
                                                }
                                            }

                                            popup: Popup {
                                                y: appearanceCombo.height + 6
                                                width: appearanceCombo.width
                                                padding: 0

                                                contentItem: ListView {
                                                    clip: true
                                                    implicitHeight: contentHeight
                                                    model: appearanceCombo.popup.visible ? appearanceCombo.delegateModel : null
                                                    currentIndex: appearanceCombo.highlightedIndex
                                                }

                                                background: Rectangle {
                                                    radius: 6
                                                    color: root.colorWhite
                                                    border.color: root.colorDivider
                                                    border.width: 1
                                                }
                                            }

                                            model: ["White", "Dark", "Purple"]
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: editorLayout2

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout8

                                            Text {
                                                text: "Открывать последнюю сессию"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Восстанавливать открытые заметки после запуска"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Switch {
                                            id: mySwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: mySwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: mySwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: mySwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: mySwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: aboutSettings1

                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                Layout.fillWidth: true
                                Layout.preferredHeight: columnLayout9.implicitHeight
                                Layout.preferredWidth: columnLayout9.implicitWidth

                                ColumnLayout {
                                    id: columnLayout9
                                    anchors.fill: parent

                                    RowLayout {
                                        id: applicationLayout4

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout10

                                            Text {
                                                text: "Редактор"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Параметры редактирования Markdown и автосохранения"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout5

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout11

                                            Text {
                                                text: "Live Preview"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Switch {
                                            id: previewSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: previewSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: previewSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: previewSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: previewSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout8

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout14

                                            Text {
                                                text: "Автосохранение"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Switch {
                                            id: autoSaveSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: autoSaveSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: autoSaveSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: autoSaveSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: autoSaveSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout7
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 10
                                        Layout.topMargin: 10
                                        ColumnLayout {
                                            id: columnLayout13

                                            Text {
                                                text: "Интервал автосохранения (сек)"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        TextField {
                                            id: timeText
                                            text: "20"
                                            color: root.colorTextPrimary
                                            topPadding: 12
                                            bottomPadding: 12
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80

                                            background: Rectangle {
                                                radius: 6
                                                color: root.colorWhite
                                                border.color: root.colorDivider
                                                border.width: 1
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout6

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout12

                                            Text {
                                                text: "Автозакрытие скобок"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Switch {
                                            id: bracketSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: bracketSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: bracketSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: bracketSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: bracketSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: aboutSettings2
                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                Layout.fillWidth: true
                                Layout.preferredHeight: columnLayout15.implicitHeight
                                Layout.preferredWidth: columnLayout15.implicitWidth

                                ColumnLayout {
                                    id: columnLayout15
                                    anchors.fill: parent
                                    RowLayout {
                                        id: applicationLayout9

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout16

                                            Text {
                                                text: "Заметки"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Папка хранения и резервные копии"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout10
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 10
                                        Layout.bottomMargin: 10
                                        ColumnLayout {
                                            id: columnLayout17

                                            Text {
                                                text: "Папка заметок"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Локальное хранилище Markdown-файлов"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        TextField {
                                            id: pathText
                                            text: "tut"
                                            color: root.colorTextPrimary
                                            topPadding: 12
                                            bottomPadding: 12
                                            horizontalAlignment: Text.AlignLeft
                                            Layout.preferredWidth: 220

                                            background: Rectangle {
                                                radius: 6
                                                color: root.colorWhite
                                                border.color: root.colorDivider
                                                border.width: 1
                                            }
                                        }

                                        Rectangle {
                                            color: root.colorSurface
                                            radius: 6
                                            Layout.preferredHeight: choseText.implicitHeight + 24
                                            Layout.preferredWidth: choseText.implicitWidth + 24
                                            Text {
                                                id: choseText
                                                text: "Выбрать"
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout11

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout18

                                            Text {
                                                text: "Включить автобэкап"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Switch {
                                            id: autoBackUpSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: autoBackUpSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: autoBackUpSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: autoBackUpSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: autoBackUpSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }
                                    RowLayout {
                                        id: applicationLayout12
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 10
                                        Layout.bottomMargin: 10
                                        ColumnLayout {
                                            id: columnLayout19
                                            Text {
                                                text: "Количество копий"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        TextField {
                                            id: backupCount
                                            text: "20"
                                            color: root.colorTextPrimary
                                            topPadding: 12
                                            bottomPadding: 12
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80

                                            background: Rectangle {
                                                radius: 6
                                                color: root.colorWhite
                                                border.color: root.colorDivider
                                                border.width: 1
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: aboutSettings3
                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                Layout.preferredHeight: columnLayout20.implicitHeight
                                Layout.preferredWidth: columnLayout20.implicitWidth

                                ColumnLayout {
                                    id: columnLayout20
                                    anchors.fill: parent
                                    RowLayout {
                                        id: applicationLayout13

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout21

                                            Text {
                                                text: "Поиск"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Поведение полнотекстового и интеллектуального поиска"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout15

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout23

                                            Text {
                                                text: "Поиск по содержимому"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Switch {
                                            id: searchByContentSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: searchByContentSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: searchByContentSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: searchByContentSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: searchByContentSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        radius: 6
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout16

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout24

                                            Text {
                                                text: "Fuzzy search"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }
                                        Switch {
                                            id: fuzzySwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: fuzzySwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: fuzzySwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: fuzzySwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: fuzzySwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout14
                                        Layout.rightMargin: 18

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout22

                                            Text {
                                                text: "Индекс поиска"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Обновите индекс после массового импорта заметок"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Rectangle {
                                            color: root.colorSurface
                                            Layout.preferredHeight: reindexText.implicitHeight + 24
                                            Layout.preferredWidth: reindexText.implicitWidth + 24
                                            radius: 6
                                            Text {
                                                id: reindexText
                                                text: "Переиндексировать"
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }

                                Layout.fillWidth: true
                            }
                        }

                        ColumnLayout {
                            id: graphSettings
                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                Layout.fillWidth: true
                                Layout.preferredHeight: graphLayout.implicitHeight
                                Layout.preferredWidth: graphLayout.implicitWidth

                                ColumnLayout {
                                    id: graphLayout
                                    anchors.fill: parent

                                    RowLayout {
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16

                                        ColumnLayout {
                                            Text {
                                                text: "Граф"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Настройки визуализации связей между заметками"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        Layout.leftMargin: 18
                                        Layout.rightMargin: 18
                                        Layout.topMargin: 10
                                        Layout.bottomMargin: 10

                                        ColumnLayout {
                                            Text {
                                                text: "Глубина связей"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        TextField {
                                            id: graphDepthField
                                            text: "2"
                                            color: root.colorTextPrimary
                                            topPadding: 12
                                            bottomPadding: 12
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80

                                            background: Rectangle {
                                                radius: 6
                                                color: root.colorWhite
                                                border.color: root.colorDivider
                                                border.width: 1
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16

                                        ColumnLayout {
                                            Text {
                                                text: "Показывать только текущую заметку"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Switch {
                                            id: showCurrentNoteOnlySwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: showCurrentNoteOnlySwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: showCurrentNoteOnlySwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: showCurrentNoteOnlySwitch.checked ? parent.width - width - 3 : 3
                                                    y: (parent.height - height) / 2

                                                    color: showCurrentNoteOnlySwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: securitySettings
                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                Layout.preferredHeight: secutiryLayout.implicitHeight
                                Layout.preferredWidth: secutiryLayout.implicitWidth

                                ColumnLayout {
                                    id: secutiryLayout
                                    anchors.fill: parent
                                    RowLayout {
                                        id: securityFirstLayout

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: securityInfo

                                            Text {
                                                text: "Безопасность"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Защита локального хранилища и доступа к приложению"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: passwordOnApp

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: passwordText

                                            Text {
                                                text: "Пароль на приложение"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Switch {
                                            id: passwordOnAppSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: passwordOnAppSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: passwordOnAppSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: passwordOnAppSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: passwordOnAppSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        radius: 6
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: autoLock

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            Text {
                                                text: "Автоблокировка"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Switch {
                                            id: autoLockSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: autoLockSwitch.checked ? root.colorPrimary : root.colorWhite
                                                border.color: autoLockSwitch.checked ? root.colorWhite : root.colorBorderSoft

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: autoLockSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: autoLockSwitch.checked ? root.colorWhite : root.colorBorderSoft
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }

                                Layout.fillWidth: true
                            }
                        }

                        ColumnLayout {
                            id: aboutInfo
                            Rectangle {
                                radius: 8
                                border.color: root.colorDivider
                                Layout.preferredHeight: aboutColumnLayout.implicitHeight
                                Layout.preferredWidth: aboutColumnLayout.implicitWidth

                                ColumnLayout {
                                    id: aboutColumnLayout
                                    anchors.fill: parent
                                    spacing: 10
                                    RowLayout {

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        ColumnLayout {

                                            Text {
                                                text: "О программе"
                                            }

                                            Text {
                                                color: root.colorTextSecondary
                                                text: "Информация о текущей версии приложения"
                                                font.styleName: "Regular"
                                                font.family: root.uiFontFamily
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: root.colorDivider
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {

                                        Layout.leftMargin: 18
                                        Text {
                                            text: "Версия:"
                                        }

                                        Text {
                                            text: "0.0.1"
                                            color: root.colorTextSecondary
                                            font.styleName: "Regular"
                                            font.family: root.uiFontFamily
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    RowLayout {

                                        Layout.leftMargin: 18
                                        Text {
                                            text: "Автор: "
                                        }

                                        Text {
                                            text: "Ренат"
                                            color: root.colorTextSecondary
                                            font.styleName: "Regular"
                                            font.family: root.uiFontFamily
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    RowLayout {

                                        Layout.leftMargin: 18
                                        Text {
                                            text: "Хранилище: "
                                        }

                                        Text {
                                            text: "Local"
                                            color: root.colorTextSecondary
                                            font.styleName: "Regular"
                                            font.family: root.uiFontFamily
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {

                                        radius: 6
                                        color: root.colorSurface
                                        Layout.leftMargin: 12
                                        Layout.bottomMargin: 12
                                        Layout.preferredHeight: openFolderBtn.implicitHeight + 24
                                        Layout.preferredWidth: openFolderBtn.implicitWidth + 24
                                        Text {
                                            id: openFolderBtn
                                            text: "Открыть папку данных"
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                }

                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}
