import QtQuick 1.1

Rectangle {
//    id: start_button

    property string button_text: ""

//    x: quest_menu.width / 2 - width / 2
//    y: (quest_menu.height - (28 * 2 + 10)) / 2 + 28 + 10

    width: 110
    height: 28

    color: "transparent"
    border.color: "blue"

    radius: 3;

    Text{
        text: button_text
        color: parent.border.color

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

}
