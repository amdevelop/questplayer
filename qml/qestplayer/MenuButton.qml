import QtQuick 1.1

Rectangle {

    property string button_text: ""

    width: stories_listview.width
    height: stories_listview.height / 6

    color: "transparent"

    Rectangle {

        id: delegate_rect

        height: parent.height - 10
        width: parent.width

        anchors.centerIn: parent.Center

        color: "white"

        opacity: 0.5

        radius: 3
    }

    Text {
        text: button_text
        color: "white"

        anchors.centerIn: delegate_rect
//        anchors.verticalCenter: delegate_rect.verticalCenter
//        anchors.horizontalCenter: delegate_rect.horizontalCenter
    }

}
