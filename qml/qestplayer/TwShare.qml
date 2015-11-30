import QtQuick 1.1

Rectangle {
    width: height
    height: social_rect.height * 0.7

    color: "transparent"

    Image {
        id: fb_share

        source: "qrc:/img/twitter_buttton.PNG"

        anchors.fill: parent

        smooth: true
    }

    MouseArea {
        anchors.fill: parent
    }
}
