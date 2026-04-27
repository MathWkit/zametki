#include "storage/json/document_file_repository.h"

#include <QFile>
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
    Q_UNUSED(id)
    Q_UNUSED(document)
    return false;
}

bool DocumentFileRepository::remove(const QString &id) const
{
    Q_UNUSED(id)
    return false;
}

QList<QString> DocumentFileRepository::listAll() const
{
    return {};
}

QString DocumentFileRepository::documentFilePath(const QString &id) const
{
    return m_notesPath + QDir::separator() + id + QStringLiteral(".json");
}
}

