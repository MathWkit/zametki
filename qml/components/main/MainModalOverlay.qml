import QtQuick 6.8
import "../../scripts/Theme.js" as Palette

Rectangle {
    id: control

    property url source: ""
    property bool closeOnOutsideClick: true
    readonly property Item loadedItem: contentLoader.item

    signal outsideCloseRequested

    anchors.fill: parent
    color: Palette.overlayScrim

    MouseArea {
        anchors.fill: parent
        onClicked: function (mouse) {
            if (!control.closeOnOutsideClick) {
                return;
            }

            if (!contentLoader.item || !contentLoader.item.dialogItem) {
                return;
            }

            const dialog = contentLoader.item.dialogItem;
            const dialogPos = dialog.mapToItem(control, 0, 0);
            const clickedOutsideDialog = mouse.x < dialogPos.x || mouse.x > (dialogPos.x + dialog.width) || mouse.y < dialogPos.y || mouse.y > (dialogPos.y + dialog.height);

            if (clickedOutsideDialog) {
                control.outsideCloseRequested();
            }
        }
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        active: control.visible
        source: control.source
    }
}
