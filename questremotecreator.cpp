#include "questremotecreator.h"

#include <QtNetwork/QNetworkReply>

QuestRemoteCreator::QuestRemoteCreator(const QString & quest_request, QObject *declarative_root_object, QObject *parent)
    : QObject(parent)
{
    m_declarative_root_object = declarative_root_object;

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
    m_declarative_root_object->setProperty("quest_json",
                                           QString(reply->readAll()));
}

