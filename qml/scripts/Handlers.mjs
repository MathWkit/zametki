export function onSearchClicked() {
    console.log("Нажатие на Поиск");
}

export function onNewNoteClicked(fileCreator) {
    if (fileCreator && fileCreator.createDesktopMarkdown()) {
        console.log("Создана новая заметка");
    } else if (fileCreator) {
        console.log("Не удалось создать файл:", fileCreator.lastError());
    } else {
        console.log("Не удалось создать файл: fileCreator не задан");
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

export function onNoteClicked(noteTitle) {
    console.log("Выбрана заметка:", noteTitle);
}

export function onFolderClicked(folderTitle) {
    console.log("Выбрана папка:", folderTitle);
}

export function onProfileClicked() {
    console.log("Нажатие на Профиль");
}
