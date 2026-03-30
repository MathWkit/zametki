import QtQuick 6.8
import QtQuick.Controls

Window {
    width: 250
    height: 200
    visible: true
    title: "METANIT.COM"

    Column {
        Text {
            text: "sada"
        }
        Text {
            text: "sada"
        }
        Text {
            text: "sada"
        }

        CheckBox {
            checked: true // флажок отмечен
        }
        CheckBox {
            text: "Java"
        }
        CheckBox {
            checked: true // флажок отмечен
            text: "JavaScript"
        }
    }
}
