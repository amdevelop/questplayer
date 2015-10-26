import QtQuick 1.1
import Effects 1.0
//import MenuButton 1.0

import "qrc:/quest.js" as QuestJs

//import ":/qml/qestplayer/MenuButton.qml" as MenuButton

Rectangle {

    id: container
    //    width: 300
    //    height: 200

    focus: true

    property bool can_check_collisions: true

    property string quest_json: ""
    property string episodes_json: ""
    property string stories_json: ""
    property string server_name: ""

    property string path_separator: "/"

    onStories_jsonChanged:
    {
        QuestJs.initStoriesMenu();
    }

    onQuest_jsonChanged:
    {
        QuestJs.quest_path = server_name +
                path_separator +
                stories_view.path;

        QuestJs.initQuest(stories_view.path_episode_id);

        stories_view.visible = false;

        //        quest_menu.visible = true;
        //        anim.start();

        QuestJs.startQuest();
    }

    onEpisodes_jsonChanged: {
        stories_view.mode = "episodes";
        QuestJs.initEpisodesMenu();
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
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

    function loadImage()
    {
        QuestJs.loadImage();
    }

    // QUEST ITEMS !!!
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

    Rectangle {
        id: pause_button

        width: height
        height: play_button.height * 0.7

        x: parent.width - width
        y: 0

        z: 300

        color: "transparent";

        Image {
            id: pause_button_image

            source: "qrc:/img/back_for_button_2.PNG"

            width: parent.width
            height: parent.height
        }

        Image {
            id: pause_button_icon
            source: "qrc:/img/button_pause_off.PNG"

            width: parent.width * 0.55
            height: width

            x: pause_button_image.width * 0.22
            y: pause_button_image.height * 0.205
        }

        NumberAnimation{
            id: pause_show_anim
            target: pause_button
            property: "x"
            duration: 100;
            easing.type: Easing.InOutQuad;

            from: container.width
            to: container.width - pause_button.width
        }

        NumberAnimation {
            id: pause_hide_anim
            target: pause_button
            property: "x"
            duration: 100;
            easing.type: Easing.InOutQuad;

            from: container.width - pause_button.width
            to: container.width
        }

        //        Component.onCompleted: {
        //            visible = false;
        //            pause_hide_anim.start();
        //            visible = true;
        //        }

        MouseArea {
            width: parent.width
            height: parent.height

            onClicked: {
                if(quest_menu.visible === true)
                    quest_menu.visible = false;
                else
                {
                    item_menu.visible = false;

                    quest_menu.visible = true;
                    anim.start();
                    pause_hide_anim.start();
                    item_menu_hide_anim.start();
                }
                pause_button_icon.source = "qrc:/img/button_pause_off.PNG";
            }

            onPressed: {
                pause_button_icon.source = "qrc:/img/button_pause_on.PNG";
            }
        }
    }

    Rectangle {
        id: item_menu_button

        width: height
        height: play_button.height * 0.7

        x: 0 // parent.width - width
        y: 0
        z: item_menu.z + 1

        color: "transparent";
//        rotation: 180

        Image {
            id: item_menu_button_image

            source: "qrc:/img/back_for_button_1.PNG"

            width: parent.width
            height: parent.height
        }

        Image {
            id: item_menu_button_icon
            source: "qrc:/img/start_off.PNG"

            width: parent.width * 0.55
            height: width

            x: item_menu_button_image.width * 0.23
            y: item_menu_button_image.height * 0.205
        }

        NumberAnimation{
            id: item_menu_show_anim
            target: item_menu_button
            property: "x"
            duration: 100;
            easing.type: Easing.InOutQuad;

            from: -item_menu_button.width
            to: 0
        }

        NumberAnimation {
            id: item_menu_hide_anim
            target: item_menu_button
            property: "x"
            duration: 100;
            easing.type: Easing.InOutQuad;

            from: 0
            to: -item_menu_button.width
        }

        MouseArea {
            width: parent.width
            height: parent.height

            onClicked: {
                if(item_menu.visible)
                    item_menu.visible = false;
                else
                {
                    if(!quest_menu.visible)
                    {
                        item_menu.visible = true;
                        anim_item_menu.start();
                        item_menu_hide_anim.start();
                    }

//                    item_menu_button_icon.source = "qrc:/img/start_off.PNG";
                }

            }

            onPressed: {
                item_menu_button_icon.source = "qrc:/img/start_off.PNG";
            }
        }
    }





    // ==== МЕНЮ ПАУЗЫ ====
    // прямоугольник главного меню квеста (который выпадает при Esc)
    Rectangle
    {
        id: quest_menu

        // потому что находится и выпадает сверху
        //        y: -height

        width: container.width
        height: container.height

        // opacity: 0.9
        color: "transparent"

        visible: false

        z: 540

        Rectangle {
            id: pause_rectangle
            width: quest_menu.width
            height: quest_menu.height

            color: "black"

            opacity: 0

            MouseArea {
                width: parent.width
                height: parent.height

                onClicked: {}
            }
        }

        Image {
            id: pause_back_img
            width: parent.width * 0.33
            height: quest_menu.height

            x: parent.width * 0.33

            source: "qrc:/img/pause_back.png"




            Column {

                spacing: 5

                width: parent.width

                y:  parent.height * 0.3 +
                    (parent.height * 2 * 0.3 - height) / 2


                MenuButton {
                    id: start_button

                    button_text: qsTr("Start")

                    width: parent.width * 0.7
                    height: stories_listview.height / 6

                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        width: parent.width
                        height: parent.height

                        onClicked:
                        {
                            QuestJs.startQuest();
                            quest_menu.visible = false;
                            pause_show_anim.start();
                            item_menu_show_anim.start();

                            //                            this/
                            this.button_image.source = "qrc:/img/button_off.PNG"
                        }

                        onPressed: {
                            //                            button_image.source = "qrc:/img/button_on.PNG"
                        }
                    }
                }

                MenuButton {
                    id: main_menu_button

                    button_text: qsTr("Main menu")

                    width: parent.width * 0.7
                    height: stories_listview.height / 6

                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        width: parent.width
                        height: parent.height

                        //                        hoverEnabled: true

                        onClicked:
                        {
                            QuestJs.clearGame();
                            stories_view.visible = true;
                            quest_menu.visible = false;

                            quest_json = "";

                            pause_show_anim.start();
                            item_menu_show_anim.start();

                            //                            button_image.source = "qrc:/img/button_off.PNG"

                        }

                        onPressed: {
                            //                            button_image.source = "qrc:/img/button_on.PNG"
                        }
                    }
                }

                MenuButton {
                    id: next_button

                    button_text: qsTr("Next")

                    visible: false

                    MouseArea {
                        width: parent.width
                        height: parent.height

                        hoverEnabled: true

                        onClicked: {QuestJs.nextQuest();}
                        onEntered: parent.border.color = "green"
                        onExited: parent.border.color = "blue"

                    }
                }
            }





        }

        Text{
            id: episode_title
            font.pixelSize: 28

            color: "white"

            y: (container.height * (1/3)) / 2
            x: container.width / 2 - width / 2

            style: Text.Raised; styleColor: "#AAAAAA"
        }

        // анимация падения
        NumberAnimation {
            target: pause_rectangle;
            property: "opacity"
            id: anim;
            from: 0;
            to: 0.5;
            duration: 450;
            // собственно характер выпадания определяется
            // этой курвой
            easing.type: Easing.OutExpo
        }
    }

    // ==== БОКОВОЕ МЕНЮ ====
    // боковое меню, в котором отбражается список предметов,
    // которые надо найти
    Rectangle
    {
        id: item_menu

        x: -width
        z: 520

        width: 100
        height: container.height

        opacity: 0.9
        color: "#ccc"

        visible: false

        anchors.left: container.left

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

        MouseArea
        {
            width: parent.width
            height: parent.height

            onClicked: {
                item_menu.visible = false;
                item_menu_show_anim.start();
            }
        }
    }


    // ==== ПРОМЕЖУТОЧНЫЙ ЭКРАН ====
    // черный экран описания акта/сцены
    Rectangle{
        id: info_view

//        property string bg_path: ""

        width: parent.width
        height: parent.height

        color: "transparent"

        visible: false

        z: 530


        Image {
            id: fiction_background

            x: -parent.width * 0.1
            y: -parent.height * 0.1 + fiction_flickable.visibleArea.yPosition * (parent.height * 0.05)

            width: parent.width + parent.width * 0.2
            height: parent.height + parent.height * 0.2

            source: story_cover.source // todo: может надо переделать

            effect: Blur {
                blurRadius: 10
            }
            Rectangle {
                width: fiction_background.width
                height: fiction_background.height

                color: "black"
                opacity: 0.5

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {}
                }
            }
        }

        Rectangle
        {
            id: progress_bar

            x: fiction_flickable.x
            y: (container.height - fiction_flickable.height) / 4

            width: fiction_flickable.width
            height: 5

            color: "black"
        }

        Rectangle {
            id: skip_button

            width: height
            height: play_button.height * 0.7

            x: parent.width //  - width
            y: 0

            color: "transparent";

            Image {
                id: skip_button_image
                source: "qrc:/img/back_for_button_2.PNG"

                width: parent.width
                height: parent.height
            }

            Image {
                id: skip_button_arrow
                source: "qrc:/img/start_off.PNG"

                width: parent.width * 0.55
                height: width

                x: skip_button_image.width * 0.22
                y: skip_button_image.height * 0.205
            }

            MouseArea {
                width: parent.width
                height: parent.height

                onClicked: {
                    QuestJs.skip();
                    skip_button_arrow.source = "qrc:/img/start_off.PNG";
                }

                onPressed: {
                    skip_button_arrow.source = "qrc:/img/start_on.PNG";
                }
            }

            NumberAnimation{
                id: skip_show_anim
                target: skip_button
                property: "x"
                duration: 100;
                easing.type: Easing.InOutQuad;

                from: container.width
                to: container.width - skip_button.width
            }

//            NumberAnimation {
//                id: skip_hide_anim
//                target: skip_button
//                property: "x"
//                duration: 100;
//                easing.type: Easing.InOutQuad;

//                from: container.width - skip_button.width
//                to: container.width
//            }
        }


        Timer {
            id: timer_animation_show
            interval: 2000
            repeat: true
            onTriggered: {console.log("LL");QuestJs.infoShown();}
        }

        Flickable {

            id: fiction_flickable

            onMovementEnded: {
                if((visibleArea.heightRatio + visibleArea.yPosition) > 0.9)
                    QuestJs.showSkipButton();
            }

            opacity: 0

            width: parent.width * 0.8
            height: 100 // (width / 16) * 9 // parent.height

            anchors.centerIn: parent

            contentWidth: width
            contentHeight: fiction_text.height

            x: skip_button.width
//            boundsBehavior: Flickable.DragOverBounds
            clip: true

            Text {
                id: fiction_text
                text: ""

                width: parent.width
//                height: parent.height

                wrapMode: Text.WordWrap

                font.pixelSize: 14

                color: "white"
            }

            NumberAnimation on opacity {
                id: anim_fiction_text_show;
                from: 0; to: 1;
                duration: 1000;
                easing.type: Easing.Linear
            }
            NumberAnimation on opacity {
                id: anim_fiction_text_hide;
                from: 1; to: 0;
                duration: 1000;
                easing.type: Easing.Linear
            }
        }

        Text{
            id: info_text
            color: "white"

            font.pointSize: 24

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            style: Text.Raised; styleColor: "#AAAAAA"

            NumberAnimation on opacity {
                id: anim_info_text_show;
                from: 0; to: 1;
                duration: 1000;
                easing.type: Easing.Linear
            }
            NumberAnimation on opacity {
                id: anim_info_text_hide;
                from: 1; to: 0;
                duration: 1000;
                easing.type: Easing.Linear
            }
        }
    }


    // ==== ОКНО ПРЕДМЕТА ====
    // окно, которое показывается когда игрок находит предмет
    Rectangle{
        id: item_window

        color: "transparent"
        smooth: true

        visible: false

        property real koef: 0.0

        z: 510

        Image {
            width: parent.width
            height: parent.height

            id: item_image
            source: ""

            smooth: true
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

                x: container.width / 2 - item_image.width / 2
                y: container.height / 2 - item_image.height / 2

                width: container.width * 0.2
                height: width * koef
            }
        }

        transitions: Transition {
            from: ""; to: "show_in_center";
            NumberAnimation { properties: "x,y,width,height"; duration: 300; easing.type: Easing.InOutBack  }
        }
    }

    /// ==== ГЛАВНОЕ МЕНЮ ====
    Rectangle {
        id: stories_view

        color: "black"

        width: parent.width
        height: parent.height

        z: 550
        property string mode: "stories"
        property string path_story_id: ""
        property string path_episode_id: ""
        property string path: path_story_id +
                              path_separator +
                              path_episode_id

        function back() {
            path_story_id = ""
            path_episode_id = ""
            story_cover.img_file_name = ""
            stories_view.mode = "stories";
            QuestJs.initStoriesMenu();
        }

        Image {
            property string img_file_name: ""

            x:0
            y:0

            width: stories_view.width - stories_listview.width
            height: parent.height * 0.8 // - play_button.height


            id: story_cover

            //            visible: false

            source: server_name +
                    path_separator +
                    stories_view.path +
                    path_separator +
                    img_file_name;


            /// вставить текст!!!
            /// НАЗВАНИЕ ЭПИЗОДА
            /// описание эпизода

            // текст названия и описания
            // находятся на изображении -
            // потому что легче выставлять якоря

            // НАЗВАНИЕ
            Text {
                id: text_title

                width: parent.width

                font.family: "Arial"
                font.pixelSize: parent.height * 0.2

                style: Text.Raised; styleColor: "#AAAAAA"

                wrapMode: Text.WordWrap

                color: "white"

                anchors.bottom: text_description.top

                text: ""
            }

            // ОПИСАНИЕ
            Text {
                id: text_description

                width: parent.width
                height: (font.pixelSize + 2) * 3

                font.family: "Arial"
                font.pixelSize: 12

                style: Text.Raised; styleColor: "#AAAAAA"
                wrapMode: Text.WordWrap

                color: "white"

                anchors.bottom: parent.bottom

                text: ""
            }
        }

        Image {

            // НИЖНЯЯ КАРТИНКА В МЕНЮ
            id: menu_bottom_img
            source: "qrc:/img/menu_bottom.png"


            // сначала узнаем ее ЧИСТЫЙ размер -
            // вся высота минус высота cover
            property int real_height: parent.height - story_cover.height
            // а это коэффициент, определяющий
            // на сколько выступают прозрачные куски
            property real koef: 0.33
            width: story_cover.width
            height: real_height + real_height * koef
            y: story_cover.height - real_height * koef
        }

        Component {
            id: contactDelegate
            Rectangle {
                width: stories_listview.width
                height: stories_listview.height / 6

                Image {
                    id: delegate_image
                    source: (stories_listview.currentIndex != index)?"qrc:/img/button_off.PNG":"qrc:/img/button_on.PNG"

                    width: parent.width * 0.85
                    height: parent.height

                    anchors.right: parent.right
                    anchors.rightMargin: 3 // (parent.width - parent.width) / 2
                }


                color: "transparent"
                //                color: ListView.isCurrentItem ? "blue" : "green"
                //                radius: 5
                //                border.color: "white"
                //                border.width: 3

                property string story_id: id
                property string story_cover_id: cover

                property string story_title_text: title
                property string story_description_text: description

                Text {
                    text: title
                    //                    color: (stories_listview.currentIndex == index)?"#A1A1A1":"white"
                    color: "white"
//                    font.bold: true
                    anchors.verticalCenter: delegate_image.verticalCenter
                    anchors.horizontalCenter: delegate_image.horizontalCenter
                }

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        stories_listview.currentIndex = index;
                    }
                }
            }
        }




        ListModel {
            id: stories_model
        }

        ListView {
            id: stories_listview

            width: parent.width * 0.3
            height: parent.height - play_button.height
            anchors.right: parent.right
            model: stories_model
            delegate: contactDelegate
            //            highlight: Rectangle { color: "lightsteelblue"; }//radius: 5 }
            //            spacing: 0

            onCurrentIndexChanged: {

                // устанавливаем путь к обложке (истории или эпизода)
                if(stories_view.mode === "stories")
                    stories_view.path_story_id = currentItem.story_id;
                else if(stories_view.mode === "episodes")
                    stories_view.path_episode_id = currentItem.story_id;

                // имя файла обложки
                // todo: неплохо бы было универсиализировать имя файла
                //       обложки типа cover.jpg
                story_cover.img_file_name = currentItem.story_cover_id;


                // надо несколько урезать размер картинки,
                // чтобы вписывалась в концепцию -
                // справа - упирается в список
                // снизу - в кнопку Play
//                story_cover.width =
//                        stories_view.width - stories_listview.width;

//                story_cover.height =
                        //stories_view.height - play_button.height;
//                        parent.height * 0.8

                console.log("stories cover "
                            + story_cover.source)


                // выставляем текст названия и текст описания
                text_title.text =
                        currentItem.story_title_text;

                text_description.text =
                        currentItem.story_description_text;
            }

            Image {
                id: menu_back
                source: "qrc:/img/menu_back.png"

                width: stories_listview.width
                height: container.height

                anchors.right: parent.right

                z: -10000
            }
        }



        // кнопка PLAY!!!
        Rectangle {
            id: play_button

            width: stories_listview.width * 0.85
            height: width * 0.67

            x: parent.width - width
            y: parent.height - height

            color: "transparent";
            //            radius: 5
            Text {
                text: "Play!"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: play_button_image
                source: "qrc:/img/back_for_button_start.PNG"

                width: parent.width
                height: parent.width * 0.67 // dirty hack...

                Image {
                    id: play_button_arrow
                    source: "qrc:/img/start_off.PNG"

                    width: parent.width * 0.4
                    height: width

                    x: (parent.width - width) / 2
                    y: parent.height * 0.195

                    MouseArea {
                        width: parent.width
                        height: parent.height

                        onClicked: {
                            if(stories_view.mode === "stories")
                            {
                                episodes_json = ""
                                container.getStoryManifest(stories_view.path)
                            }
                            else if(stories_view.mode === "episodes")
                            {
                                QuestJs.getQuest();
                            }

                            parent.source = "qrc:/img/start_off.PNG"
                        }

                        onPressed: {
                            parent.source = "qrc:/img/start_on.PNG"
                        }
                    }
                }
            }
        }

        Rectangle {
            id: back_button

            width: height
            height: menu_bottom_img.height * 0.7

            x: 0
//            y: story_cover.height + (container.height - story_cover.height - height) / 2
            y: menu_bottom_img.y + menu_bottom_img.height * 0.25


            visible: (stories_view.mode === "episodes")

            color: "transparent"

            onVisibleChanged: {
                if(visible === true)
                    back_button_show_anim.start();
            }

            NumberAnimation {
                id: back_button_show_anim
                target: back_button;
                property: "x";
                duration: 100;
                easing.type: Easing.InOutQuad
                from: -width
                to: 0
            }

            NumberAnimation {
                id: back_button_hide_anim
                target: back_button;
                property: "x";
                duration: 100;
                easing.type: Easing.InOutQuad
                from: 0
                to: -width
            }

            Image {
                id: back_button_image
                source: "qrc:/img/back_for_button_1.PNG"

                width: parent.width
                height: parent.height

//                rotation: 180
            }

            Image {
                id: back_button_arrow
                source: "qrc:/img/button_back_off.PNG"

                width: parent.width * 0.55
                height: width

                x: back_button_image.width * 0.23
                y: back_button_image.height * 0.2
            }

            //            Text {
            //                text: "back"
            //                color: "white"
            //                anchors.verticalCenter: parent.verticalCenter
            //                anchors.horizontalCenter: parent.horizontalCenter
            //            }

            MouseArea {
                width: parent.width
                height: parent.height

                onClicked: {
                    //                    if(stories_view.mode === "stories")
                    //                        container.getStoryManifest(stories_view.path)
                    if(stories_view.mode === "episodes")
                    {
                        stories_view.back();
                    }

                    back_button_arrow.source = "qrc:/img/button_back_off.PNG";
                }

                onPressed: {
                    back_button_arrow.source = "qrc:/img/button_back_on.PNG";
                }
            }
        }
    }

    signal getStoryManifest(string story_id)
    signal getEpisodeData(string path)
}
