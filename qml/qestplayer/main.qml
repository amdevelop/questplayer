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

    property bool direct_start: false
    property bool direct_start_flag: false

    property int show_load_indicator: 0

    onStories_jsonChanged:
    {
        QuestJs.initStoriesMenu();
    }

    onQuest_jsonChanged:
    {
        startNewGame();
    }

    onDirect_start_flagChanged:
    {
        if(direct_start_flag)
        {
            startNewGame();

            direct_start_flag = false;
            direct_start = true;
        }
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

    function startNewGame()
    {
        QuestJs.quest_path = server_name +
                path_separator +
                stories_view.path;

        QuestJs.initQuest(stories_view.path_episode_id);

        stories_view.visible = false;

        tryToStart();
    }

    function tryToStart()
    {
        if(show_load_indicator > 0)
        {
            show_load_indicator--;

            if(show_load_indicator == 0)
                QuestJs.startQuest();
        }
    }

    function loadImage()
    {
        QuestJs.loadImage();
    }


    Rectangle {
        id: load_indicator

        color: "black"
        anchors.fill: parent
        z: 1000

        visible: show_load_indicator != 0


        AnimatedImage {
            anchors.centerIn: parent

            source: "qrc:/img/320.GIF"

            playing: parent.visible
        }
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
        height: container.height * 0.2

        x: parent.width - width - 10
        y: 5

        z: 300

        color: "transparent";

        Image {
            id: pause_button_icon
            source: "qrc:/img/pause_button.PNG"

            width: parent.width
            height: width

            opacity: 0.5
            smooth: true
        }

        NumberAnimation{
            id: pause_show_anim
            target: pause_button
            property: "x"
            duration: 100;
            easing.type: Easing.InOutQuad;

            from: container.width
            to: container.width - pause_button.width - 10
        }

        NumberAnimation {
            id: pause_hide_anim
            target: pause_button
            property: "x"
            duration: 100;
            easing.type: Easing.InOutQuad;

            from: container.width - pause_button.width - 10
            to: container.width
        }

        MouseArea {
            width: parent.width
            height: parent.height

            onClicked: {
//                if(quest_menu.visible === true)
//                    quest_menu.visible = false;
//                else
//                {
                item_menu.visible = false;

                quest_menu.visible = true;
                anim.start();
                pause_hide_anim.start();
                item_menu_hide_anim.start();

                timer_scene_progress.stop();
                //                }
            }
        }
    }

    Rectangle {
        id: item_menu_button

        width: height * 0.3
        height: container.height * 0.2

        x: 0 // parent.width - width
        y: container.height / 2 - height / 2
        z: item_menu.z + 1

        color: "gray";

        opacity: 0.5

        Image {
            id: item_menu_button_icon
            source: "qrc:/img/arrow_fwd.PNG"

            anchors.fill: parent
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
                }
            }
        }
    }



    Rectangle {
        id: scene_time

        anchors.top: pause_button.bottom
        anchors.horizontalCenter: pause_button.horizontalCenter

        width: text_minutes.width + text_points.width + text_seconds.width
        height: text_minutes.height

        color: "transparent"

        property int m_value: 0

        Text {
            property int m_value: (parent.m_value - parent.m_value % 60) / 60
            property string m_value_str: m_value.toString()

            id: text_minutes
            anchors.left: parent.left
            color: "white"
            font.pixelSize: 30

            text: (m_value === 0)?"00":(m_value_str.length == 1)?("0" + m_value_str):m_value_str
        }

        Text {
            id: text_points
            text: ":"
            anchors.left: text_minutes.right
            color: "white"
            font.pixelSize: 30
        }

        Text {
            property int m_value: parent.m_value % 60
            property string m_value_str: m_value.toString()

            id: text_seconds
            anchors.left: text_points.right
            color: "white"
            font.pixelSize: 30

            text: (m_value === 0)?"00":(m_value_str.length == 1)?("0" + m_value_str):m_value_str
        }
    }


    Timer {
        id: timer_scene_progress

        interval: 1000
        repeat: true

        onTriggered: {
            QuestJs.updateSceneTimer();
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

        Column {

            spacing: 5

            width: parent.width * 0.33

            anchors.centerIn: parent

            MenuButton {
                id: resume_button

                button_text: qsTr("Resume")

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        QuestJs.startQuest();
                        quest_menu.visible = false;
                        pause_show_anim.start();
                        item_menu_show_anim.start();

                        timer_scene_progress.start();
                    }
                }
            }

            MenuButton {
                id: restart_button

                button_text: qsTr("Restart")

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        QuestJs.startQuest();
                        quest_menu.visible = false;
                        pause_show_anim.start();
                        item_menu_show_anim.start();
                    }
                }
            }

            MenuButton {
                id: main_menu_button

                button_text: qsTr("Main menu")

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked:
                    {
                        QuestJs.clearGame();
                        stories_view.visible = true;
                        quest_menu.visible = false;

                        quest_json = "";

                        pause_show_anim.start();
                        item_menu_show_anim.start();
                    }
                }
            }

            MenuButton {
                id: next_button

                button_text: qsTr("Next")

                visible: true

                MouseArea {
                    width: parent.width
                    height: parent.height

                    hoverEnabled: true

                    onClicked: {
                        pause_show_anim.start();
                        item_menu_show_anim.start();

                        QuestJs.nextQuest();
                    }
                }
            }
        }

        Text{
            id: episode_title
            font.pixelSize: 24

            wrapMode: Text.WordWrap

            color: "white"

            y: (container.height * (1/3)) / 2
            x: container.width / 2 - width / 2

            width: pause_back_img.width
            horizontalAlignment: Text.AlignHCenter

            style: Text.Raised; styleColor: "#AAAAAA"
        }

        // анимация появления
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
        height: container.height - container.height * 0.1

        opacity: 0.8
        color: "#ccc"

        visible: false

        anchors.left: container.left
        anchors.verticalCenter: container.verticalCenter

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

            source: story_cover.source

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

        Rectangle {
            id: top_area_rect_1

            height: parent.height * 0.2
            width: parent.width

            anchors.top: parent.top

            color: "transparent"

            Rectangle {
                id: skip_button

                width: height
                height: top_area_rect_1.height * 0.7

                x: parent.width //  - width

                anchors.verticalCenter: parent.verticalCenter

                color: "transparent";

                Image {
                    id: skip_button_arrow

                    source: "qrc:/img/play_white.PNG"

                    anchors.fill: parent

                    opacity: 0.5
                }

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        QuestJs.skip();
                    }
                }

                NumberAnimation{
                    id: skip_show_anim
                    target: skip_button
                    property: "x"
                    duration: 100;
                    easing.type: Easing.InOutQuad;

                    from: container.width
                    to: container.width - (skip_button.width + (top_area_rect_1.height - skip_button.height) / 2)
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

        Timer {
            id: timer_animation_show
            interval: 2000
            repeat: true
            onTriggered: {console.log("LL");QuestJs.infoShown();}
        }

        Text {
            id: fiction_text_preview
            text: ""

            width: parent.width * 0.8

            anchors.centerIn: parent

            wrapMode: Text.WordWrap

            font.pixelSize: 14

            color: "white"

            textFormat: Text.RichText

            onLinkActivated: {
                fiction_text_preview.visible = false;
                fiction_flickable.visible = false;
                fiction_flickable.visible = true;
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


        Flickable {
            id: fiction_flickable

            visible: false

            onMovementEnded: {
                //                if((visibleArea.heightRatio + visibleArea.yPosition) > 0.9)
                //                    QuestJs.showSkipButton();
            }

            onVisibleChanged: {
                if(visible == true)
                {
                    anim_fiction_flickable_move.start();
                    anim_fiction_flickable_expand.start();
                }
            }

            width: parent.width * 0.8
            height: fiction_text_preview.height

            anchors.centerIn: parent

            contentWidth: width
            contentHeight: fiction_text.height

            x: fiction_text_preview.x
            y: fiction_text_preview.y

            NumberAnimation on y {
                id: anim_fiction_flickable_move;
                from: fiction_text_preview.y;
                to: (container.height - container.height * 0.6) / 2;
                duration: 500;
                easing.type: Easing.InExpo
            }

            NumberAnimation on height {
                id: anim_fiction_flickable_expand;
                from: fiction_text_preview.height;
                to: container.height * 0.6;
                duration: 100;
                easing.type: Easing.Linear
            }


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
            id: menu_background

            source: "qrc:/img/background.PNG"

            width: parent.width
            height: parent.height
        }

        Flickable {
            id : cover_flick

            width: stories_view.width  // - stories_listview.width
            height: stories_view.height // parent.height * 0.8 // - play_button.height
            clip: true

            contentWidth: story_cover.width;
            contentHeight: story_cover.height

            boundsBehavior: Flickable.StopAtBounds

            Image {
                property string img_file_name: ""

                width: container.width // stories_view.width - stories_listview.width
                height: container.height  // * 0.8 // - play_button.height

                id: story_cover

                onStatusChanged: {
                    if(status == Image.Loading)
                        menu_image_loader.visible = true;
                    else if(status == Image.Ready)
                    {
                        menu_image_loader.visible = false;

                        tryToStart();
                    }
                }

                source: server_name +
                        path_separator +
                        stories_view.path +
                        path_separator +
                        img_file_name;
            }
        }

        AnimatedImage {
            id: menu_image_loader
            source: "qrc:/img/712.GIF"
            playing: visible

            y: (top_area_rect.height + (container.height - (top_area_rect.height + social_rect.height + text_description.height + text_title.height)) / 2) - height / 2
            x: (container.width - stories_listview.width) / 2 - width / 2
        }

        Rectangle {
            id: top_area_rect

            height: parent.height * 0.2
            width: parent.width

            anchors.top: parent.top

            color: "transparent"

            Rectangle {
                id: back_button

                width: height
                height: top_area_rect.height * 0.7

                anchors.verticalCenter: parent.verticalCenter

                z: play_button_design.z + 1

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
                    to: (top_area_rect.height - back_button.height) / 2
                }

                NumberAnimation {
                    id: back_button_hide_anim
                    target: back_button;
                    property: "x";
                    duration: 100;
                    easing.type: Easing.InOutQuad
                    from: (top_area_rect.height - back_button.height) / 2
                    to: -width
                }

                Image {
                    id: back_button_image
                    source: "qrc:/img/back_white.PNG"

                    width: parent.width
                    height: parent.height

                    opacity: 0.5
                }

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        if(stories_view.mode === "episodes")
                        {
                            stories_view.back();
                        }
                    }
                }
            }
        }

        Rectangle {
            id: social_rect

            height: parent.height * 0.2
            width: parent.width

            anchors.bottom: parent.bottom

            color: "transparent"

            Row
            {
                spacing: 10
                x: 10

                anchors.verticalCenter: parent.verticalCenter

                FbShare {
                    id: fb_share
                }

                TwShare {
                    id: tw_share
                }
            }

            Image {
                id: play_button_design
                source: "qrc:/img/play_white.PNG"

                width: height
                height: social_rect.height * 0.9

                anchors.verticalCenter: parent.verticalCenter

                x: parent.width - stories_listview.width / 2 - width / 2

                opacity: 0.5
                smooth: true

                MouseArea {
                    width: parent.width
                    height: parent.height

                    onClicked: {
                        if(stories_view.mode === "stories")
                        {
                            menu_image_loader.visible = true;

                            episodes_json = ""
                            container.getStoryManifest(stories_view.path)
                        }
                        else if(stories_view.mode === "episodes")
                        {
                            QuestJs.getQuest();
                        }
                    }

                    onPressed: {
                        parent.opacity = 0.9
                    }

                    onReleased: {
                        parent.opacity = 0.7
                    }
                }
            }
        }

        // НАЗВАНИЕ
        Text {
            id: text_title

            width: cover_flick.width - stories_listview.width

            font.family: "Arial"
            font.pixelSize: 46 // parent.height * 0.2

            style: Text.Raised; styleColor: "#AAAAAA"

            wrapMode: Text.WordWrap

            color: "white"

            anchors.bottom: text_description.top

            text: ""
        }

        // ОПИСАНИЕ
        Text {
            id: text_description

            width: cover_flick.width - stories_listview.width

            font.family: "Arial"
            font.pixelSize: 12

            style: Text.Raised; styleColor: "#AAAAAA"
            wrapMode: Text.WordWrap

            color: "white"

            anchors.bottom: social_rect.top

            text: ""
        }

        Component {
            id: contactDelegate
            Rectangle {
                width: stories_listview.width
                height: stories_listview.height / 6

                Image {
                    id: delegate_image

                    width: parent.width * 0.85
                    height: parent.height

                    anchors.right: parent.right
                    anchors.rightMargin: 3 // (parent.width - parent.width) / 2
                }

                color: "transparent"

                property string story_id: id
                property string story_cover_id: cover

                property string story_title_text: title
                property string story_description_text: description

                Rectangle {

                    id: delegate_rect

                    height: parent.height - 10
                    width: parent.width

                    anchors.centerIn: parent.Center

                    color: "white"

                    opacity: (stories_listview.currentIndex == index)?0.7:0.5

                    radius: 3


                    MouseArea {
                        width: parent.width
                        height: parent.height

                        onClicked: {
                            stories_listview.currentIndex = index;
                        }
                    }
                }

                Text {
                    text: title
                    //                    color: (stories_listview.currentIndex == index)?"#A1A1A1":"white"
                    color: "white"
                    //                    font.bold: true
                    anchors.verticalCenter: delegate_rect.verticalCenter
                    anchors.horizontalCenter: delegate_rect.horizontalCenter
                }

            }
        }

        ListModel {
            id: stories_model
        }

        ListView {
            id: stories_listview

            clip: true

            width: parent.width * 0.3
            height: parent.height * 0.8 // - play_button.height
            anchors.right: parent.right
            model: stories_model
            delegate: contactDelegate

            visible: (count > 1)

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
        }
    }

    signal getStoryManifest(string story_id)
    signal getEpisodeData(string path)
}
