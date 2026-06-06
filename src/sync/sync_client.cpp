#include "sync/sync_client.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QHttpMultiPart>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSettings>
#include <QUrl>

namespace zametki::sync
{

static const QString kSettingsToken     = QStringLiteral("sync/token");
static const QString kSettingsUsername  = QStringLiteral("sync/username");
static const QString kSettingsServerUrl = QStringLiteral("sync/serverUrl");
static const QString kSettingsNoteMap   = QStringLiteral("sync/noteToUuid");
static const QString kDefaultServerUrl  = QStringLiteral("http://localhost:8080");

SyncClient::SyncClient(QObject *parent)
    : QObject(parent)
    , m_nam(new QNetworkAccessManager(this))
    , m_serverUrl(kDefaultServerUrl)
{
    loadSettings();
}

bool SyncClient::isLoggedIn() const
{
    return !m_token.isEmpty();
}

QString SyncClient::username() const
{
    return m_username;
}

bool SyncClient::isSyncing() const
{
    return m_isSyncing;
}

QString SyncClient::serverUrl() const
{
    return m_serverUrl;
}

void SyncClient::setServerUrl(const QString &url)
{
    const QString trimmed = url.trimmed();
    if (trimmed == m_serverUrl)
        return;

    m_serverUrl = trimmed;
    QSettings settings;
    settings.setValue(kSettingsServerUrl, m_serverUrl);
    emit serverUrlChanged();
}

void SyncClient::setNotesPath(const QString &path)
{
    m_notesPath = path;
}

// --------------------------------------------------------------------------
// Authentication
// --------------------------------------------------------------------------

void SyncClient::login(const QString &username, const QString &password)
{
    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/login")));
    req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));

    QJsonObject body;
    body[QStringLiteral("username")] = username;
    body[QStringLiteral("password")] = password;

    auto *reply = m_nam->post(req, QJsonDocument(body).toJson(QJsonDocument::Compact));
    connect(reply, &QNetworkReply::finished, this, [this, reply, username]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const QByteArray data = reply->readAll();
        const QJsonObject json = QJsonDocument::fromJson(data).object();

        if (status == 200) {
            m_token    = json[QStringLiteral("token")].toString();
            m_username = username;
            saveSettings();
            emit isLoggedInChanged();
            emit usernameChanged();
            emit loginFinished(true, QString());
            syncNow();
        } else {
            const QString error = json[QStringLiteral("error")].toString();
            emit loginFinished(false, error.isEmpty() ? reply->errorString() : error);
        }
    });
}

void SyncClient::registerUser(const QString &username, const QString &password)
{
    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/register")));
    req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));

    QJsonObject body;
    body[QStringLiteral("username")] = username;
    body[QStringLiteral("password")] = password;

    auto *reply = m_nam->post(req, QJsonDocument(body).toJson(QJsonDocument::Compact));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const QJsonObject json = QJsonDocument::fromJson(reply->readAll()).object();

        if (status == 201) {
            emit registerFinished(true, QString());
        } else {
            const QString error = json[QStringLiteral("error")].toString();
            emit registerFinished(false, error.isEmpty() ? reply->errorString() : error);
        }
    });
}

void SyncClient::logout()
{
    m_token.clear();
    m_username.clear();
    QSettings settings;
    settings.remove(kSettingsToken);
    settings.remove(kSettingsUsername);
    settings.sync();
    emit isLoggedInChanged();
    emit usernameChanged();
}

// --------------------------------------------------------------------------
// Sync
// --------------------------------------------------------------------------

void SyncClient::syncNow()
{
    if (!isLoggedIn()) {
        emit syncFinished(false, QStringLiteral("not_logged_in"));
        return;
    }
    if (m_isSyncing)
        return;

    m_isSyncing = true;
    emit isSyncingChanged();

    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files")));
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

    auto *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 401) {
            handleTokenExpired();
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncFinished(false, QStringLiteral("token_expired"));
            return;
        }
        if (reply->error() != QNetworkReply::NoError) {
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncFinished(false, reply->errorString());
            return;
        }

        const QJsonArray files = QJsonDocument::fromJson(reply->readAll()).array();

        // Build server note map and collect notes we don't have locally
        QMap<QString, QString> serverNotes; // noteId -> uuid
        for (const QJsonValue &val : files) {
            const QJsonObject obj  = val.toObject();
            const QString uuid     = obj[QStringLiteral("uuid")].toString();
            const QString name     = obj[QStringLiteral("name")].toString();

            if (!name.endsWith(QStringLiteral(".json")))
                continue;

            const QString noteId = name.chopped(5);
            serverNotes.insert(noteId, uuid);
            m_noteToUuid.insert(noteId, uuid);
            m_uuidToNote.insert(uuid, noteId);
        }
        saveNoteMapping();

        // Download notes we don't have locally
        downloadMissingNotes(serverNotes, [this]() {
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncFinished(true, QString());
        });
    });
}

void SyncClient::downloadMissingNotes(const QMap<QString, QString> &serverNotes, std::function<void()> onDone)
{
    downloadServerNotes(serverNotes, false, QString(), [onDone](bool success, const QString &) {
        if (success && onDone) {
            onDone();
        } else if (onDone) {
            onDone();
        }
    });
}

void SyncClient::downloadServerNotes(const QMap<QString, QString> &serverNotes,
                                     bool overwriteLocal,
                                     const QString &action,
                                     std::function<void(bool success, const QString &message)> onFinished)
{
    if (m_notesPath.isEmpty()) {
        if (onFinished) {
            onFinished(false, QStringLiteral("notes_path_missing"));
        }
        return;
    }

    QList<QPair<QString, QString>> toDownload; // {uuid, noteId}
    for (auto it = serverNotes.cbegin(); it != serverNotes.cend(); ++it) {
        if (overwriteLocal || !noteExistsLocally(it.key())) {
            toDownload.append({it.value(), it.key()});
        }
    }

    if (toDownload.isEmpty()) {
        if (onFinished) {
            onFinished(true, QStringLiteral("downloaded_0"));
        }
        return;
    }

    auto pending = std::make_shared<int>(toDownload.size());
    auto failed = std::make_shared<bool>(false);
    auto lastError = std::make_shared<QString>();
    auto downloadedCount = std::make_shared<int>(0);
    auto notified = std::make_shared<bool>(false);

    const auto checkDone = [this, pending, failed, lastError, downloadedCount, notified, onFinished]() {
        if (--(*pending) > 0) {
            return;
        }
        if (*notified) {
            return;
        }
        *notified = true;

        if (*downloadedCount > 0) {
            emit notesDirectoryChanged();
        }

        if (!onFinished) {
            return;
        }

        if (*failed) {
            onFinished(false, *lastError);
            return;
        }

        onFinished(true, QStringLiteral("downloaded_%1").arg(*downloadedCount));
    };

    for (const auto &pair : toDownload) {
        const QString uuid   = pair.first;
        const QString noteId = pair.second;

        QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files/") + uuid));
        req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

        auto *reply = m_nam->get(req);
        connect(reply, &QNetworkReply::finished, this, [this, reply, noteId, failed, lastError, downloadedCount, checkDone]() {
            reply->deleteLater();
            const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

            if (status == 401) {
                handleTokenExpired();
                *failed = true;
                *lastError = QStringLiteral("token_expired");
            } else if (status != 200 || reply->error() != QNetworkReply::NoError) {
                *failed = true;
                *lastError = reply->errorString();
            } else if (m_notesPath.isEmpty()) {
                *failed = true;
                *lastError = QStringLiteral("notes_path_missing");
            } else {
                const QByteArray content = reply->readAll();
                QString filePath = noteFilePath(noteId);
                if (filePath.isEmpty()) {
                    filePath = QDir(m_notesPath).absoluteFilePath(noteId + QStringLiteral(".json"));
                }

                QFile file(filePath);
                if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
                    *failed = true;
                    *lastError = file.errorString();
                } else if (file.write(content) != content.size()) {
                    *failed = true;
                    *lastError = QStringLiteral("write_failed");
                } else {
                    ++(*downloadedCount);
                }
            }

            checkDone();
        });
    }
}

void SyncClient::uploadNoteNow(const QString &noteId)
{
    if (!isLoggedIn()) {
        emit noteActionFinished(noteId, QStringLiteral("upload"), false, QStringLiteral("not_logged_in"));
        return;
    }

    if (noteId.isEmpty()) {
        emit noteActionFinished(noteId, QStringLiteral("upload"), false, QStringLiteral("invalid_note"));
        return;
    }

    const QString filePath = noteFilePath(noteId);
    if (filePath.isEmpty()) {
        emit noteActionFinished(noteId, QStringLiteral("upload"), false, QStringLiteral("note_not_found"));
        return;
    }

    uploadNote(noteId, filePath, true);
}

void SyncClient::downloadNoteNow(const QString &noteId)
{
    if (!isLoggedIn()) {
        emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("not_logged_in"));
        return;
    }

    if (noteId.isEmpty()) {
        emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("invalid_note"));
        return;
    }

    const auto startDownload = [this, noteId](const QString &uuid) {
        if (uuid.isEmpty()) {
            emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("not_on_server"));
            return;
        }
        downloadNoteByUuid(uuid, noteId);
    };

    if (m_noteToUuid.contains(noteId)) {
        startDownload(m_noteToUuid.value(noteId));
        return;
    }

    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files")));
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

    auto *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply, noteId, startDownload]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 401) {
            handleTokenExpired();
            emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("token_expired"));
            return;
        }
        if (reply->error() != QNetworkReply::NoError) {
            emit noteActionFinished(noteId, QStringLiteral("download"), false, reply->errorString());
            return;
        }

        const QJsonArray files = QJsonDocument::fromJson(reply->readAll()).array();
        QString foundUuid;
        for (const QJsonValue &val : files) {
            const QJsonObject obj = val.toObject();
            const QString name = obj[QStringLiteral("name")].toString();
            if (name == noteId + QStringLiteral(".json")) {
                foundUuid = obj[QStringLiteral("uuid")].toString();
                if (!foundUuid.isEmpty()) {
                    m_noteToUuid.insert(noteId, foundUuid);
                    m_uuidToNote.insert(foundUuid, noteId);
                }
                break;
            }
        }
        saveNoteMapping();
        startDownload(foundUuid);
    });
}

void SyncClient::uploadAllNotesNow()
{
    if (!isLoggedIn()) {
        emit syncActionFinished(QStringLiteral("upload_all"), false, QStringLiteral("not_logged_in"));
        return;
    }
    if (m_isSyncing) {
        return;
    }

    const QStringList noteIds = listLocalNoteIds();
    if (noteIds.isEmpty()) {
        emit syncActionFinished(QStringLiteral("upload_all"), true, QString());
        return;
    }

    m_isSyncing = true;
    emit isSyncingChanged();

    auto pending = std::make_shared<int>(noteIds.size());
    auto failed = std::make_shared<bool>(false);
    auto lastError = std::make_shared<QString>();

    const auto checkDone = [this, pending, failed, lastError]() {
        if (--(*pending) > 0) {
            return;
        }

        m_isSyncing = false;
        emit isSyncingChanged();
        emit syncActionFinished(QStringLiteral("upload_all"),
                                !*failed,
                                *failed ? *lastError : QString());
    };

    for (const QString &noteId : noteIds) {
        const QString filePath = noteFilePath(noteId);
        if (filePath.isEmpty()) {
            *failed = true;
            *lastError = QStringLiteral("note_not_found");
            checkDone();
            continue;
        }

        uploadNote(noteId, filePath, false, [failed, lastError, checkDone](bool success, const QString &error) {
            if (!success) {
                *failed = true;
                if (!error.isEmpty()) {
                    *lastError = error;
                }
            }
            checkDone();
        });
    }
}

void SyncClient::softPullAllNotesNow()
{
    pullAllNotesFromServer(false, QStringLiteral("pull_soft_all"));
}

void SyncClient::hardPullAllNotesNow()
{
    pullAllNotesFromServer(true, QStringLiteral("pull_hard_all"));
}

void SyncClient::pullAllNotesFromServer(bool overwriteLocal, const QString &action)
{
    if (!isLoggedIn()) {
        emit syncActionFinished(action, false, QStringLiteral("not_logged_in"));
        return;
    }
    if (m_isSyncing) {
        emit syncActionFinished(action, false, QStringLiteral("sync_in_progress"));
        return;
    }

    m_isSyncing = true;
    emit isSyncingChanged();

    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files")));
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

    auto *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply, overwriteLocal, action]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 401) {
            handleTokenExpired();
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncActionFinished(action, false, QStringLiteral("token_expired"));
            return;
        }
        if (status != 200 || reply->error() != QNetworkReply::NoError) {
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncActionFinished(action, false, reply->errorString());
            return;
        }

        QMap<QString, QString> serverNotes;
        const QJsonArray files = QJsonDocument::fromJson(reply->readAll()).array();
        for (const QJsonValue &val : files) {
            const QJsonObject obj = val.toObject();
            const QString uuid = obj[QStringLiteral("uuid")].toString();
            const QString name = obj[QStringLiteral("name")].toString();

            if (!name.endsWith(QStringLiteral(".json")) || uuid.isEmpty()) {
                continue;
            }

            const QString noteId = name.chopped(5);
            serverNotes.insert(noteId, uuid);
            m_noteToUuid.insert(noteId, uuid);
            m_uuidToNote.insert(uuid, noteId);
        }
        saveNoteMapping();

        if (serverNotes.isEmpty()) {
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncActionFinished(action, true, QStringLiteral("nothing_on_server"));
            return;
        }

        downloadServerNotes(serverNotes, overwriteLocal, action, [this, action](bool success, const QString &message) {
            m_isSyncing = false;
            emit isSyncingChanged();
            emit syncActionFinished(action, success, message);
        });
    });
}

void SyncClient::resolveServerUuid(const QString &noteId, std::function<void(const QString &uuid)> onResolved)
{
    if (m_noteToUuid.contains(noteId)) {
        onResolved(m_noteToUuid.value(noteId));
        return;
    }

    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files")));
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

    auto *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply, noteId, onResolved]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 401) {
            handleTokenExpired();
            onResolved({});
            return;
        }
        if (reply->error() != QNetworkReply::NoError) {
            onResolved({});
            return;
        }

        const QJsonArray files = QJsonDocument::fromJson(reply->readAll()).array();
        QString foundUuid;
        for (const QJsonValue &val : files) {
            const QJsonObject obj = val.toObject();
            const QString name = obj[QStringLiteral("name")].toString();
            if (name == noteId + QStringLiteral(".json")) {
                foundUuid = obj[QStringLiteral("uuid")].toString();
                if (!foundUuid.isEmpty()) {
                    m_noteToUuid.insert(noteId, foundUuid);
                    m_uuidToNote.insert(foundUuid, noteId);
                }
                break;
            }
        }
        saveNoteMapping();
        onResolved(foundUuid);
    });
}

QStringList SyncClient::listLocalNoteIds() const
{
    QStringList noteIds;
    if (m_notesPath.isEmpty()) {
        return noteIds;
    }

    QDirIterator it(m_notesPath, QStringList() << QStringLiteral("*.json"),
                    QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        it.next();
        const QString noteId = QFileInfo(it.filePath()).baseName();
        if (!noteId.isEmpty()) {
            noteIds.append(noteId);
        }
    }

    return noteIds;
}

void SyncClient::downloadNoteByUuid(const QString &uuid, const QString &noteId)
{
    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files/") + uuid));
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

    auto *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply, noteId]() {
        reply->deleteLater();
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

        if (status == 401) {
            handleTokenExpired();
            emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("token_expired"));
            return;
        }
        if (status != 200 || reply->error() != QNetworkReply::NoError) {
            emit noteActionFinished(noteId, QStringLiteral("download"), false, reply->errorString());
            return;
        }

        if (m_notesPath.isEmpty()) {
            emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("notes_path_missing"));
            return;
        }

        const QByteArray content = reply->readAll();
        QString filePath = noteFilePath(noteId);
        if (filePath.isEmpty()) {
            filePath = QDir(m_notesPath).absoluteFilePath(noteId + QStringLiteral(".json"));
        }

        QFile file(filePath);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
            emit noteActionFinished(noteId, QStringLiteral("download"), false, file.errorString());
            return;
        }

        if (file.write(content) != content.size()) {
            emit noteActionFinished(noteId, QStringLiteral("download"), false, QStringLiteral("write_failed"));
            return;
        }

        file.close();
        emit notesDirectoryChanged();
        emit noteActionFinished(noteId, QStringLiteral("download"), true, QString());
    });
}

QString SyncClient::noteFilePath(const QString &noteId) const
{
    if (m_notesPath.isEmpty() || noteId.isEmpty()) {
        return {};
    }

    const QString directPath = QDir(m_notesPath).absoluteFilePath(noteId + QStringLiteral(".json"));
    if (QFileInfo::exists(directPath)) {
        return directPath;
    }

    QDirIterator it(m_notesPath, QStringList() << (noteId + QStringLiteral(".json")),
                    QDir::Files, QDirIterator::Subdirectories);
    if (it.hasNext()) {
        return it.next();
    }

    return {};
}

// --------------------------------------------------------------------------
// Private helpers
// --------------------------------------------------------------------------

void SyncClient::uploadNote(const QString &noteId,
                            const QString &filePath,
                            bool notifyWhenDone,
                            UploadCompleteFn onComplete)
{
    const auto finish = [noteId, notifyWhenDone, onComplete, this](bool success, const QString &error) {
        if (notifyWhenDone) {
            emit noteActionFinished(noteId, QStringLiteral("upload"), success, error);
        }
        if (onComplete) {
            onComplete(success, error);
        }
    };

    if (m_uploadingNotes.contains(noteId)) {
        finish(false, QStringLiteral("upload_in_progress"));
        return;
    }

    QFile *file = new QFile(filePath, this);
    if (!file->open(QIODevice::ReadOnly)) {
        const QString error = file->errorString();
        file->deleteLater();
        finish(false, error);
        return;
    }

    const QByteArray content = file->readAll();
    file->deleteLater();

    m_uploadingNotes.insert(noteId);

    // If we already have a server UUID for this note, delete the old copy first
    if (m_noteToUuid.contains(noteId)) {
        const QString oldUuid = m_noteToUuid.value(noteId);

        QNetworkRequest delReq(QUrl(m_serverUrl + QStringLiteral("/api/files/") + oldUuid));
        delReq.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

        auto *delReply = m_nam->deleteResource(delReq);
        connect(delReply, &QNetworkReply::finished, this, [this, delReply, noteId, content, notifyWhenDone, onComplete]() {
            delReply->deleteLater();
            // Remove old mapping regardless of delete result
            const QString oldUuid = m_noteToUuid.take(noteId);
            m_uuidToNote.remove(oldUuid);
            doUploadContent(noteId, content, notifyWhenDone, onComplete);
        });
    } else {
        doUploadContent(noteId, content, notifyWhenDone, onComplete);
    }
}

void SyncClient::doUploadContent(const QString &noteId,
                                 const QByteArray &content,
                                 bool notifyWhenDone,
                                 UploadCompleteFn onComplete)
{
    QNetworkRequest req(QUrl(m_serverUrl + QStringLiteral("/api/files")));
    req.setRawHeader("Authorization", ("Bearer " + m_token).toUtf8());

    auto *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QHttpPart filePart;
    filePart.setHeader(
        QNetworkRequest::ContentDispositionHeader,
        QString(QStringLiteral("form-data; name=\"file\"; filename=\"%1.json\"")).arg(noteId));
    filePart.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));
    filePart.setBody(content);
    multiPart->append(filePart);

    auto *reply = m_nam->post(req, multiPart);
    multiPart->setParent(reply);

    connect(reply, &QNetworkReply::finished, this, [this, reply, noteId, notifyWhenDone, onComplete]() {
        reply->deleteLater();
        m_uploadingNotes.remove(noteId);

        const auto finish = [noteId, notifyWhenDone, onComplete, this](bool success, const QString &error) {
            if (notifyWhenDone) {
                emit noteActionFinished(noteId, QStringLiteral("upload"), success, error);
            }
            if (onComplete) {
                onComplete(success, error);
            }
        };

        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (status == 201) {
            const QJsonObject json = QJsonDocument::fromJson(reply->readAll()).object();
            const QString uuid = json[QStringLiteral("uuid")].toString();
            if (!uuid.isEmpty()) {
                m_noteToUuid.insert(noteId, uuid);
                m_uuidToNote.insert(uuid, noteId);
                saveNoteMapping();
            }
            finish(true, QString());
        } else if (status == 401) {
            handleTokenExpired();
            finish(false, QStringLiteral("token_expired"));
        } else {
            const QJsonObject json = QJsonDocument::fromJson(reply->readAll()).object();
            const QString error = json[QStringLiteral("error")].toString();
            finish(false, error.isEmpty() ? reply->errorString() : error);
        }
    });
}

bool SyncClient::noteExistsLocally(const QString &noteId) const
{
    if (m_notesPath.isEmpty())
        return false;

    const QString directPath = QDir(m_notesPath).absoluteFilePath(noteId + QStringLiteral(".json"));
    if (QFileInfo::exists(directPath))
        return true;

    QDirIterator it(m_notesPath, QStringList() << (noteId + QStringLiteral(".json")),
                    QDir::Files, QDirIterator::Subdirectories);
    return it.hasNext();
}

void SyncClient::handleTokenExpired()
{
    m_token.clear();
    QSettings settings;
    settings.remove(kSettingsToken);
    settings.sync();
    emit isLoggedInChanged();
}

void SyncClient::loadSettings()
{
    QSettings settings;
    m_token    = settings.value(kSettingsToken).toString();
    m_username = settings.value(kSettingsUsername).toString();

    const QString savedUrl = settings.value(kSettingsServerUrl).toString();
    if (!savedUrl.isEmpty())
        m_serverUrl = savedUrl;

    // Load note UUID mapping
    const QVariantMap map = settings.value(kSettingsNoteMap).toMap();
    for (auto it = map.cbegin(); it != map.cend(); ++it) {
        const QString uuid = it.value().toString();
        if (!uuid.isEmpty()) {
            m_noteToUuid.insert(it.key(), uuid);
            m_uuidToNote.insert(uuid, it.key());
        }
    }
}

void SyncClient::saveSettings()
{
    QSettings settings;
    settings.setValue(kSettingsToken, m_token);
    settings.setValue(kSettingsUsername, m_username);
    settings.sync();
}

void SyncClient::saveNoteMapping()
{
    QVariantMap map;
    for (auto it = m_noteToUuid.cbegin(); it != m_noteToUuid.cend(); ++it) {
        map.insert(it.key(), it.value());
    }
    QSettings settings;
    settings.setValue(kSettingsNoteMap, map);
    settings.sync();
}

} // namespace zametki::sync
