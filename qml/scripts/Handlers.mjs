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

export function onMoreClicked() {
    console.log("Нажатие на Дополнительно");
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
