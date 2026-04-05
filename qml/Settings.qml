import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Dialogs 6.8
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette
import "components/settings"

Item {
    id: root
    anchors.fill: parent
    signal closeRequested

    readonly property string uiFontFamily: Palette.fontFamily
    readonly property color colorBackground: Palette.backgroundLight
    readonly property color colorSidebarActive: Palette.accentSidebar
    readonly property color colorTextPrimary: Palette.textPrimary
    readonly property color colorTextSecondary: Palette.textSecondary
    readonly property color colorDivider: Palette.border
    readonly property color colorPrimary: Palette.accentPrimary
    readonly property color colorWhite: Palette.backgroundWhite
    readonly property color colorSurface: Palette.surfaceColor
    readonly property color colorBorderSoft: Palette.borderSoft

    function dataDirectoryUrl() {
        if (!AppState.saveDirectory || AppState.saveDirectory.length === 0) {
            return "";
        }

        return "file://" + encodeURI(AppState.saveDirectory);
    }

    Rectangle {
        color: root.colorBackground
        anchors.fill: parent

        Item {
            id: row
            anchors.fill: parent

            ColumnLayout {
                id: sidebar
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 16
                anchors.topMargin: 24
                anchors.bottomMargin: 24
                spacing: 20

                SettingsPageTitleText {
                    text: "Настройки"
                    uiFontFamily: root.uiFontFamily
                    textColor: root.colorTextPrimary
                }

                ColumnLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                    Repeater {
                        model: [
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/account.svg",
                                titleText: "Общие",
                                active: true
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/application.svg",
                                titleText: "Редактор",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/list/note.svg",
                                titleText: "Заметки",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/search.svg",
                                titleText: "Поиск",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/graph.svg",
                                titleText: "Граф",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/tasks.svg",
                                titleText: "Задачи",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/security.svg",
                                titleText: "Безопасность",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/hot-keys.svg",
                                titleText: "Горячие клавиши",
                                active: false
                            },
                            {
                                iconSource: "qrc:/qt/qml/zametki/assets/icons/settings/about.svg",
                                titleText: "О программе",
                                active: false
                            }
                        ]

                        delegate: SettingsNavItem {
                            required property var modelData

                            iconSource: modelData.iconSource
                            titleText: modelData.titleText
                            active: modelData.active
                            uiFontFamily: root.uiFontFamily
                            activeBackgroundColor: root.colorSidebarActive
                            activeTextColor: root.colorPrimary
                            textColor: root.colorTextSecondary
                        }
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
                            SettingsSectionTitleText {
                                color: root.colorTextPrimary
                                text: "Общие настройки"
                            }

                            SettingsDescriptionText {
                                color: root.colorTextSecondary
                                text: "Настройте внешний вид, поведение редактора и локальное хранение данных"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        SettingsActionButton {
                            text: "Done"
                            textColor: root.colorTextPrimary
                            backgroundColor: root.colorSurface
                            fontStyleName: "Medium"
                            fontPointSize: 14
                            fontFamily: root.uiFontFamily
                            horizontalPadding: 10
                            verticalPadding: 10
                            clickable: true
                            onClicked: root.closeRequested()
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

                            SettingsSectionCard {
                                Layout.preferredHeight: columnLayout5.implicitHeight
                                Layout.preferredWidth: columnLayout5.implicitWidth

                                ColumnLayout {
                                    id: columnLayout5
                                    anchors.fill: parent
                                    anchors.topMargin: 0
                                    anchors.bottomMargin: 0
                                    SettingsControlRow {
                                        id: applicationLayout2
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16

                                        Layout.leftMargin: 18
                                        ColumnLayout {
                                            id: columnLayout6

                                            Text {
                                                text: "Общие"
                                            }

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Базовые параметры интерфейса и запуска приложения"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Выберите оформление приложения"
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

                                    SettingsDivider {}

                                    SettingsControlRow {
                                        id: editorLayout2

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout8

                                            Text {
                                                text: "Открывать последнюю сессию"
                                            }

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Восстанавливать открытые заметки после запуска"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppSwitch {
                                            id: mySwitch
                                        }

                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: aboutSettings1

                            SettingsSectionCard {
                                Layout.preferredHeight: columnLayout9.implicitHeight
                                Layout.preferredWidth: columnLayout9.implicitWidth

                                ColumnLayout {
                                    id: columnLayout9
                                    anchors.fill: parent

                                    SettingsControlRow {
                                        id: applicationLayout4

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout10

                                            Text {
                                                text: "Редактор"
                                            }

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Параметры редактирования Markdown и автосохранения"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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
                                        AppSwitch {
                                            id: previewSwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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
                                        AppSwitch {
                                            id: autoSaveSwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                        SettingsInputField {
                                            id: timeText
                                            text: "20"
                                            fieldTextColor: root.colorTextPrimary
                                            fieldBackgroundColor: root.colorWhite
                                            fieldBorderColor: root.colorDivider
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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
                                        AppSwitch {
                                            id: bracketSwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: aboutSettings2
                            SettingsSectionCard {
                                Layout.preferredHeight: columnLayout15.implicitHeight
                                Layout.preferredWidth: columnLayout15.implicitWidth

                                ColumnLayout {
                                    id: columnLayout15
                                    anchors.fill: parent
                                    SettingsControlRow {
                                        id: applicationLayout9

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout16

                                            Text {
                                                text: "Заметки"
                                            }

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Папка хранения и резервные копии"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Локальное хранилище Markdown-файлов"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        SettingsInputField {
                                            id: pathText
                                            text: AppState.saveDirectory && AppState.saveDirectory.length > 0 ? AppState.saveDirectory : "Папка не выбрана"
                                            fieldTextColor: root.colorTextPrimary
                                            fieldBackgroundColor: root.colorWhite
                                            fieldBorderColor: root.colorDivider
                                            horizontalAlignment: Text.AlignLeft
                                            Layout.preferredWidth: 220
                                            readOnly: true
                                            selectByMouse: true
                                        }

                                        SettingsActionButton {
                                            text: "Выбрать"
                                            textColor: root.colorTextPrimary
                                            backgroundColor: root.colorSurface
                                            fontFamily: root.uiFontFamily
                                            clickable: true
                                            onClicked: notesFolderDialog.open()
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    SettingsDivider {}

                                    SettingsControlRow {
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
                                        AppSwitch {
                                            id: autoBackUpSwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}
                                    SettingsControlRow {
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

                                        SettingsInputField {
                                            id: backupCount
                                            text: "20"
                                            fieldTextColor: root.colorTextPrimary
                                            fieldBackgroundColor: root.colorWhite
                                            fieldBorderColor: root.colorDivider
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: aboutSettings3
                            SettingsSectionCard {
                                Layout.preferredHeight: columnLayout20.implicitHeight
                                Layout.preferredWidth: columnLayout20.implicitWidth

                                ColumnLayout {
                                    id: columnLayout20
                                    anchors.fill: parent
                                    SettingsControlRow {
                                        id: applicationLayout13

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout21

                                            Text {
                                                text: "Поиск"
                                            }

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Поведение полнотекстового и интеллектуального поиска"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                        AppSwitch {
                                            id: searchByContentSwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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
                                        AppSwitch {
                                            id: fuzzySwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Обновите индекс после массового импорта заметок"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        SettingsActionButton {
                                            text: "Переиндексировать"
                                            textColor: root.colorTextPrimary
                                            backgroundColor: root.colorSurface
                                            fontFamily: root.uiFontFamily
                                            clickable: true
                                            onClicked: {
                                                AppState.refreshNoteTitles();
                                                AppState.refreshFolderTitles();
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
                            SettingsSectionCard {
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

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Настройки визуализации связей между заметками"
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

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

                                        SettingsInputField {
                                            id: graphDepthField
                                            text: "2"
                                            fieldTextColor: root.colorTextPrimary
                                            fieldBackgroundColor: root.colorWhite
                                            fieldBorderColor: root.colorDivider
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

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

                                        AppSwitch {
                                            id: showCurrentNoteOnlySwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            id: securitySettings
                            SettingsSectionCard {
                                Layout.preferredHeight: secutiryLayout.implicitHeight
                                Layout.preferredWidth: secutiryLayout.implicitWidth

                                ColumnLayout {
                                    id: secutiryLayout
                                    anchors.fill: parent
                                    SettingsControlRow {
                                        id: securityFirstLayout

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: securityInfo

                                            Text {
                                                text: "Безопасность"
                                            }

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Защита локального хранилища и доступа к приложению"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                        AppSwitch {
                                            id: passwordOnAppSwitch
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsControlRow {
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

                                        AppSwitch {
                                            id: autoLockSwitch
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
                            SettingsSectionCard {
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

                                            SettingsDescriptionText {
                                                color: root.colorTextSecondary
                                                text: "Информация о текущей версии приложения"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    SettingsDivider {}

                                    SettingsKeyValueRow {
                                        keyText: "Версия:"
                                        valueText: "0.0.1"
                                        uiFontFamily: root.uiFontFamily
                                        keyColor: root.colorTextPrimary
                                        valueColor: root.colorTextSecondary
                                    }

                                    SettingsKeyValueRow {
                                        keyText: "Автор: "
                                        valueText: "Ренат"
                                        uiFontFamily: root.uiFontFamily
                                        keyColor: root.colorTextPrimary
                                        valueColor: root.colorTextSecondary
                                    }

                                    SettingsKeyValueRow {
                                        keyText: "Хранилище: "
                                        valueText: "Local"
                                        uiFontFamily: root.uiFontFamily
                                        keyColor: root.colorTextPrimary
                                        valueColor: root.colorTextSecondary
                                    }

                                    SettingsActionButton {
                                        text: "Открыть папку данных"
                                        textColor: root.colorTextPrimary
                                        backgroundColor: root.colorSurface
                                        fontFamily: root.uiFontFamily
                                        Layout.leftMargin: 12
                                        Layout.bottomMargin: 12
                                        clickable: AppState.saveDirectory && AppState.saveDirectory.length > 0
                                        onClicked: {
                                            if (!Qt.openUrlExternally(root.dataDirectoryUrl())) {
                                                console.warn("Не удалось открыть папку данных:", AppState.saveDirectory);
                                            }
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

        FolderDialog {
            id: notesFolderDialog
            title: "Выберите папку для заметок"
            onAccepted: {
                AppState.saveDirectory = String(selectedFolder);
            }
        }
    }
}
