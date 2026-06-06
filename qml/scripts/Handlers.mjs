export function onSearchClicked() {
    console.log("Нажатие на Поиск");
}

export function onNewNoteClicked(appState) {
    if (appState && appState.createEmptyDocument && appState.createEmptyDocument()) {
        console.log("Создана новая заметка");
    } else if (appState) {
        console.log("Не удалось создать заметку:", appState.lastError());
    } else {
        console.log("Не удалось создать заметку: AppState не задан");
    }
}

export function onGraphClicked() {
    console.log("Нажатие на Вид графа");
}

export function onSettingsClicked() {
    console.log("Нажатие на Настройки");
}

export function onHideSidebarClicked() {
    console.log("Нажатие на Скрыть боковую панель");
}

export function onShareClicked() {
    console.log("Нажатие на Поделиться");
}

export function onFavoriteClicked() {
    console.log("Нажатие на Избранное");
}

export function resolveActiveItemKey(appState, explicitKey, selectedItemKey) {
    if (explicitKey && explicitKey.length > 0) {
        return explicitKey;
    }
    if (selectedItemKey && selectedItemKey.length > 0) {
        return selectedItemKey;
    }
    if (appState && appState.currentItemKey) {
        return appState.currentItemKey() || "";
    }
    return "";
}

export function onNoteAction(appState, syncState, action, itemKey, window) {
    const key = resolveActiveItemKey(appState, itemKey, window ? window.selectedItemKey : "");
    if (!key) {
        console.log("Действие с заметкой: нет выбранной заметки");
        return false;
    }

    const noteId = appState.resolveDocumentIdFromItemKey(key);
    if (!noteId) {
        console.log("Действие с заметкой: не удалось определить id", appState.lastError());
        return false;
    }

    if (action === "delete") {
        if (window) {
            window.flushAllDelegates();
        }
        if (appState.deleteDocumentByItemKey(key)) {
            if (window && window.selectedItemKey === key) {
                window.selectedItemKey = "";
            }
            console.log("Заметка удалена");
            return true;
        }
        console.log("Не удалось удалить заметку:", appState.lastError());
        return false;
    }

    if (action === "duplicate") {
        if (window) {
            window.flushAllDelegates();
        }
        const newId = appState.duplicateDocumentByItemKey(key);
        if (newId && newId.length > 0) {
            if (window) {
                window.selectedItemKey = appState.currentItemKey();
            }
            console.log("Заметка продублирована:", newId);
            return true;
        }
        console.log("Не удалось дублировать заметку:", appState.lastError());
        return false;
    }

    if (action === "move") {
        if (window && window.openFolderActionPopup) {
            window.selectedItemKey = key;
            window.openFolderActionPopup("move");
            return true;
        }
        return false;
    }

    if (action === "upload") {
        if (!syncState || !syncState.isLoggedIn) {
            console.log("Выгрузка: требуется вход в аккаунт");
            return false;
        }
        if (window) {
            window.flushAllDelegates();
        }
        syncState.uploadNoteNow(noteId);
        return true;
    }

    if (action === "download") {
        if (!syncState || !syncState.isLoggedIn) {
            console.log("Загрузка: требуется вход в аккаунт");
            return false;
        }
        syncState.downloadNoteNow(noteId);
        return true;
    }

    return false;
}

export function onProfileSyncAction(syncState, actionKey, window) {
    if (!syncState || !syncState.isLoggedIn) {
        console.log("Синхронизация: требуется вход в аккаунт");
        return false;
    }

    if (window) {
        window.flushAllDelegates();
    }

    if (actionKey === "upload-all") {
        syncState.uploadAllNotesNow();
        return true;
    }

    if (actionKey === "pull-soft-all") {
        syncState.softPullAllNotesNow();
        return true;
    }

    if (actionKey === "pull-hard-all") {
        syncState.hardPullAllNotesNow();
        return true;
    }

    return false;
}

export function onMoreClicked(appState, window) {
    if (!window || !window.openNoteActionsMenu) {
        console.log("Нажатие на Дополнительно");
        return;
    }
    window.openNoteActionsMenu("", -1, -1);
}

export function onNoteClicked(appState, noteTitle) {
    if (appState && appState.openDocumentByTitle && appState.openDocumentByTitle(noteTitle)) {
        console.log("Открыта заметка:", noteTitle);
    } else if (appState) {
        console.log("Не удалось открыть заметку:", appState.lastError());
    } else {
        console.log("Не удалось открыть заметку: AppState не задан");
    }
}

export function onFolderClicked(folderTitle) {
    console.log("Выбрана папка:", folderTitle);
}

export function onProfileClicked() {
    console.log("Нажатие на Профиль");
}
