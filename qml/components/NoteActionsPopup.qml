pragma ComponentBehavior: Bound

import QtQuick 6.8
import "../scripts/Theme.js" as Palette

AppContextMenu {
    id: root

    property string targetItemKey: ""

    signal actionTriggered(string actionKey)

    menuWidth: 240

    function trigger(actionKey) {
        root.actionTriggered(actionKey);
        root.close();
    }

    AppMenuItem {
        uiFontFamily: root.uiFontFamily
        labelText: "Дублировать"
        iconSource: "qrc:/qt/qml/zametki/assets/icons/sidebar/new-note.svg"
        onClicked: root.trigger("duplicate")
    }

    AppMenuItem {
        uiFontFamily: root.uiFontFamily
        labelText: "Переместить"
        iconSource: "qrc:/qt/qml/zametki/assets/icons/list/folder.svg"
        onClicked: root.trigger("move")
    }

    AppMenuDivider {}

    AppMenuItem {
        uiFontFamily: root.uiFontFamily
        labelText: "Выгрузить на сервер"
        iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/sync.svg"
        onClicked: root.trigger("upload")
    }

    AppMenuItem {
        uiFontFamily: root.uiFontFamily
        labelText: "Подтянуть с сервера"
        iconSource: "qrc:/qt/qml/zametki/assets/icons/profile/sync.svg"
        onClicked: root.trigger("download")
    }

    AppMenuDivider {}

    AppMenuItem {
        uiFontFamily: root.uiFontFamily
        labelText: "Удалить"
        destructive: true
        onClicked: root.trigger("delete")
    }
}
