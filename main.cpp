#include <QApplication>
#include "qmlapplicationviewer.h"

#include "polygonitem.h"

#include "questremotecreator.h"

#include "defines.h"

#include <QGraphicsBlurEffect>

//#define PLAYER_RELEASE

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    qmlRegisterType<PolygonItem>("QuestItems", 1, 0, "QuestPolygon");
    qmlRegisterType<QGraphicsBlurEffect>("Effects",1,0,"Blur");

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
//    conatiner.resize(480, 320);
//    conatiner.max

    conatiner.show();

    dv.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    dv.setSource(QUrl("qrc:/qml/qestplayer/main.qml"));

//    QuestRemoteCreator creator("quests",
//                               "quest_manifest.json",
//                               dv.rootObject(),
//                               QuestRemoteCreator::ModeOffline);
#ifdef PLAYER_RELEASE
    QuestRemoteCreator creator("http://matal.ru/quests",
#else
    QuestRemoteCreator creator("http://quest:8888/quests",
#endif
                               P_MANIFEST_MAIN,
                               dv.rootObject(),
                               QuestRemoteCreator::ModeOnline);

    dv.show();

    return app->exec();
}
