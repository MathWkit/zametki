import QtQuick 6.8
import QtQuick.Controls 2.15
import QtQuick.Dialogs 6.8
import QtQuick.Layouts 1.15
import "scripts/Theme.js" as Palette
import "components"
import "components/settings"

Item {
    id: root
    anchors.fill: parent
    signal closeRequested

    readonly property color colorBackground: Palette.backgroundLight
    readonly property int contentInset: Palette.contentInset
    readonly property int sectionGap: Palette.sectionSpacing
    readonly property int rowPadding: Palette.rowPadding
    readonly property int rowPaddingCompact: Palette.rowPaddingCompact

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
                anchors.leftMargin: root.contentInset
                anchors.topMargin: Palette.space3
                anchors.bottomMargin: Palette.space3
                spacing: root.sectionGap

                AppPageTitleText {
                    text: "Настройки"
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
                        Layout.rightMargin: Palette.space3

                        ColumnLayout {
                            id: columnLayout4
                            Layout.rightMargin: Palette.space3
                            Layout.leftMargin: Palette.space3
                            Layout.bottomMargin: 0
                            Layout.topMargin: Palette.space3
                            AppSectionTitleText {
                                text: "Общие настройки"
                            }

                            AppDescriptionText {
                                text: "Настройте внешний вид, поведение редактора и локальное хранение данных"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        AppActionButtonCompact {
                            text: "Done"
                            onClicked: root.closeRequested()
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        spacing: root.sectionGap
                        Layout.rightMargin: Palette.space3
                        Layout.leftMargin: Palette.space3
                        Layout.bottomMargin: Palette.space2
                        Layout.topMargin: Palette.space2
                        Layout.preferredWidth: -1
                        Layout.fillWidth: true
                        ColumnLayout {
                            id: aboutSettings

                            AppSectionCard {
                                Layout.preferredHeight: columnLayout5.implicitHeight
                                Layout.preferredWidth: columnLayout5.implicitWidth

                                ColumnLayout {
                                    id: columnLayout5
                                    anchors.fill: parent
                                    anchors.topMargin: 0
                                    anchors.bottomMargin: 0
                                    SettingsControlRow {
                                        id: applicationLayout2
                                        rowLeftMargin: root.contentInset
                                        rowRightMargin: root.contentInset
                                        rowTopMargin: root.rowPadding
                                        rowBottomMargin: root.rowPadding
                                        ColumnLayout {
                                            id: columnLayout6

                                            SettingsRowLabel {
                                                text: "Общие"
                                            }

                                            AppDescriptionText {
                                                text: "Базовые параметры интерфейса и запуска приложения"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout3
                                        compact: true
                                        rowLeftMargin: root.contentInset
                                        rowRightMargin: root.contentInset
                                        rowTopMargin: root.rowPaddingCompact
                                        rowBottomMargin: root.rowPaddingCompact
                                        ColumnLayout {
                                            id: columnLayout7

                                            SettingsRowLabel {
                                                text: "Appearance"
                                            }

                                            AppDescriptionText {
                                                text: "Выберите оформление приложения"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppDropdown {
                                            id: appearanceCombo
                                            Layout.preferredWidth: Palette.space4 * 5

                                            model: ["Light", "Dark", "Purple"]
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: editorLayout2
                                        rowLeftMargin: root.contentInset
                                        rowRightMargin: root.contentInset
                                        rowTopMargin: root.rowPadding
                                        rowBottomMargin: root.rowPadding
                                        ColumnLayout {
                                            id: columnLayout8

                                            SettingsRowLabel {
                                                text: "Открывать последнюю сессию"
                                            }

                                            AppDescriptionText {
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

                            AppSectionCard {
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

                                            SettingsRowLabel {
                                                text: "Редактор"
                                            }

                                            AppDescriptionText {
                                                text: "Параметры редактирования Markdown и автосохранения"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout5

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout11

                                            SettingsRowLabel {
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

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout8

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout14

                                            SettingsRowLabel {
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

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout7
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 10
                                        Layout.topMargin: 10
                                        ColumnLayout {
                                            id: columnLayout13

                                            SettingsRowLabel {
                                                text: "Интервал автосохранения (сек)"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppInputField {
                                            id: timeText
                                            text: "20"
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout6

                                        Layout.leftMargin: 18
                                        Layout.bottomMargin: 16
                                        Layout.topMargin: 16
                                        ColumnLayout {
                                            id: columnLayout12

                                            SettingsRowLabel {
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
                            AppSectionCard {
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

                                            SettingsRowLabel {
                                                text: "Заметки"
                                            }

                                            AppDescriptionText {
                                                text: "Папка хранения и резервные копии"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout10
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 10
                                        Layout.bottomMargin: 10
                                        ColumnLayout {
                                            id: columnLayout17

                                            SettingsRowLabel {
                                                text: "Папка заметок"
                                            }

                                            AppDescriptionText {
                                                text: "Локальное хранилище Markdown-файлов"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppInputField {
                                            id: pathText
                                            text: AppState.saveDirectory && AppState.saveDirectory.length > 0 ? AppState.saveDirectory : "Папка не выбрана"
                                            horizontalAlignment: Text.AlignLeft
                                            Layout.preferredWidth: 220
                                            readOnly: true
                                            selectByMouse: true
                                        }

                                        AppActionButton {
                                            text: "Выбрать"
                                            onClicked: notesFolderDialog.open()
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }
                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout11

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout18

                                            SettingsRowLabel {
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

                                    AppDivider {}
                                    SettingsControlRow {
                                        id: applicationLayout12
                                        Layout.rightMargin: 18
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 10
                                        Layout.bottomMargin: 10
                                        ColumnLayout {
                                            id: columnLayout19
                                            SettingsRowLabel {
                                                text: "Количество копий"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppInputField {
                                            id: backupCount
                                            text: "20"
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
                            AppSectionCard {
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

                                            SettingsRowLabel {
                                                text: "Поиск"
                                            }

                                            AppDescriptionText {
                                                text: "Поведение полнотекстового и интеллектуального поиска"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout15

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout23

                                            SettingsRowLabel {
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

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout16

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout24

                                            SettingsRowLabel {
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

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: applicationLayout14
                                        Layout.rightMargin: 18

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: columnLayout22

                                            SettingsRowLabel {
                                                text: "Индекс поиска"
                                            }

                                            AppDescriptionText {
                                                text: "Обновите индекс после массового импорта заметок"
                                            }
                                        }
                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppActionButton {
                                            text: "Переиндексировать"
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
                            AppSectionCard {
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
                                            SettingsRowLabel {
                                                text: "Граф"
                                            }

                                            AppDescriptionText {
                                                text: "Настройки визуализации связей между заметками"
                                            }
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    RowLayout {
                                        Layout.leftMargin: 18
                                        Layout.rightMargin: 18
                                        Layout.topMargin: 10
                                        Layout.bottomMargin: 10

                                        ColumnLayout {
                                            SettingsRowLabel {
                                                text: "Глубина связей"
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        AppInputField {
                                            id: graphDepthField
                                            text: "2"
                                            validator: IntValidator {
                                                bottom: 1
                                            }
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.preferredWidth: 80
                                        }

                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    RowLayout {
                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16

                                        ColumnLayout {
                                            SettingsRowLabel {
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
                            AppSectionCard {
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

                                            SettingsRowLabel {
                                                text: "Безопасность"
                                            }

                                            AppDescriptionText {
                                                text: "Защита локального хранилища и доступа к приложению"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: passwordOnApp

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            id: passwordText

                                            SettingsRowLabel {
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

                                    AppDivider {}

                                    SettingsControlRow {
                                        id: autoLock

                                        Layout.leftMargin: 18
                                        Layout.topMargin: 16
                                        Layout.bottomMargin: 16
                                        ColumnLayout {
                                            SettingsRowLabel {
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
                            AppSectionCard {
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

                                            SettingsRowLabel {
                                                text: "О программе"
                                            }

                                            AppDescriptionText {
                                                text: "Информация о текущей версии приложения"
                                            }
                                        }
                                        Layout.fillWidth: true
                                        Layout.fillHeight: false
                                    }

                                    AppDivider {}

                                    SettingsKeyValueRow {
                                        keyText: "Версия:"
                                        valueText: "0.0.1"
                                    }

                                    SettingsKeyValueRow {
                                        keyText: "Автор: "
                                        valueText: "Ренат"
                                    }

                                    SettingsKeyValueRow {
                                        keyText: "Хранилище: "
                                        valueText: "Local"
                                    }

                                    AppActionButton {
                                        text: "Открыть папку данных"
                                        Layout.leftMargin: Palette.spacingXl
                                        Layout.bottomMargin: Palette.spacingXl
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
