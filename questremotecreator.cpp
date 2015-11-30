#include "questremotecreator.h"

#include <QtNetwork/QNetworkReply>

#include <QDebug>

#include <QFile>
#include <QDir>

#include "defines.h"

QuestRemoteCreator::QuestRemoteCreator(const QString & server_name,
                                       const QString & quest_request,
                                       QObject *declarative_root_object,
                                       WorkMode work_mode,
                                       QObject *parent)
    : QObject(parent)
{
    m_server_name = server_name;
    m_mode = work_mode;
    m_declarative_root_object = declarative_root_object;

    m_server_name+=separator();
    m_declarative_root_object->setProperty(
                P_PATH_SEPARATOR,
                separator());

    switch (m_mode) {
    case ModeOnline:
        m_declarative_root_object->setProperty(
                    P_SERVER_NAME,
                    server_name);
        break;
    case ModeOffline:
        m_declarative_root_object->setProperty(
                    P_SERVER_NAME,
                    "file:" + server_name);
        break;
    default:
        m_declarative_root_object->setProperty(
                    P_SERVER_NAME,
                    server_name);
        break;
    }

    m_current_property = P_STORIES_JSON;


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

    getManifest(quest_request);
}

QChar QuestRemoteCreator::separator()
{
    switch (m_mode) {
    case ModeOnline:
        return '/';
    case ModeOffline:
        return QDir::separator();
    default:
        return '/';
    }
}

QuestRemoteCreator::~QuestRemoteCreator()
{
    delete m_man;
}

void QuestRemoteCreator::getManifest(QString request)
{
    switch (m_mode) {
    case ModeOnline:
        m_man->get(QNetworkRequest(QUrl(m_server_name + request)));
        break;
    case ModeOffline:
    {
        QFile file(m_server_name + request);

        if(file.open(QIODevice::ReadOnly))
            m_declarative_root_object->setProperty(m_current_property.toLatin1(),
                                                   QString::fromUtf8(file.readAll()));
    }
        break;
    default:
        break;
    }
}

void QuestRemoteCreator::slotFinished(QNetworkReply* reply)
{
    QString quest_data = m_declarative_root_object->property(m_current_property.toLatin1()).toString();
    QString quest_data_recv = QString::fromUtf8(reply->readAll());

    if(quest_data != quest_data_recv)
    {
    m_declarative_root_object->setProperty(m_current_property.toLatin1(),
                                           quest_data_recv);
    }
    else
    {
        m_declarative_root_object->setProperty("direct_start_flag",
                                               true);
    }
}

void QuestRemoteCreator::slotGetStoryManifest(QString story)
{
    m_current_property = P_EPISODES_JSON;

    getManifest(story +
                separator() +
                P_MANIFEST_STORY);

}

void QuestRemoteCreator::slotGetEpisodeData(QString path)
{
    m_current_property = P_QUEST_JSON;

    getManifest(path +
                separator() +
                P_MANIFEST_QUEST);
}

