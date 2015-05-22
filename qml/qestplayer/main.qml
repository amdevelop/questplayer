import QtQuick 1.1
//import QuestItems 1.0

import "qrc:/quest.js" as QuestJs

Rectangle {

    id: container
    //    width: 300
    //    height: 200

    focus: true

    property bool can_check_collisions: true

    property string quest_json: ""
    property string episodes_json: ""
    property string stories_json: ""

    onStories_jsonChanged:
    {
        QuestJs.initStoriesMenu();
    }

    onQuest_jsonChanged:
    {
        QuestJs.quest_path = "http://quest:8888/quests/" +
                stories_view.path;

        QuestJs.initQuest();

        stories_view.visible = false;

        quest_menu.visible = true;
        anim.start();
    }

    onEpisodes_jsonChanged: {
        stories_view.mode = "episodes";
        QuestJs.initEpisodesMenu();

        //        console.log(episodes_json);
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {

            console.log("123");
            if(quest_menu.visible)
                quest_menu.visible = false;
            else
            {
                item_menu.visible = false;

                quest_menu.visible = true;
                anim.start();
            }
            event.accepted = true;
        }
        else if (event.key === Qt.Key_Tab) {
            console.log("321");
            if(item_menu.visible)
                item_menu.visible = false;
            else
            {
                if(!quest_menu.visible)
                {
                    item_menu.visible = true;
                    anim_item_menu.start();
                }
            }
            event.accepted = true;
        }
    }

    Image {
        id: background_image
        smooth: true
        source: ""
    }

    MouseArea {
        width: parent.width
        height: parent.height

        onClicked:
        {
            QuestJs.checkCollisions(mouseX, mouseY);
        }
    }

    Rectangle
    {
        id: quest_menu

        y: -height

        width: container.width
        height: container.height

        // opacity: 0.9
        color: "#ccc"

        visible: false

        Image {
            id: episode_cover
            width: quest_menu.width
            height: quest_menu.height

            source: ""
        }

        Text{
            id: episode_title
            font.pixelSize: 28

            color: "white"

            y: (container.height * (1/3)) / 2
            x: container.width / 2 - width / 2
        }

        NumberAnimation on y { id: anim; from: -height; to: 0; duration: 450; easing.type: Easing.OutBounce}

        Rectangle {
            id: start_button

            x: quest_menu.width / 2 - width / 2
            y: (quest_menu.height - (28 * 2 + 10)) / 2 + 28 + 10

            width: 110
            height: 28

            color: "transparent"
            border.color: "blue"

            radius: 3;

            Text{
                text: "START"
                color: parent.border.color

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                width: parent.width
                height: parent.height

                hoverEnabled: true

                onClicked:
                {
                    QuestJs.startQuest();
                    quest_menu.visible = false;
                }
                onEntered: parent.border.color = "green"
                onExited: parent.border.color = "blue"
            }
        }

        Rectangle {
            id: exit_button

            x: quest_menu.width / 2 - width / 2
            y: (quest_menu.height - (28 * 2 + 10)) / 2 + 2 * (28 + 10)

            width: 110
            height: 28

            color: "transparent"
            border.color: "blue"

            radius: 3;

            Text{
                text: "EXIT"
                color: parent.border.color

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                width: parent.width
                height: parent.height

                hoverEnabled: true

                onClicked: Qt.quit();
                onEntered: parent.border.color = "green"
                onExited: parent.border.color = "blue"

            }
        }
    }

    Rectangle
    {
        id: item_menu

        x: -width

        width: 100
        height: container.height

        opacity: 0.9
        color: "#ccc"

        visible: false

        NumberAnimation on x { id: anim_item_menu; from: -width; to: 0; duration: 200; easing.type: Easing.OutQuint}

        Component
        {
            id: item_delegate

            Rectangle{
                height: 30
                width: item_menu.width
                color: "transparent"

                Text {
                    x: parent.width / 2 - width / 2
                    y: parent.height / 2 - height / 2
                    text: item
                    color: item_color
                }
            }
        }

        ListModel
        {
            id: item_model
        }

        ListView
        {
            width: parent.width
            height: parent.height

            delegate: item_delegate

            model: item_model
        }
    }

    Rectangle{
        id: info_view

        width: parent.width
        height: parent.height

        color: "black"

        visible: false

        Timer {
            id: timer_animation_show
            interval: 2000
            repeat: true
            onTriggered: {console.log("LL");QuestJs.infoShown();}
        }

        Text{
            id: info_text
            color: "white"

            font.pointSize: 24

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            NumberAnimation on opacity { id: anim_info_text_show; from: 0; to: 1; duration: 1000; easing.type: Easing.Linear}
            NumberAnimation on opacity { id: anim_info_text_hide; from: 1; to: 0; duration: 1000; easing.type: Easing.Linear}
        }
    }

    Rectangle{
        id: item_window

        radius: 10

        color: "black"

        border.color: "white"
        border.width: 5

        width: 150
        height: 150

        smooth: true

        visible: false

        Image {
            width: parent.width - parent.border.width * 2
            height: parent.height - parent.border.height * 2

            id: item_image
            source: ""
        }

        Text {
            //            width: parent.width - parent.border.width * 2
            //            height: parent.height - parent.border.width * 2

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            color: "white"

            font.pointSize: 24

            id: item_text
            wrapMode: Text.WordWrap
        }

        MouseArea{
            width: parent.width
            height: parent.height

            onClicked: {
                if(parent.visible === true)
                {
                    parent.visible = false;

                    QuestJs.checkScene();
                }

                item_image.visible = false;
                item_text.visible = false;
            }
        }

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


    Rectangle {
        id: stories_view

        color: "black"

        width: parent.width
        height: parent.height

        property string mode: "stories"
        property string path_story_id: ""
        property string path_episode_id: ""
        property string path: path_story_id + "/" + path_episode_id

        Image {
            x:0
            y:0
            id: story_cover
        }

        Component {
            id: contactDelegate
            Item {
                width: parent.width; height: 40

                property string story_id: id

                property string story_cover_id: cover

//                Image {

//                    x: 10
//                    y: 10

//                    height: parent.height - 10 * 2
//                    width: parent.height - 10 * 2

//                    source: cover
//                }

                Text { text: title
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        console.log(stories_view.mode);

                        if(stories_view.mode === "stories")
                        {
                            stories_listview.currentIndex = index;

                            stories_view.path_story_id = story_id;

                            story_cover.source = parent.story_cover_id;

                            story_cover.width = stories_view.width;
                            story_cover.height = stories_view.height;
                        }
                        else if(stories_view.mode === "episodes")
                        {
                            stories_listview.currentIndex = index;

                            stories_view.path_episode_id = story_id;
                            story_cover.source = "http://quest:8888/quests/" +
                                    stories_view.path + "/" +
                                    parent.story_cover_id;

                            console.log("http://quest:8888/quests/" +
                                        stories_view.path + "/" +
                                        parent.story_cover_id);
                            story_cover.width = stories_view.width;
                            story_cover.height = stories_view.height;
                        }
                    }
                }
            }
        }

        ListModel {
            id: stories_model
        }

        ListView {
            id: stories_listview

            width: 180
            height: parent.height
            anchors.right: parent.right
            model: stories_model
            delegate: contactDelegate
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            //focus: true
        }

        Rectangle {
            width: 180
            height: 80

            x: parent.width - 180
            y: parent.height - 80

            color: "lightsteelblue";
            radius: 5
            Text {
                text: "Play!"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            MouseArea {
                width: parent.width
                height: parent.height

                onClicked: {
                    if(stories_view.mode === "stories")
                        container.getStoryManifest(stories_view.path)
                    else if(stories_view.mode === "episodes")
                    {
                        console.log("lol "  + stories_view.path);
                        container.getEpisodeData(stories_view.path)
                    }
                }
            }
        }
    }

    signal getStoryManifest(string story_id)
    signal getEpisodeData(string path)

}
