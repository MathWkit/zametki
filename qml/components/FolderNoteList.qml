pragma ComponentBehavior: Bound

import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../scripts/Theme.js" as Palette

Column {
    id: root

    property string fontFamily: ""
    property var folderTitles: []
    property var noteTitles: []
    property string selectedItemKey: ""
    property var expandedFolders: ({})
    property var visibleFolderItems: []

    signal folderClicked(string folderTitle)
    signal noteClicked(string noteTitle)
    signal itemSelected(string itemKey)

    spacing: 5

    function toggleFolder(folderPath) {
        const expandedMap = Object.assign({}, root.expandedFolders);
        expandedMap[folderPath] = !expandedMap[folderPath];

        root.expandedFolders = expandedMap;
        rebuildFolderView();
    }

    function pruneFolderState() {
        const validFolders = {};
        for (let i = 0; i < root.folderTitles.length; i++) {
            validFolders[root.folderTitles[i]] = true;
        }

        const expandedMap = {};
        for (const folderName in root.expandedFolders) {
            if (validFolders[folderName] || folderName.indexOf("/") !== -1) {
                expandedMap[folderName] = root.expandedFolders[folderName];
            }
        }

        root.expandedFolders = expandedMap;
        root.visibleFolderItems = [];
    }

    function appendFolderAndChildren(target, folderName, folderPath, depth) {
        target.push({
            type: "folder",
            name: folderName,
            path: folderPath,
            depth: depth
        });

        if (!root.expandedFolders[folderPath]) {
            return;
        }

        // qmllint disable unqualified
        const entries = AppState.entriesForFolder(folderPath);
        // qmllint enable unqualified
        for (let i = 0; i < entries.length; i++) {
            const entry = entries[i];
            if (entry.isFolder) {
                appendFolderAndChildren(target, entry.name, entry.path, depth + 1);
            } else {
                target.push({
                    type: "note",
                    name: entry.name,
                    path: entry.path,
                    depth: depth + 1
                });
            }
        }
    }

    function rebuildFolderView() {
        const items = [];
        for (let i = 0; i < root.folderTitles.length; i++) {
            const folderName = root.folderTitles[i];
            appendFolderAndChildren(items, folderName, folderName, 0);
        }
        root.visibleFolderItems = items;
    }

    onFolderTitlesChanged: {
        pruneFolderState();
        rebuildFolderView();
    }

    Component.onCompleted: {
        rebuildFolderView();
    }

    Connections {
        // qmllint disable unqualified
        target: AppState
        // qmllint enable unqualified
        function onDirectoryContentChanged() {
            root.rebuildFolderView();
        }
    }

    Text {
        text: "Папки"
        font.family: root.fontFamily
        font.pixelSize: 11
        font.weight: Font.DemiBold
        color: Palette.textSecondary
        anchors.left: parent.left
        anchors.leftMargin: 12
    }

    Repeater {
        model: root.visibleFolderItems

        delegate: Rectangle {
            id: treeItem
            required property var modelData

            readonly property bool isFolder: modelData.type === "folder"
            readonly property int depth: modelData.depth || 0
            readonly property bool isSelected: !isFolder && root.selectedItemKey === ("folder-note:" + modelData.path)

            width: parent ? parent.width : 0
            height: isFolder ? 26 : 28
            clip: true
            color: treeItem.isSelected ? "#E6F0FF" : (itemMouseArea.containsMouse ? Palette.hover : "transparent")
            radius: Palette.cornerRadius

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12 + treeItem.depth * 20
                anchors.rightMargin: 12
                spacing: 8

                Image {
                    source: treeItem.isFolder
                        ? "qrc:/qt/qml/zametki/assets/icons/list/closed-bracket.svg"
                        : ""
                    width: 16
                    height: 16
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    rotation: treeItem.isFolder && root.expandedFolders[treeItem.modelData.path] ? 90 : 0
                    opacity: treeItem.isFolder ? 1 : 0
                }

                Image {
                    source: {
                        if (treeItem.isFolder) {
                            if (root.expandedFolders[treeItem.modelData.path]) {
                                return "qrc:/qt/qml/zametki/assets/icons/list/open-folder.svg";
                            }
                            return "qrc:/qt/qml/zametki/assets/icons/list/folder.svg";
                        }

                        return treeItem.isSelected ? "qrc:/qt/qml/zametki/assets/icons/list/note-selected.svg" : "qrc:/qt/qml/zametki/assets/icons/list/note.svg";
                    }
                    width: 16
                    height: 16
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: treeItem.modelData.name
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Normal
                    color: treeItem.isSelected ? "#0B74DE" : Palette.textPrimary
                    wrapMode: Text.NoWrap
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                id: itemMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    if (treeItem.isFolder) {
                        root.toggleFolder(treeItem.modelData.path);
                        root.folderClicked(treeItem.modelData.path);
                        return;
                    }

                    root.itemSelected("folder-note:" + treeItem.modelData.path);
                    root.noteClicked(treeItem.modelData.path);
                }
            }
        }
    }

    Repeater {
        model: root.noteTitles

        delegate: Rectangle {
            id: noteItem
            required property string modelData
            readonly property bool isSelected: root.selectedItemKey === ("note:" + noteItem.modelData)

            width: parent ? parent.width : 0
            height: 30
            clip: true
            color: noteItem.isSelected ? "#E6F0FF" : (noteMouseArea.containsMouse ? Palette.hover : "transparent")
            radius: Palette.cornerRadius

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Image {
                    source: noteItem.isSelected ? "qrc:/qt/qml/zametki/assets/icons/list/note-selected.svg" : "qrc:/qt/qml/zametki/assets/icons/list/note.svg"
                    width: 16
                    height: 16
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: noteItem.modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Normal
                    color: noteItem.isSelected ? "#0B74DE" : Palette.textPrimary
                    wrapMode: Text.NoWrap
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                id: noteMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    root.itemSelected("note:" + noteItem.modelData);
                    root.noteClicked(noteItem.modelData);
                }
            }
        }
    }
}
