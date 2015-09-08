import QtQuick 1.1

Image {
    id: item_image

    property bool found: false

    states: State {
        name: "show_in_center"
        when: item_window.visible == true
        PropertyChanges {
            target: item_window

            x: container.width / 2 - item_window.width / 2
            y: container.height / 2 - item_window.height / 2

            rotation: 5 * 360

            scale: 1
        }
    }

    transitions: Transition {
        from: ""; to: "show_in_center";
        NumberAnimation { properties: "x,y,rotation,scale"; duration: 200; easing.type: Easing.Linear }
    }

}
