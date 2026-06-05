import QtQuick 6.8
import QtQuick.Layouts 6.8
import "../../scripts/Theme.js" as Palette
import ".."

RowLayout {
    id: control

    required property string participantId
    required property string avatarInitials
    required property string nameText
    required property string emailText
    property var roleOptionsModel: []
    property int roleCurrentIndex: 0

    signal roleActivated(string newRoleText)

    Layout.fillWidth: true
    spacing: Palette.spacingXl

    AppInitialsAvatar {
        initials: control.avatarInitials
        avatarSize: Palette.avatarMedium
        initialsPixelSize: Palette.fontSizeSm
        Layout.preferredWidth: Palette.avatarMedium
        Layout.preferredHeight: Palette.avatarMedium
        Layout.alignment: Qt.AlignVCenter
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Palette.spacingSm

        AppBodyText {
            text: control.nameText
        }

        AppDescriptionText {
            text: control.emailText
        }
    }

    Item {
        Layout.fillWidth: true
    }

    AppDropdown {
        id: roleDropdown
        model: control.roleOptionsModel
        currentIndex: control.roleCurrentIndex

        onActivated: control.roleActivated(roleDropdown.currentText)
    }
}
