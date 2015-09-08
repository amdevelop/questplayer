#include <QApplication>
#include "qmlapplicationviewer.h"

#include "polygonitem.h"

#include "questremotecreator.h"

#include "defines.h"

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

    vbLayout.setMargin(0);
    vbLayout.addWidget(&dv);
    conatiner.resize(800, 600);
    conatiner.show();

    dv.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    dv.setSource(QUrl("qrc:/qml/qestplayer/main.qml"));

//    QuestRemoteCreator creator("quests",
//                               "quest_manifest.json",
//                               dv.rootObject(),
//                               QuestRemoteCreator::ModeOffline);
    QuestRemoteCreator creator("http://quest:8888/quests",
                               P_MANIFEST_MAIN,
                               dv.rootObject(),
                               QuestRemoteCreator::ModeOnline);

//    QFile file(QString("quests") + QDir::separator() + QString("quest_manifest.json"));

//    if(file.open(QIODevice::ReadOnly))
//    {
//        dv.rootObject()->setProperty("stories_json", file.readAll());
//    }
//    else
//        exit(1);

    dv.show();
//    viewer.showExpanded();

    return app->exec();
}
