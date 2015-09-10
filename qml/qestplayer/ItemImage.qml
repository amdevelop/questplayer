import QtQuick 1.1


Rectangle{
    property bool found: false

    width: item_image.width
    height: item_image.height

    Image {
        id: item_image

//        width: parent.width
//        height: parent.height

        MouseArea{
            width: parent.width
            height: parent.height

            onClicked: {
                if(parent.found === true)
                {
                    parent.visible = false;

                    QuestJs.checkScene();
                }

    //            item_image.visible = false;
    //            item_text.visible = false;
            }
        }
    }

    states: State {
        name: "show_in_center"
        when: item_image.found == true
        PropertyChanges {
            target: item_image

            x: container.width / 2 - item_image.width / 2
            y: container.height / 2 - item_image.height / 2

            width: (item_image.parent.width * 0.2)
            height: (item_image.width / item_image.height) * item_image.parent.width * 0.2

//            rotation: 5 * 360
//          scale: 1
        }
    }

    transitions: Transition {
        from: ""; to: "show_in_center";
        NumberAnimation { properties: "x,y,width,height"; duration: 200; easing.type: Easing.Linear }
    }

}

