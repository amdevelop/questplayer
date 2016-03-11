#ifndef QUESTREMOTECREATOR_H
#define QUESTREMOTECREATOR_H

#include <QObject>

#include <QtNetwork/QNetworkAccessManager>
#include <QUrl>

class QuestRemoteCreator : public QObject
{
    Q_OBJECT

    QString m_current_property;

    QNetworkAccessManager *m_man;

    QString m_server_name;

    QObject *m_declarative_root_object;

    QChar separator();
    void getManifest(QString request);


public:
    enum WorkMode
    {
        ModeOnline,
        ModeOffline
    };

    explicit QuestRemoteCreator(const QString& server_name,
                                const QString& quest_request,
                                QObject *declarative_root_object,
                                WorkMode work_mode = QuestRemoteCreator::ModeOnline,
                                QObject *parent = 0);


    ~QuestRemoteCreator();

private:
    WorkMode m_mode;

public slots:
    void slotFinished(QNetworkReply*);
    void slotGetStoryManifest(QString);
    void slotGetEpisodeData(QString);

    void slotShowAd();
    void slotHideAd();

};

#endif // QUESTREMOTECREATOR_H
