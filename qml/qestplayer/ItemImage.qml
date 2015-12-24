import QtQuick 1.1

Image {

    property real scene_x: 0
    property real scene_y: 0

    x: scene_x * background_image.width
    y: scene_y * background_image.height

    property real scene_scale_x: 0
    property real scene_scale_y: 0

    width: scene_scale_x * background_image.width;
    height: scene_scale_y * background_image.height;

    onStatusChanged: {
        if(status == Image.Ready)
            container.loadImage();
    }
}

