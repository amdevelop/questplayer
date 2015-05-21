#ifndef QUESTREMOTECREATOR_H
#define QUESTREMOTECREATOR_H

#include <QObject>

#include <QtNetwork/QNetworkAccessManager>

class QuestRemoteCreator : public QObject
{
    Q_OBJECT

    QString m_current_property;

    QNetworkAccessManager *m_man;

    QObject *m_declarative_root_object;
public:
    explicit QuestRemoteCreator(const QString& quest_request,
                                QObject *declarative_root_object,
                                QObject *parent = 0);

    ~QuestRemoteCreator();

public slots:
    void slotFinished(QNetworkReply*);
    void slotGetStoryManifest(QString);
};

#endif // QUESTREMOTECREATOR_H
