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
                                source: "../zametki/assets/icons/list/note.svg"
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

                    RowLayout {
                        Image {
                            source: "../assets/icons/settings/log-out.svg"
                            Layout.preferredWidth: 18
                            Layout.preferredHeight: 18
                        }
                        Text {
                            text: "Log out"
                        }
                    }
                }
            }

            ColumnLayout {
                id: mainContent
                anchors.left: sidebar.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0

                RowLayout {

                    ColumnLayout {
                        id: columnLayout4
                        x: 0
                        y: 6
                        Layout.rightMargin: 24
                        Layout.leftMargin: 24
                        Layout.bottomMargin: 0
                        Layout.topMargin: 0
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
                    width: 363
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
                                        x: 29
                                        y: 4
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
                                        x: 29
                                        y: 4
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

                                    Text {
                                        text: "Dark"
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
                                        x: 29
                                        y: 4
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

                                    Image {
                                        Layout.preferredWidth: 16
                                        Layout.preferredHeight: 16
                                    }
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        id: aboutSettings1
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: columnLayout9.implicitHeight
                            Layout.preferredWidth: columnLayout9.implicitWidth

                            ColumnLayout {
                                id: columnLayout9
                                anchors.fill: parent
                                RowLayout {
                                    id: applicationLayout4
                                    ColumnLayout {
                                        id: columnLayout10
                                        x: 29
                                        y: 4
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

                                RowLayout {
                                    id: applicationLayout5
                                    ColumnLayout {
                                        id: columnLayout11
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Live Preview"
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

                                RowLayout {
                                    id: applicationLayout6
                                    ColumnLayout {
                                        id: columnLayout12
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Автосохранение"
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

                                RowLayout {
                                    id: applicationLayout7
                                    ColumnLayout {
                                        id: columnLayout13
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Интервал автосохранения (сек)"
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }
                                    Rectangle {
                                        Layout.preferredHeight: timeText.implicitHeight
                                        Layout.preferredWidth: timeText.implicitWidth
                                        Text {
                                            id: timeText
                                            text: "20"
                                            topPadding: 10
                                        }
                                    }

                                    Layout.fillWidth: true
                                    Layout.fillHeight: false
                                }

                                RowLayout {
                                    id: applicationLayout8
                                    ColumnLayout {
                                        id: columnLayout14
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Автосохранение"
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
                            }
                        }
                    }

                    ColumnLayout {
                        id: aboutSettings2
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: columnLayout15.implicitHeight
                            Layout.preferredWidth: columnLayout15.implicitWidth

                            ColumnLayout {
                                id: columnLayout15
                                anchors.fill: parent
                                RowLayout {
                                    id: applicationLayout9
                                    ColumnLayout {
                                        id: columnLayout16
                                        x: 29
                                        y: 4
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

                                RowLayout {
                                    id: applicationLayout10
                                    ColumnLayout {
                                        id: columnLayout17
                                        x: 29
                                        y: 4
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

                                    Rectangle {
                                        Layout.preferredHeight: pathText.implicitHeight
                                        Layout.preferredWidth: pathText.implicitWidth
                                        Text {
                                            id: pathText
                                            text: "tut"
                                        }
                                    }

                                    Rectangle {
                                        Layout.preferredHeight: choseText.implicitHeight
                                        Layout.preferredWidth: choseText.implicitWidth
                                        Text {
                                            id: choseText
                                            text: "Выбрать"
                                        }
                                    }
                                    Layout.fillWidth: true
                                    Layout.fillHeight: false
                                }

                                RowLayout {
                                    id: applicationLayout11
                                    ColumnLayout {
                                        id: columnLayout18
                                        x: 29
                                        y: 4
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

                                RowLayout {
                                    id: applicationLayout12
                                    ColumnLayout {
                                        id: columnLayout19
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Количество копий"
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Rectangle {
                                        Layout.preferredHeight: backupCount.implicitHeight
                                        Layout.preferredWidth: backupCount.implicitWidth

                                        Text {
                                            id: backupCount
                                            text: "20"
                                            topPadding: 10
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
                            Layout.preferredHeight: columnLayout20.implicitHeight
                            Layout.preferredWidth: columnLayout20.implicitWidth
                            ColumnLayout {
                                id: columnLayout20
                                anchors.fill: parent
                                RowLayout {
                                    id: applicationLayout13
                                    ColumnLayout {
                                        id: columnLayout21
                                        x: 29
                                        y: 4
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

                                RowLayout {
                                    id: applicationLayout15
                                    ColumnLayout {
                                        id: columnLayout23
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Поиск по содержимому"
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

                                RowLayout {
                                    id: applicationLayout16
                                    ColumnLayout {
                                        id: columnLayout24
                                        x: 29
                                        y: 4
                                        Text {
                                            text: "Fuzzy search"
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

                                RowLayout {
                                    id: applicationLayout14
                                    ColumnLayout {
                                        id: columnLayout22
                                        x: 29
                                        y: 4
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
                                        Layout.preferredHeight: reindexText.implicitHeight
                                        Layout.preferredWidth: reindexText.implicitWidth
                                        Text {
                                            id: reindexText
                                            text: "Перединдексировать"
                                        }
                                    }
                                    Layout.fillWidth: true
                                    Layout.fillHeight: false
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
