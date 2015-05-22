#include "questremotecreator.h"

#include <QtNetwork/QNetworkReply>

#include <QDebug>

QuestRemoteCreator::QuestRemoteCreator(const QString & quest_request, QObject *declarative_root_object, QObject *parent)
    : QObject(parent)
{
    m_current_property = "stories_json";

    m_declarative_root_object = declarative_root_object;

    connect(m_declarative_root_object,
            SIGNAL(getStoryManifest(QString)),
            SLOT(slotGetStoryManifest(QString)));

    connect(m_declarative_root_object,
            SIGNAL(getEpisodeData(QString)),
            SLOT(slotGetEpisodeData(QString)));

    m_man = new QNetworkAccessManager(this);
    connect(m_man,
            SIGNAL(finished(QNetworkReply*)),
            SLOT(slotFinished(QNetworkReply*)));

    m_man->get(QNetworkRequest(QUrl(quest_request)));
}

QuestRemoteCreator::~QuestRemoteCreator()
{
    delete m_man;
}

void QuestRemoteCreator::slotFinished(QNetworkReply* reply)
{
    m_declarative_root_object->setProperty(m_current_property.toLatin1(),
                                           QString::fromUtf8(reply->readAll()));
}

void QuestRemoteCreator::slotGetStoryManifest(QString story)
{
    m_current_property = "episodes_json";
    m_man->get(QNetworkRequest(QUrl("http://quest:8888/quests/" +
                                    story +
                                    "/story_manifest.json")));

}

void QuestRemoteCreator::slotGetEpisodeData(QString path)
{
    m_current_property = "quest_json";
    m_man->get(QNetworkRequest(QUrl("http://quest:8888/quests/" +
                                    path +
                                    "/quest.json")));
}

