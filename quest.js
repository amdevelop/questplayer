var quest_data;

//var quest_data =
//        { "episode" :
//    { "acts" :
//            [
//            { "scenes" :
//                    [
//                    {   "id" : 0,
//                        "background" : "test.jpg",
//                        "in_effect" : null,
//                        "items" : [
//                            {
//                                "detail": "",
//                                "polygon" :
//                                    [
//                                    [ 60, 106 ],
//                                    [ 79, 26 ],
//                                    [ 160, 33 ],
//                                    [ 149, 132 ] ],
//                                "title" : "item1" },
//                            {
//                                "detail": "",
//                                "polygon" :
//                                    [
//                                    [ 179, 176 ],
//                                    [ 181, 116 ],
//                                    [ 277, 116 ],
//                                    [ 275, 177 ] ],
//                                "title" : "item2" } ],
//                        "order" : null,
//                        "out_effect" : null,
//                        "title" : "Scene 1" },
//                    {   "id" : 1,
//                        "background" : "test.jpg",
//                        "in_effect" : null,
//                        "items" : [
//                            {
//                                "detail": "",
//                                "polygon" :
//                                    [
//                                    [ 60, 106 ],
//                                    [ 79, 26 ],
//                                    [ 160, 33 ],
//                                    [ 149, 132 ] ],
//                                "title" : "item1" },
//                            {
//                                "detail": "",
//                                "polygon" :
//                                    [
//                                    [ 179, 176 ],
//                                    [ 181, 116 ],
//                                    [ 277, 116 ],
//                                    [ 275, 177 ] ],
//                                "title" : "item2" } ],
//                        "order" : null,
//                        "out_effect" : null,
//                        "title" : "Scene 2" }],
//                "title" : "Act 1" } ],

//        "id" : 0,
//        "cover" : "detective.jpg",
//        "title" : "Episode 1" } };

// constants
var subject_z = 100
var interior_z = 200

//var quest_path = "file:quest";
var quest_path =  ""; // "http://quest:8888/quests/";

var current_act = null;
var current_scene = null;
var act_counter = 0;
var act_scene_counter = 0;

var scene_items = [];
var scene_item_map = {};
var scene_interior_list = [];
var scene_images_count = 0;
var scene_images_load = 0;

var scene_progress_rect_list = [];
var can_show_skip = false;

var info_show_type = "";

var all_episode_count = -1;
var current_episode_count = -1;

var scene_timer = 0;

var activity_stack = [];

function initQuest(current_number)
{
    current_episode_count = current_number;
    console.log("current_episode_count ", current_episode_count);

    quest_data = JSON.parse(container.quest_json);

    if(quest_data.episode.title !== null)
        episode_title.text = quest_data.episode.title;
    else
        episode_title.text = "Episode";
}

function startQuest() {

    next_button.visible = false;
    resume_button.visible = true;
    restart_button.visible = false;

    if(current_act == null)
    {
        container.showAd();
        nextAct();
    }
}

function clearScene()
{
    var i;
    for(i = 0; i < scene_items.length; i++)
        scene_items[i].destroy();

    for(i = 0; i < scene_interior_list.length; i++)
        scene_interior_list[i].destroy();

    for(i = 0; i < scene_progress_rect_list.length; i++)
        scene_progress_rect_list[i].destroy();

    scene_items = [];
    scene_item_map = {};
    scene_interior_list = [];

    scene_progress_rect_list = [];

    fiction_text.text = "";
    fiction_text_preview.text = "";

    timer_scene_progress.stop();
    scene_time.m_value = 0;
}

function clearGame()
{
    current_act = null;
    current_scene = null;
    act_counter = 0;
    act_scene_counter = 0;

    clearScene();

    info_show_type = "";
}

function gameOver()
{
    clearGame();

    quest_menu.visible = true;
    anim.start();

    var tmp_episode = parseInt(current_episode_count, 10);
    console.log("compare ", (tmp_episode + 1), all_episode_count)

    next_button.visible = true;
    resume_button.visible = false;
    restart_button.visible = true;

    pause_hide_anim.start();
    item_menu_hide_anim.start();
    if(item_menu.visible == true)
        item_menu.visible = false;

}

function infoShown()
{
    if(info_show_type === "act_begin")
    {
        info_show_type = "act_end";
        anim_info_text_hide.start();
    }
    else if(info_show_type === "act_end")
    {
        nextScene();
    }
    else if(info_show_type === "scene_begin")
    {
        info_show_type = "scene_end";

        timer_animation_show.stop();
    }
    else if(info_show_type === "scene_end")
    {
        timer_animation_show.stop();

        fiction_flickable.visible = false;

        info_view.visible = false;

        timer_scene_progress.start();

        //anim_background_expand.start();
    }
}

function skip()
{
    if(info_show_type === "act_begin")
    {
        info_show_type = "act_end";
        timer_animation_show.stop();
        anim_info_text_show.stop();

        info_text.opacity = 1.0;
        timer_animation_show.start();
    }
    else if(info_show_type === "act_end")
    {
        info_show_type = "act_end";
        timer_animation_show.stop();
        anim_info_text_hide.stop();

        info_text.opacity = 1.0;
        timer_animation_show.start();
    }
    else if(info_show_type === "scene_begin")
    {
        info_show_type = "scene_end";
        anim_info_text_show.stop();
    }
    else if(info_show_type === "scene_end")
    {
        info_show_type = "scene_end";
        anim_info_text_hide.stop();
    }

    infoShown();
}

function updateSceneTimer()
{
    scene_time.m_value++;
}

function nextAct()
{
    if(act_counter + 1 <= quest_data.episode.acts.length)
    {
        current_act = quest_data.episode.acts[act_counter];

        if(act_scene_counter + 1 <= current_act.scenes.length)
        { 
            clearScene();
            current_scene = current_act.scenes[act_scene_counter];
            drawScene();
        }

        if(current_act.title !== "" ||
                current_act.title !== null)
        {
            info_view.visible = true;
            info_show_type = "act_begin";
            if(current_act.title !== null)
                info_text.text = current_act.title;
            else
                info_text.text = "Act";
            anim_info_text_show.start();
            timer_animation_show.start();
        }

        act_counter++;
    }
    else
        gameOver();
}

function nextScene()
{
    if(act_scene_counter + 1 <= current_act.scenes.length)
    {
        info_show_type = "scene_begin";

        if(current_scene.description != null &&
                current_scene.description !== "")
        {
//            fiction_text.text = current_scene.description;

//            var test_text = "Стоянка перед мотелем была заполнена автомобилями. В другой день владелец мотеля был бы рад такому наплыву клиентов, но не сегодня - от такого количества полицейских машин любому станет не по себе.___PREWIEW_MARKER___Среди нескольких служебных автомобилей Клиффард разглядел серый седан Джайны. Одинаковые, с облупившейся краской двери номеров мотеля были закрыты, кроме одной, возле которой было выставлено ограждение и охрана. - вот и доброе утро... - пробормотал Клиффард. Он подошел к желтой заградительной ленте и показал жетон.";
            var test_text = current_scene.description;
            var text_array = test_text.split("___PREWIEW_MARKER___");

            var description = text_array[0];

            if(text_array.length > 1)
            {
                if(description[description.length - 1] === ".")
                    description = description.substring(0, description.length - 1);

                description += "... <br> <a href=\"read_more\">read more</a>"
                fiction_text.text = text_array.join();
            }

            fiction_flickable.visible = false;
            fiction_text_preview.text = description;

            fiction_text_preview.opacity = 0;
            if(!fiction_text_preview.visible)
                fiction_text_preview.visible = true;

            anim_fiction_text_show.start();

            showSkipButton();

            // эта проверка на случай, если не надо прокручивать
            // рассказ
//            if((fiction_flickable.visibleArea.heightRatio +
//                fiction_flickable.visibleArea.yPosition) > 0.9)
//                showSkipButton();
        }
        else
        {
            if(current_scene.title != null &&
                    current_scene.title !== "")
                info_text.text = current_scene.title;
            else
                info_text.text = "Scene";

            anim_info_text_show.start();

            showSkipButton();
        }

        if(timer_animation_show.running !== true)
            timer_animation_show.start();
    }
    else
        nextAct();
}

function loadImage()
{
    var progress_rect = Qt.createQmlObject(
                'import QtQuick 1.1; Rectangle {}',
                progress_bar,
                "progress_item" + scene_images_load.toString());

    progress_rect.width = progress_bar.width / scene_images_count;
    progress_rect.height = progress_bar.height;

    progress_rect.color = "white";
    progress_rect.x = progress_rect.width * (scene_images_load);

    scene_progress_rect_list[scene_images_load] = progress_rect;

    scene_images_load++;
    if(scene_images_load == scene_images_count)
    {
        progress_bar.visible = false;
        showSkipButton();
    }
}

function showSkipButton()
{
    if(can_show_skip)
    {
        if(skip_button.visible === false)
        {
            skip_button.visible = true;
            skip_show_anim.start();
        }
    }
    else
    {
        can_show_skip = true;
    }
}

function drawScene()
{
    item_model.clear();

    var base_path =
            quest_path + container.path_separator +
            current_act.id + container.path_separator +
            current_scene.id + container.path_separator;


    if(current_scene.background !== "")
        background_image.source =
                base_path +
                current_scene.background;

    background_image.width = container.width;  // + container.width * 0.1;
    background_image.height = container.height;  // + container.width * 0.1;
//    background_image.koef = (576 / 720);
    //    background_image.height = background_image.width * (576 / 720); // container.height;

    var i;
    var item_counter = 0;

    scene_images_load = 0;
    scene_images_count = current_scene.items.length;
    skip_button.visible = false;
    can_show_skip = false;
    progress_bar.visible = true;

    for(i = 0; i < current_scene.items.length; i++)
    {
        var current_item = current_scene.items[i];

        //        console.log("LOL!");
        //        console.log(i);

        var interior_item = null;

        var component = Qt.createComponent("ItemImage.qml");

        if (component.status == Component.Ready) {

            //        interior_item = Qt.createQmlObject(
            //                    'import QtQuick 1.1; Image {onStatusChanged: { if (status == Image.Ready) QuestJs.loadImage();}}',
            //                    container,
            //                    "interior_item" + i.toString());
            interior_item = component.createObject(background_image);
        }

        interior_item.source =
                base_path +
                current_item.id + container.path_separator +
                current_item.image;



        interior_item.scene_x =
                current_item.scene_x; // * background_image.width;
        interior_item.scene_y =
                current_item.scene_y; //  * background_image.height;


        interior_item.scene_scale_x =
                current_item.scene_scale_x; //  * background_image.width;
        interior_item.scene_scale_y =
                current_item.scene_scale_y; //  * background_image.height;


        interior_item.visible = true;

        if(current_item.type === "subject")
        {
            var item_title;
            if(current_item.title === null)
                item_title = "Item";
            else
                item_title = current_item.title;

            item_model.append({ "item" : item_title, "item_color": "white"});

            var polygon_item = Qt.createQmlObject(
                        'import QuestItems 1.0; QuestPolygon {}',
                        container,
                        "quest_item" + scene_items.length.toString());

            polygon_item.polygon = current_item.polygons;

            scene_items[scene_items.length] = polygon_item;
            scene_item_map[polygon_item] = interior_item;

            if(current_item.z === null)
                interior_item.z = subject_z++;
            else
                interior_item.z = current_item.z
        }
        else
        {
            if(current_item.z === null)
                interior_item.z = subject_z++;
            else
                interior_item.z = current_item.z
        }

        scene_interior_list[scene_interior_list.length] = interior_item;
    }
}

function initalizeInterior(interior_item, current_item)
{

}

function checkScene()
{
    var found_counter = 0;
    var i = 0;

    for(i = 0; i < scene_items.length; i++)
    {
        if(scene_items[i].found)
            found_counter++;
    }

    if(found_counter == scene_items.length)
    {
        if((act_scene_counter + 1) < current_act.scenes.length)
        {
            act_scene_counter++;
            current_scene = current_act.scenes[act_scene_counter];
            clearScene();
            drawScene();
            info_view.visible = true;

            nextScene();
        }
        else
        {
         nextAct();
        }
    }
}

function checkCollisions(mouseX, mouseY)
{
    var i;
    var tmp_item = null;

    for(i = 0; i < scene_items.length; i++)
    {
        if(!scene_items[i].found)
            if(scene_items[i].contains(mouseX,
                                       mouseY,
                                       background_image.width,
                                       background_image.height))
            {
                tmp_item = scene_item_map[scene_items[i]];

                if(tmp_item)
                {
                    showDetail(tmp_item,
                               mouseX,
                               mouseY);
                }


                scene_items[i].found = true;


                item_model.get(i).item_color = "darkgray";
            }

        if(tmp_item !== null)
            if(scene_item_map[scene_items[i]] === tmp_item)
                scene_items[i].found = true;
    }
}

function showDetail(item_data, startX, startY)
{
    console.log(startX, startY)

    item_data.visible = false;

    item_image.source = item_data.source;

    item_window.width = item_data.width;
    item_window.height = item_data.height;

    var point = item_data.mapToItem(container,
                                    item_data.width / 2,
                                    item_data.height / 2);

    if(point != null)
    {
        item_window.x = point.x;
        item_window.y = point.y;
    }
    else
    {
        item_window.x = item_data.x;
        item_window.y = item_data.y;
    }

    item_window.z = 10000;

//    item_window.koef = item_data.width / item_data.height;

    item_image.visible = true;
    item_window.visible = true;
}


//////////////////////////////////////////

function initStoriesMenu()
{
    stories_model.clear();

    var stories = JSON.parse(container.stories_json);
    var i = 0;
    for(i = 0; i < stories.length; i++)
    {
        if(stories[i].status)
        {
            if(stories[i].status === "published")
                stories_model.append(stories[i]);
        }
        else
            stories_model.append(stories[i]);
    }
}

function initEpisodesMenu()
{
    stories_model.clear();

    var stories = JSON.parse(container.episodes_json);
    var i = 0;

    all_episode_count = stories.length;

    console.log("all_episode_count ", all_episode_count);

    for(i = 0; i < stories.length; i++)
    {
        if(stories[i].status)
        {
            if(stories[i].status === "published")
                stories_model.append(stories[i]);
        }
        else
            stories_model.append(stories[i]);
    }
}

function getQuest()
{
    container.getEpisodeData(stories_view.path);
    container.show_load_indicator++;
}

function nextQuest()
{
    var tmp_number = parseInt(current_episode_count, 10);
    if((tmp_number + 1) <= all_episode_count)
    {
//        stories_view.path_episode_id = (tmp_number + 1).toString();
        stories_listview.incrementCurrentIndex();
        quest_menu.visible = false;
        getQuest();
        container.show_load_indicator++;
    }
    else
    {
        stories_view.visible = true;
        quest_menu.visible = false;
    }
}

function activateItem(index)
{
}

function pushActivity()
{
}

function popActivity()
{
}
