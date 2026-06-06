pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Layouts 6.8
import QtQuick.Controls 6.8
import "scripts/Theme.js" as Palette
import "scripts/SearchLogic.mjs" as SearchLogic
import "components"
import "components/search"

Item {
    id: root
    clip: true
    focus: true

    signal closeClicked
    signal noteSelected(string documentId)
    signal folderSelected(string folderPath)
    signal commandSelected(string commandKey)

    readonly property Item dialogItem: dialog
    readonly property int dialogMargin: Palette.space2
    readonly property int dialogMinHeight: Palette.controlHeightBase + Palette.searchHintBarHeight + Palette.space4

    property string query: ""
    property int selectedIndex: -1
    property var noteResults: []
    property var folderResults: []
    property var commandResults: []
    property string notesSectionTitle: qsTr("ПОСЛЕДНИЕ ЗАМЕТКИ")
    property bool hasResults: false

    readonly property var selectableItems: SearchLogic.flattenSelectableItems({
        notes: root.noteResults,
        folders: root.folderResults,
        commands: root.commandResults
    })

    readonly property var footerHints: [
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/list/closed-bracket.svg",
            label: qsTr("Навигация")
        },
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg",
            label: qsTr("Открыть")
        },
        {
            icon: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg",
            label: qsTr("Закрыть")
        }
    ]

    function focusQueryField() {
        searchInput.focusField();
        root.forceActiveFocus();
    }

    function refreshResults() {
        const sections = SearchLogic.buildSearchSections(AppState, root.query);
        root.noteResults = sections.notes;
        root.folderResults = sections.folders;
        root.commandResults = sections.commands;
        root.notesSectionTitle = sections.notesSectionTitle;
        root.hasResults = sections.hasResults;
        root.ensureSelection();
    }

    function ensureSelection() {
        if (root.selectableItems.length === 0) {
            root.selectedIndex = -1;
            return;
        }

        if (root.selectedIndex < 0 || root.selectedIndex >= root.selectableItems.length) {
            root.selectedIndex = 0;
        }
    }

    function moveSelection(delta) {
        if (root.selectableItems.length === 0) {
            return;
        }

        if (root.selectedIndex < 0) {
            root.selectedIndex = 0;
            return;
        }

        root.selectedIndex = Math.max(0, Math.min(root.selectableItems.length - 1, root.selectedIndex + delta));
    }

    function activateSelectedItem() {
        if (root.selectedIndex < 0 || root.selectedIndex >= root.selectableItems.length) {
            return;
        }

        root.activateItem(root.selectableItems[root.selectedIndex]);
    }

    function activateItem(item) {
        if (!item) {
            return;
        }

        if (item.type === "note" && item.id) {
            root.noteSelected(item.id);
            return;
        }

        if (item.type === "folder" && item.path) {
            root.folderSelected(item.path);
            return;
        }

        if (item.type === "command" && item.key) {
            root.commandSelected(item.key);
        }
    }

    function itemIndexForNote(noteId) {
        for (let i = 0; i < root.selectableItems.length; i++) {
            const item = root.selectableItems[i];
            if (item.type === "note" && item.id === noteId) {
                return i;
            }
        }
        return -1;
    }

    function itemIndexForFolder(folderPath) {
        for (let i = 0; i < root.selectableItems.length; i++) {
            const item = root.selectableItems[i];
            if (item.type === "folder" && item.path === folderPath) {
                return i;
            }
        }
        return -1;
    }

    function itemIndexForCommand(commandKey) {
        for (let i = 0; i < root.selectableItems.length; i++) {
            const item = root.selectableItems[i];
            if (item.type === "command" && item.key === commandKey) {
                return i;
            }
        }
        return -1;
    }

    Component.onCompleted: {
        root.refreshResults();
    }

    Connections {
        target: AppState
        function onDirectoryContentChanged() {
            root.refreshResults();
        }
        function onNoteTitlesChanged() {
            root.refreshResults();
        }
        function onFolderTitlesChanged() {
            root.refreshResults();
        }
        function onSnapshotChanged() {
            root.refreshResults();
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Down) {
            root.moveSelection(1);
            event.accepted = true;
            return;
        }
        if (event.key === Qt.Key_Up) {
            root.moveSelection(-1);
            event.accepted = true;
            return;
        }
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.activateSelectedItem();
            event.accepted = true;
        }
    }

    Rectangle {
        id: dialog
        width: Math.min(Palette.dialogMaxWidth, Math.max(Palette.searchDialogMinWidth, root.width - (root.dialogMargin * 2)))
        height: Math.min(Palette.searchDialogHeight, Math.max(root.dialogMinHeight, root.height - (root.dialogMargin * 2)))
        color: Palette.headerBackground
        radius: Palette.modalSurfaceRadius
        border.width: 1
        border.color: Palette.border
        anchors.centerIn: parent
        antialiasing: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Palette.dialogPadding
                Layout.rightMargin: Palette.dialogPadding
                Layout.topMargin: Palette.spacingXl
                Layout.bottomMargin: Palette.spacingXl
                spacing: Palette.spacingXl

                SearchInputBar {
                    id: searchInput
                    Layout.fillWidth: true
                    onQueryChanged: function(nextQuery) {
                        root.query = nextQuery;
                        root.refreshResults();
                    }
                    onAccepted: function(nextQuery) {
                        root.query = nextQuery;
                        root.refreshResults();
                        root.activateSelectedItem();
                    }
                }

                AppIconSurfaceButton {
                    iconSource: "qrc:/qt/qml/zametki/assets/icons/share/close-btn.svg"
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: root.closeClicked()
                }
            }

            AppDivider {
                Layout.fillWidth: true
            }

            Flickable {
                id: resultsFlickable
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: contentColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: contentColumn
                    width: parent.width
                    spacing: 0

                    SearchSectionHeader {
                        visible: root.noteResults.length > 0
                        text: root.notesSectionTitle
                        Layout.leftMargin: Palette.dialogPadding
                        Layout.topMargin: Palette.space2
                    }

                    Repeater {
                        model: root.noteResults

                        SearchResultRow {
                            required property var modelData
                            required property int index

                            Layout.leftMargin: Palette.searchInset
                            Layout.rightMargin: Palette.dialogPadding
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                            subtitleText: modelData.subtitle
                            highlighted: root.selectedIndex === root.itemIndexForNote(modelData.id)
                            onClicked: root.activateItem(Object.assign({ type: "note" }, modelData))
                        }
                    }

                    SearchSectionHeader {
                        visible: root.folderResults.length > 0
                        text: qsTr("ПАПКИ")
                        Layout.leftMargin: Palette.dialogPadding
                        Layout.topMargin: root.noteResults.length > 0 ? Palette.space2 : Palette.space2
                    }

                    Repeater {
                        model: root.folderResults

                        SearchResultRow {
                            required property var modelData
                            required property int index

                            Layout.leftMargin: Palette.searchInset
                            Layout.rightMargin: Palette.dialogPadding
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                            highlighted: root.selectedIndex === root.itemIndexForFolder(modelData.path)
                            onClicked: root.activateItem(Object.assign({ type: "folder" }, modelData))
                        }
                    }

                    SearchSectionHeader {
                        visible: root.commandResults.length > 0
                        text: qsTr("КОМАНДЫ")
                        Layout.leftMargin: Palette.dialogPadding
                        Layout.topMargin: (root.noteResults.length > 0 || root.folderResults.length > 0) ? Palette.space2 : Palette.space2
                    }

                    Repeater {
                        model: root.commandResults

                        SearchResultRow {
                            required property var modelData
                            required property int index

                            Layout.leftMargin: Palette.searchInset
                            Layout.rightMargin: Palette.dialogPadding
                            Layout.topMargin: index === 0 ? Palette.spacingXl : 0
                            iconSource: modelData.icon
                            titleText: modelData.title
                            highlighted: root.selectedIndex === root.itemIndexForCommand(modelData.key)
                            onClicked: root.activateItem(Object.assign({ type: "command" }, modelData))
                        }
                    }

                    AppDescriptionText {
                        visible: !root.hasResults && root.query.trim().length > 0
                        text: qsTr("Ничего не найдено")
                        textColor: Palette.textSecondary
                        Layout.leftMargin: Palette.dialogPadding
                        Layout.rightMargin: Palette.dialogPadding
                        Layout.topMargin: Palette.spacingXl
                        Layout.bottomMargin: Palette.spacingXl
                    }

                    AppDescriptionText {
                        visible: !root.hasResults && root.query.trim().length === 0 && !AppState.databaseConfigured
                        text: qsTr("Выберите папку с базой данных в настройках")
                        textColor: Palette.textSecondary
                        Layout.leftMargin: Palette.dialogPadding
                        Layout.rightMargin: Palette.dialogPadding
                        Layout.topMargin: Palette.spacingXl
                        Layout.bottomMargin: Palette.spacingXl
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            SearchHintsBar {
                hintsModel: root.footerHints
            }
        }
    }
}
