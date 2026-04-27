#include "storage/json/document_file_repository.h"

#include <QDir>
#include <QDebug>

namespace zametki::storage::json
{
DocumentFileRepository::DocumentFileRepository(const QString &notesPath)
    : m_notesPath(notesPath)
{
}

core::Document DocumentFileRepository::read(const QString &id) const
{
    Q_UNUSED(id)
    return {};
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

