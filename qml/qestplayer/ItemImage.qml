import QtQuick 1.1

Image {
    onStatusChanged: {
        if(status == Image.Ready)
            container.loadImage();
    }
}

