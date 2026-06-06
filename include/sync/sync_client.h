#ifndef ZAMETKI_SYNC_CLIENT_H
#define ZAMETKI_SYNC_CLIENT_H

#include <functional>

#include <QObject>
#include <QString>
#include <QMap>
#include <QSet>

class QNetworkAccessManager;
class QNetworkReply;

namespace zametki::sync
{

class SyncClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isLoggedIn READ isLoggedIn NOTIFY isLoggedInChanged)
    Q_PROPERTY(QString username READ username NOTIFY usernameChanged)
    Q_PROPERTY(bool isSyncing READ isSyncing NOTIFY isSyncingChanged)
    Q_PROPERTY(QString serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlChanged)

public:
    explicit SyncClient(QObject *parent = nullptr);

    bool isLoggedIn() const;
    QString username() const;
    bool isSyncing() const;
    QString serverUrl() const;
    void setServerUrl(const QString &url);

    // Called from C++ (main.cpp) when notes directory changes
    void setNotesPath(const QString &path);

    // QML-invokable API
    Q_INVOKABLE void login(const QString &username, const QString &password);
    Q_INVOKABLE void registerUser(const QString &username, const QString &password);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void syncNow();
    Q_INVOKABLE void uploadNoteNow(const QString &noteId);
    Q_INVOKABLE void downloadNoteNow(const QString &noteId);
    Q_INVOKABLE void uploadAllNotesNow();
    Q_INVOKABLE void softUnloadAllNotesNow();
    Q_INVOKABLE void hardUnloadAllNotesNow();

signals:
    void loginFinished(bool success, const QString &error);
    void registerFinished(bool success, const QString &error);
    void syncFinished(bool success, const QString &error);
    void isLoggedInChanged();
    void usernameChanged();
    void isSyncingChanged();
    void serverUrlChanged();
    // Emitted when new notes were downloaded - tells bridge to refresh sidebar
    void notesDirectoryChanged();
    void noteActionFinished(const QString &noteId, const QString &action, bool success, const QString &error);
    void syncActionFinished(const QString &action, bool success, const QString &error);

private:
    using UploadCompleteFn = std::function<void(bool success, const QString &error)>;
    void uploadNote(const QString &noteId,
                    const QString &filePath,
                    bool notifyWhenDone = false,
                    UploadCompleteFn onComplete = nullptr);
    void doUploadContent(const QString &noteId,
                         const QByteArray &content,
                         bool notifyWhenDone,
                         UploadCompleteFn onComplete = nullptr);
    QStringList listLocalNoteIds() const;
    void deleteAllNotesFromServer(const QString &action);
    void downloadMissingNotes(const QMap<QString, QString> &serverNotes, std::function<void()> onDone);
    bool noteExistsLocally(const QString &noteId) const;
    QString noteFilePath(const QString &noteId) const;
    void downloadNoteByUuid(const QString &uuid, const QString &noteId);
    void resolveServerUuid(const QString &noteId, std::function<void(const QString &uuid)> onResolved);
    void handleTokenExpired();
    void loadSettings();
    void saveSettings();
    void saveNoteMapping();

    QNetworkAccessManager *m_nam;
    QString m_token;
    QString m_username;
    QString m_serverUrl;
    QString m_notesPath;
    bool m_isSyncing = false;

    // Tracks in-flight uploads by noteId to avoid duplicates
    QSet<QString> m_uploadingNotes;

    // local noteId -> server UUID
    QMap<QString, QString> m_noteToUuid;
    // server UUID -> local noteId
    QMap<QString, QString> m_uuidToNote;
};

} // namespace zametki::sync

#endif // ZAMETKI_SYNC_CLIENT_H
