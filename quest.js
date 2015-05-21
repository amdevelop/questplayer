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

var quest_path = "file:quest";
//var quest_path = "http://quest:8888/quests/best_story/1/";

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

    episode_title.text = quest_data.episode.title;
    episode_cover.source =
            quest_path + "/" +
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
            info_text.text = current_act.title;
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
        info_text.text = current_scene.title;
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

    background_image.source =
            quest_path + "/" +
            current_act.id + "/" +
            current_scene.id + "/" +
            current_scene.background;
    background_image.width = container.width;
    background_image.height = container.height;

    var i;
    for(i = 0; i < current_scene.items.length; i++)
    {
        item_model.append({ "item" : current_scene.items[i].title, "item_color": "white"});

        var polygon_item = Qt.createQmlObject(
                    'import QuestItems 1.0; QuestPolygon {}',
                         container,
                     "quest_item" + scene_items.length.toString());

        polygon_item.polygon = current_scene.items[i].polygon;

        scene_items[scene_items.length] = polygon_item;

        scene_item_map[polygon_item] = current_scene.items[i];
    }
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

                if(tmp_item)
                        showDetail(tmp_item,
                                   mouseX,
                                   mouseY);

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
    item_window.x = startX - item_window.width / 2;
    item_window.y = startY - item_window.height / 2;
    item_window.scale = 0;

    if(item_data.detail !== null &&
            item_data.detail !== "")
    {
    item_image.source =
            quest_path + "/" +
            current_act.id + "/" +
            current_scene.id + "/" +
            item_data.id + "/" +
            item_data.detail;
    item_image.visible = true;
    }
    else
    {
        item_text.text = item_data.title;
        item_text.visible = true;
    }


    item_window.visible = true;

//    number_anim.start();
}


//////////////////////////////////////////

function initStoriesMenu()
{
    var stories = JSON.parse(container.stories_json);
    var i = 0;
    for(i = 0; i < stories.length; i++)
    {
        stories_model.append(stories[i]);
    }
}
