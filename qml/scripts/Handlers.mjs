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
    console.log("Нажатие на Hide Sidebar");
}

export function onShareClicked() {
    console.log("Нажата иконка Share");
}

export function onFavoriteClicked() {
    console.log("Нажата иконка Favorite");
}

export function onMoreClicked() {
    console.log("Нажата иконка More");
}

export function onNoteClicked(noteTitle) {
    console.log("Выбрана заметка:", noteTitle);
}

export function onFolderClicked(folderTitle) {
    console.log("Выбрана папка:", folderTitle);
}
