#include "storage/json/document_file_repository.h"

#include <QFile>
#include <QSaveFile>
#include <QJsonDocument>
#include <QDir>
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
        qWarning().noquote() << QStringLiteral("Failed to open document file for reading:") << filePath;
        return {};
    }

    const QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError)
    {
        qWarning().noquote() << QStringLiteral("JSON parse error:") << parseError.errorString();
        return {};
    }

    if (!doc.isObject())
    {
        qWarning() << QStringLiteral("JSON document is not an object");
        return {};
    }

    DocumentJsonSerializer serializer;
    return serializer.deserialize(doc.object());
}

bool DocumentFileRepository::write(const QString &id, const core::Document &document) const
{
    const QString filePath = documentFilePath(id);

    QSaveFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
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
        qWarning().noquote() << QStringLiteral("Failed to write complete data to file:") << filePath;
        file.cancelWriting();
        return false;
    }

    if (!file.commit())
    {
        qWarning().noquote() << QStringLiteral("Failed to commit file write:") << filePath;
        return false;
    }

    return true;
}

bool DocumentFileRepository::remove(const QString &id) const
{
    const QString filePath = documentFilePath(id);
    QFile file(filePath);

    if (!file.exists())
    {
        qWarning().noquote() << QStringLiteral("Document file does not exist:") << filePath;
        return false;
    }

    if (!file.remove())
    {
        qWarning().noquote() << QStringLiteral("Failed to remove document file:") << filePath;
        return false;
    }

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

QString DocumentFileRepository::documentFilePath(const QString &id) const
{
    return m_notesPath + QDir::separator() + id + QStringLiteral(".json");
}
}

