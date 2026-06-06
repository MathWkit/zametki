const NOTE_ICON = "qrc:/qt/qml/zametki/assets/icons/list/note.svg";
const FOLDER_ICON = "qrc:/qt/qml/zametki/assets/icons/list/folder.svg";
const CREATE_NOTE_ICON = "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg";
const GRAPH_ICON = "qrc:/qt/qml/zametki/assets/icons/sidebar/graph-view.svg";

const RECENT_NOTES_LIMIT = 5;
const SEARCH_NOTES_LIMIT = 20;

export function buildCommands() {
    return [
        {
            key: "create-note",
            title: "Создать заметку",
            icon: CREATE_NOTE_ICON
        },
        {
            key: "open-graph",
            title: "Открыть граф",
            icon: GRAPH_ICON
        }
    ];
}

export function filterByQuery(items, query, titleKey = "title") {
    const trimmed = (query || "").trim().toLowerCase();
    if (!trimmed) {
        return items.slice();
    }

    return items.filter(item => {
        const title = (item[titleKey] || "").toLowerCase();
        return title.includes(trimmed);
    });
}

export function collectAllFolders(appState) {
    if (!appState || !appState.entriesForFolder) {
        return [];
    }

    const folders = [];
    const seen = new Set();

    function appendFolder(entry) {
        if (!entry || !entry.path || seen.has(entry.path)) {
            return;
        }
        seen.add(entry.path);
        folders.push({
            path: entry.path,
            title: entry.name || entry.path,
            icon: FOLDER_ICON
        });
    }

    function walk(folderPath) {
        const entries = appState.entriesForFolder(folderPath);
        for (let i = 0; i < entries.length; i++) {
            const entry = entries[i];
            if (!entry.isFolder) {
                continue;
            }
            appendFolder(entry);
            walk(entry.path);
        }
    }

    const topFolders = appState.folderTitles || [];
    for (let i = 0; i < topFolders.length; i++) {
        const folderTitle = topFolders[i];
        appendFolder({
            name: folderTitle,
            path: folderTitle,
            isFolder: true
        });
        walk(folderTitle);
    }

    return folders;
}

export function buildNoteResults(appState, query) {
    if (!appState || !appState.getAllDocuments) {
        return [];
    }

    const trimmed = (query || "").trim();
    const documents = trimmed
        ? appState.searchDocuments(trimmed)
        : appState.getAllDocuments();
    const limit = trimmed ? SEARCH_NOTES_LIMIT : RECENT_NOTES_LIMIT;
    const currentId = appState.currentDocumentId || "";
    const results = [];
    const seen = new Set();

    function appendDocument(doc) {
        if (!doc || !doc.id || seen.has(doc.id)) {
            return;
        }
        seen.add(doc.id);
        results.push({
            type: "note",
            id: doc.id,
            title: doc.title && doc.title.length > 0 ? doc.title : doc.id,
            subtitle: appState.folderPathForDocumentId
                ? appState.folderPathForDocumentId(doc.id)
                : "",
            icon: NOTE_ICON
        });
    }

    if (!trimmed && currentId) {
        for (let i = 0; i < documents.length; i++) {
            if (documents[i].id === currentId) {
                appendDocument(documents[i]);
                break;
            }
        }
    }

    for (let i = 0; i < documents.length && results.length < limit; i++) {
        appendDocument(documents[i]);
    }

    return results;
}

export function buildSearchSections(appState, query) {
    const trimmed = (query || "").trim();
    const notes = buildNoteResults(appState, query);
    const folders = filterByQuery(collectAllFolders(appState), query);
    const commands = filterByQuery(buildCommands(), query, "title");

    return {
        notes,
        folders,
        commands,
        notesSectionTitle: trimmed ? "ЗАМЕТКИ" : "ПОСЛЕДНИЕ ЗАМЕТКИ",
        hasResults: notes.length > 0 || folders.length > 0 || commands.length > 0
    };
}

export function flattenSelectableItems(sections) {
    const items = [];

    for (let i = 0; i < sections.notes.length; i++) {
        items.push(sections.notes[i]);
    }
    for (let i = 0; i < sections.folders.length; i++) {
        items.push(Object.assign({ type: "folder" }, sections.folders[i]));
    }
    for (let i = 0; i < sections.commands.length; i++) {
        items.push(Object.assign({ type: "command" }, sections.commands[i]));
    }

    return items;
}
