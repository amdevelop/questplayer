#include <QApplication>
#include "qmlapplicationviewer.h"

#include "polygonitem.h"

#include "questremotecreator.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    qmlRegisterType<PolygonItem>("QuestItems", 1, 0, "QuestPolygon");

//    QmlApplicationViewer viewer;
//    viewer.addImportPath(QLatin1String("modules"));
//    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
//    viewer.setMainQmlFile(QLatin1String("qml/qestplayer/main.qml"));

    QWidget conatiner;
    conatiner.show();

    QVBoxLayout vbLayout(&conatiner);

    QDeclarativeView dv;
    vbLayout.addWidget(&dv);
    conatiner.resize(800, 600);
    dv.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    dv.setSource(QUrl("qrc:/qml/qestplayer/main.qml"));

//    QuestRemoteCreator creator("http://quest:8888/quests/best_story/1/quest.json",
//                               dv.rootObject());

    QFile file("quest/quest.json");

    if(file.open(QIODevice::ReadOnly))
    {
        dv.rootObject()->setProperty("quest_json", file.readAll());
    }
    else
        exit(1);

    dv.show();
//    viewer.showExpanded();

    return app->exec();
}
