#include "storage/json/document_file_repository.h"

#include <QFile>
#include <QSaveFile>
#include <QJsonDocument>
#include <QDir>
#include <QFileInfo>
#include <QDebug>

#include "storage/json/document_json_serializer.h"


namespace zametki::storage::json
{
DocumentFileRepository::DocumentFileRepository(const QString &notesPath)
    : m_notesPath(notesPath)
{
}

core::Document DocumentFileRepository::read(const QString &id) const
{
    const QString filePath = documentFilePath(id);
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        m_lastError = QString("Cannot open file: %1").arg(file.errorString());
        qWarning().noquote() << QStringLiteral("Failed to open document file for reading:") << filePath;
        return {};
    }

    const QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError)
    {
        m_lastError = QString("JSON parse error: %1").arg(parseError.errorString());
        qWarning().noquote() << QStringLiteral("JSON parse error:") << parseError.errorString();
        return {};
    }

    if (!doc.isObject())
    {
        m_lastError = QStringLiteral("JSON document is not an object");
        qWarning() << QStringLiteral("JSON document is not an object");
        return {};
    }

    DocumentJsonSerializer serializer;
    m_lastError.clear();
    return serializer.deserialize(doc.object());
}

bool DocumentFileRepository::write(const QString &id, const core::Document &document) const
{
    const QString filePath = documentFilePath(id);

    QDir notesDir(m_notesPath);
    if (!notesDir.exists() && !notesDir.mkpath(QStringLiteral(".")))
    {
        m_lastError = QString("Cannot create directory: %1").arg(m_notesPath);
        qWarning().noquote() << QStringLiteral("Failed to create notes directory:") << m_notesPath;
        return false;
    }

    QSaveFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        m_lastError = QString("Cannot open file for writing: %1").arg(file.errorString());
        qWarning().noquote() << QStringLiteral("Failed to open document file for writing:") << filePath;
        return false;
    }

    DocumentJsonSerializer serializer;
    const QJsonObject obj = serializer.serialize(document);
    const QJsonDocument doc(obj);
    const QByteArray data = doc.toJson(QJsonDocument::Indented);

    qint64 written = file.write(data);
    if (written != data.size())
    {
        m_lastError = QStringLiteral("Failed to write complete data to file");
        qWarning().noquote() << QStringLiteral("Failed to write complete data to file:") << filePath;
        file.cancelWriting();
        return false;
    }

    if (!file.commit())
    {
        m_lastError = QStringLiteral("Failed to commit file write");
        qWarning().noquote() << QStringLiteral("Failed to commit file write:") << filePath;
        return false;
    }

    m_lastError.clear();
    return true;
}

bool DocumentFileRepository::remove(const QString &id) const
{
    const QString filePath = documentFilePath(id);
    QFile file(filePath);

    if (!file.exists())
    {
        m_lastError = QString("Document file does not exist: %1").arg(filePath);
        qWarning().noquote() << QStringLiteral("Document file does not exist:") << filePath;
        return false;
    }

    if (!file.remove())
    {
        m_lastError = QString("Cannot remove file: %1").arg(file.errorString());
        qWarning().noquote() << QStringLiteral("Failed to remove document file:") << filePath;
        return false;
    }

    m_lastError.clear();
    return true;
}

QList<QString> DocumentFileRepository::listAll() const
{
    QDir notesDir(m_notesPath);
    QList<QString> ids;

    const QStringList jsonFiles = notesDir.entryList(QStringList() << QStringLiteral("*.json"), QDir::Files);
    for (const QString &filename : jsonFiles)
    {
        const QString id = filename.left(filename.size() - 5);
        if (!id.isEmpty())
            ids.append(id);
    }

    return ids;
}

QDateTime DocumentFileRepository::lastModifiedTime(const QString &id) const
{
    const QString filePath = documentFilePath(id);
    const QFileInfo fileInfo(filePath);
    if (!fileInfo.exists())
    {
        return {};
    }
    return fileInfo.lastModified();
}

bool DocumentFileRepository::hasChanged(const QString &id, const QDateTime &since) const
{
    const QDateTime lastMod = lastModifiedTime(id);
    if (!lastMod.isValid())
    {
        return false;
    }
    return lastMod > since;
}

QString DocumentFileRepository::lastError() const
{
    return m_lastError;
}

QString DocumentFileRepository::documentFilePath(const QString &id) const
{
    return m_notesPath + QDir::separator() + id + QStringLiteral(".json");
}
}

