import QtQuick 1.1

Rectangle {
//    id: start_button

    property string button_text: ""

//    x: quest_menu.width / 2 - width / 2
//    y: (quest_menu.height - (28 * 2 + 10)) / 2 + 28 + 10

//    width: parent.width * 0.9
//    height: 28

    color: "transparent"

    Image{
        id: button_image
        source: ":/img/button_off.PNG"

        width: parent.width
        height: parent.height
    }

    Text{
        text: button_text
        color: "white"

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

}
