import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    width: 1920
    height: 1080
    visible: true
    Rectangle {
        color: "#fafbfc"
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
                    font.family: "Inter"
                }

                ColumnLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Rectangle {
                        color: "#e6f0ff"
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
                                color: "#0b74de"
                                text: "Общие"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                    }
                    Rectangle {
                        color: "#00ffffff"
                        Layout.fillWidth: true
                        implicitHeight: aplicationLayout.implicitHeight + 24
                        implicitWidth: aplicationLayout.implicitWidth + 24

                        RowLayout {
                            id: aplicationLayout
                            anchors.fill: parent
                            anchors.margins: 12 // ← вот это и есть padding

                            spacing: 12

                            Image {
                                source: "../assets/icons/settings/application.svg"
                                Layout.preferredHeight: 18
                                Layout.preferredWidth: 18
                            }

                            Text {
                                color: "#667085"
                                text: "Редактор"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                    }
                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "Заметки"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                    }
                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "Поиск"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                    }
                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "Граф"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "Задачи"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "Безопасность"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "Горячие клавиши"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
                            }
                        }
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        color: "#00ffffff"
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
                                color: "#667085"
                                text: "О программе"
                                horizontalAlignment: Text.AlignLeft
                                font.styleName: "Medium"
                                font.pointSize: 14
                                font.family: "Inter"
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

                        ColumnLayout {
                            id: columnLayout4
                            Layout.rightMargin: 24
                            Layout.leftMargin: 24
                            Layout.bottomMargin: 0
                            Layout.topMargin: 24
                            Text {
                                color: "#0f1724"
                                text: "Общие настройки"
                                font.styleName: "SemiBold"
                                font.pointSize: 16
                                font.family: "Inter"
                            }

                            Text {
                                color: "#667085"
                                text: "Настройте внешний вид, поведение редактора и локальное хранение данных"
                                font.styleName: "Regular"
                                font.pointSize: 13
                                font.family: "Inter"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Image {
                            Layout.preferredHeight: 32
                            Layout.preferredWidth: 32
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
                                border.color: "#14000000"
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
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        ColumnLayout {
                                            id: columnLayout6

                                            Text {
                                                text: "Общие"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Базовые параметры интерфейса и запуска приложения"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout3
                                        Layout.leftMargin: 18
                                        Layout.rightMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout7

                                            Text {
                                                text: "Appearance"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Выберите оформление приложения"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        ComboBox {
                                            // Цвет текста выбранного элемента
                                            contentItem: Text {
                                                text: parent.displayText  // или model[parent.currentIndex] если нужно
                                                color: "black"
                                                // можно также настроить выравнивание, шрифт и т.д.
                                            }

                                            // Цвет текста элементов в выпадающем списке
                                            delegate: ItemDelegate {
                                                contentItem: Text {
                                                    text: modelData
                                                    color: "white"
                                                }
                                            }

                                            model: ["White", "Dark", "Purple"]
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: editorLayout2
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout8

                                            Text {
                                                text: "Открывать последнюю сессию"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Восстанавливать открытые заметки после запуска"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
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

                                                color: mySwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: mySwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: mySwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: mySwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
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
                                border.color: "#14000000"
                                Layout.fillWidth: true
                                Layout.preferredHeight: columnLayout9.implicitHeight
                                Layout.preferredWidth: columnLayout9.implicitWidth

                                ColumnLayout {
                                    id: columnLayout9
                                    anchors.fill: parent

                                    RowLayout {
                                        id: applicationLayout4
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout10

                                            Text {
                                                text: "Редактор"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Параметры редактирования Markdown и автосохранения"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout5
                                        Layout.rightMargin: 18
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

                                                color: previewSwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: previewSwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: previewSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: previewSwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout8
                                        Layout.rightMargin: 18
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

                                                color: autoSaveSwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: autoSaveSwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: autoSaveSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: autoSaveSwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout7
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout13

                                            Text {
                                                text: "Интервал автосохранения (сек)"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Rectangle {
                                            radius: 6
                                            border.color: "#14000000"
                                            Layout.preferredHeight: timeText.implicitHeight + 24
                                            Layout.preferredWidth: timeText.implicitWidth + 24

                                            Text {
                                                id: timeText
                                                text: "20"
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout6
                                        Layout.rightMargin: 18
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

                                                color: bracketSwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: bracketSwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: bracketSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: bracketSwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
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
                                border.color: "#14000000"
                                Layout.fillWidth: true
                                Layout.preferredHeight: columnLayout15.implicitHeight
                                Layout.preferredWidth: columnLayout15.implicitWidth

                                ColumnLayout {
                                    id: columnLayout15
                                    anchors.fill: parent
                                    RowLayout {
                                        id: applicationLayout9
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout16

                                            Text {
                                                text: "Заметки"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Папка хранения и резервные копии"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout10
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
                                        ColumnLayout {
                                            id: columnLayout17

                                            Text {
                                                text: "Папка заметок"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Локальное хранилище Markdown-файлов"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Rectangle {
                                            radius: 6
                                            border.color: "#14000000"
                                            Layout.preferredHeight: pathText.implicitHeight + 24
                                            Layout.preferredWidth: pathText.implicitWidth + 24
                                            Text {
                                                id: pathText
                                                text: "tut"
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }

                                        Rectangle {
                                            color: "#f1f5f9"
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
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout11
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
                                        ColumnLayout {
                                            id: columnLayout18

                                            Text {
                                                text: "Включить автобэкап"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Image {
                                            Layout.preferredWidth: 16
                                            Layout.preferredHeight: 16
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }
                                    RowLayout {
                                        id: applicationLayout12
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
                                        ColumnLayout {
                                            id: columnLayout19
                                            Text {
                                                text: "Количество копий"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Rectangle {
                                            Layout.preferredHeight: timeText.implicitHeight + 24
                                            Layout.preferredWidth: timeText.implicitWidth + 24
                                            border.color: "#14000000"
                                            radius: 6
                                            Text {
                                                id: backupCount
                                                text: "20"
                                                anchors.fill: parent
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
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
                                border.color: "#14000000"
                                Layout.preferredHeight: columnLayout20.implicitHeight
                                Layout.preferredWidth: columnLayout20.implicitWidth

                                ColumnLayout {
                                    id: columnLayout20
                                    anchors.fill: parent
                                    RowLayout {
                                        id: applicationLayout13
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
                                        ColumnLayout {
                                            id: columnLayout21

                                            Text {
                                                text: "Поиск"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Поведение полнотекстового и интеллектуального поиска"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout15
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
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
                                            id: searchByСontentSwitch

                                            indicator: Rectangle {
                                                width: 45
                                                height: 25
                                                radius: height / 2

                                                color: searchByСontentSwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: searchByСontentSwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: searchByСontentSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: searchByСontentSwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        radius: 6
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout16
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
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

                                                color: fuzzySwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: fuzzySwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: fuzzySwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: fuzzySwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: applicationLayout14
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
                                        ColumnLayout {
                                            id: columnLayout22

                                            Text {
                                                text: "Индекс поиска"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Обновите индекс после массового импорта заметок"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        Rectangle {
                                            color: "#f1f5f9"
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
                            id: securitySettings
                            Rectangle {
                                radius: 8
                                border.color: "#14000000"
                                Layout.preferredHeight: secutiryLayout.implicitHeight
                                Layout.preferredWidth: secutiryLayout.implicitWidth

                                ColumnLayout {
                                    id: secutiryLayout
                                    anchors.fill: parent
                                    RowLayout {
                                        id: securityFirstLayout
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
                                        ColumnLayout {
                                            id: securityInfo

                                            Text {
                                                text: "Безопасность"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Защита локального хранилища и доступа к приложению"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: passwordOnApp
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
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

                                                color: passwordOnAppSwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: passwordOnAppSwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: passwordOnAppSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: passwordOnAppSwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
                                                }
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        radius: 6
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        id: autoLock
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.margins: 16
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

                                                color: autoLockSwitch.checked ? "#0B74DE" : "#ffffff"
                                                border.color: autoLockSwitch.checked ? "#ffffff" : Qt.rgba(0, 0, 0, 0.08)

                                                Rectangle {
                                                    width: parent.height - 6
                                                    height: width
                                                    radius: width / 2

                                                    x: autoLockSwitch.checked ? parent.width - width - 3 : 3

                                                    y: (parent.height - height) / 2

                                                    color: autoLockSwitch.checked ? "#FFFFFF" : Qt.rgba(0, 0, 0, 0.08)
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
                                border.color: "#14000000"
                                Layout.preferredHeight: aboutColumnLayout.implicitHeight
                                Layout.preferredWidth: aboutColumnLayout.implicitWidth

                                ColumnLayout {
                                    id: aboutColumnLayout
                                    anchors.fill: parent
                                    spacing: 10
                                    RowLayout {
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        ColumnLayout {

                                            Text {
                                                text: "О программе"
                                            }

                                            Text {
                                                color: "#667085"
                                                text: "Информация о текущей версии приложения"
                                                font.styleName: "Regular"
                                                font.family: "Inter"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {
                                        border.color: "#14000000"
                                        Layout.preferredHeight: 1
                                        Layout.fillWidth: true
                                    }

                                    RowLayout {
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Text {
                                            text: "Версия:"
                                        }

                                        Text {
                                            text: "0.0.1"
                                            color: "#667085"
                                            font.styleName: "Regular"
                                            font.family: "Inter"
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    RowLayout {
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Text {
                                            text: "Автор: "
                                        }

                                        Text {
                                            text: "Ренат"
                                            color: "#667085"
                                            font.styleName: "Regular"
                                            font.family: "Inter"
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    RowLayout {
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Text {
                                            text: "Хранилище: "
                                        }

                                        Text {
                                            text: "Local"
                                            color: "#667085"
                                            font.styleName: "Regular"
                                            font.family: "Inter"
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    Rectangle {

                                        radius: 6
                                        color: "#f1f5f9"
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
