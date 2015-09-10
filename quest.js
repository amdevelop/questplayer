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

//var quest_path = "file:quest";
var quest_path =  ""; // "http://quest:8888/quests/";

var current_act = null;
var current_scene = null;
var act_counter = 0;
var act_scene_counter = 0;

var scene_items = [];
var scene_item_map = {};

var info_show_type = "";

function initQuest()
{
    quest_data = JSON.parse(container.quest_json);

    if(quest_data.episode.title !== null)
        episode_title.text = quest_data.episode.title;
    else
        episode_title.text = "Episode";

    episode_cover.source =
            quest_path + container.path_separator +
//            quest_data.episode.id + "/" +
            quest_data.episode.cover;
}

function startQuest() {
    if(current_act == null)
        nextAct();
}

function gameOver()
{
    current_act = null;
    current_scene = null;
    act_counter = 0;
    act_scene_counter = 0;

    scene_items = [];
    scene_item_map = {};

    info_show_type = "";

    episode_title.text = "Game over!";

    quest_menu.visible = true;
    anim.start();
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
        anim_info_text_hide.start();
    }
    else if(info_show_type === "scene_end")
    {
        drawScene();
        info_view.visible = false;
        timer_animation_show.stop();
    }
}

function nextAct()
{
    if(act_counter + 1 <= quest_data.episode.acts.length)
    {
        current_act = quest_data.episode.acts[act_counter];

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
        scene_items = [];
        scene_item_map = {};

        current_scene = current_act.scenes[act_scene_counter];

        info_view.visible = true;
        info_show_type = "scene_begin";
        if(current_scene.title !== null)
            info_text.text = current_scene.title;
        else
            info_text.text = "Scene";
        anim_info_text_show.start();
        if(timer_animation_show.running !== true)
            timer_animation_show.start();

        act_scene_counter++;
    }
    else
        nextAct();
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

    background_image.width = container.width;
    background_image.height = container.height;

    var i;
    var item_counter = 0;
    for(i = 0; i < current_scene.items.length; i++)
    {
        var current_item = current_scene.items[i];

        console.log("LOL!");
        console.log(i);

        var interior_item = null;
//        var interior_fake_item = null;
//        var component = Qt.createComponent("qrc:/qml/qestplayer/ItemImage.qml");
//                 if (component.status === Component.Ready) {
////                     interior_item = component.createObject(container);
//                     interior_fake_item = component.createObject(container);
//                 }

        interior_item = Qt.createQmlObject(
                    'import QtQuick 1.1; Image {}',
                    container,
                    "interior_item" + i.toString());

        interior_item.source =
                base_path +
                current_item.id + container.path_separator +
                current_item.image;

//        console.log(interior_item.source);

        interior_item.x = current_item.scene_x * container.width;
        interior_item.y = current_item.scene_y * container.height;

        interior_item.width = current_item.scene_scale_x * container.width;
        interior_item.height = current_item.scene_scale_y * container.height;

        interior_item.visible = true;

        if(current_item.type === "subject")
        {
            var item_title;
            if(current_item.title === null)
                item_title = "Item";

            item_model.append({ "item" : item_title, "item_color": "white"});

            //            var j;
            //            for(j = 0; j < current_scene.items.length; j++)
            //            {
            var polygon_item = Qt.createQmlObject(
                        'import QuestItems 1.0; QuestPolygon {}',
                        container,
                        "quest_item" + scene_items.length.toString());

            polygon_item.polygon = current_item.polygons;

            scene_items[scene_items.length] = polygon_item;
            scene_item_map[polygon_item] = interior_item;
            //            }
        }
    }
}

function initalizeInterior(interior_item, current_item)
{

}

function checkCollisions(mouseX, mouseY)
{
    var i;
    for(i = 0; i < scene_items.length; i++)
    {
        if(!scene_items[i].found)
            if(scene_items[i].contains(mouseX, mouseY,
                                       container.width, container.height))
            {
                var tmp_item = scene_item_map[scene_items[i]];

                console.log("found");
                if(tmp_item)
                {
//                    tmp_item.found = true;
                    console.log("found");

                                            showDetail(tmp_item,
                                                       mouseX,
                                                       mouseY);
                }

                scene_items[i].found = true;

                item_model.get(i).item_color = "darkgray";
            }
    }
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
        nextScene();
}

function showDetail(item_data, startX, startY)
{
    console.log(startX, startY)

    item_data.visible = false;

    item_image.source = item_data.source;

    item_window.width = item_data.width;
    item_window.height = item_data.height;
    item_window.x = item_data.x;
    item_window.y = item_data.y;
    item_window.z = 10000;

    item_window.koef = item_data.width / item_data.height;

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

function activateItem(index)
{

}

