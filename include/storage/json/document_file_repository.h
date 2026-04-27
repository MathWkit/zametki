#ifndef ZAMETKI_DOCUMENT_FILE_REPOSITORY_H
#define ZAMETKI_DOCUMENT_FILE_REPOSITORY_H

#include <QString>
#include <QList>

#include "core/document.h"

namespace zametki::storage::json
{
class DocumentFileRepository
{
public:
    explicit DocumentFileRepository(const QString &notesPath);

    core::Document read(const QString &id) const;

    bool write(const QString &id, const core::Document &document) const;

    bool remove(const QString &id) const;

    QList<QString> listAll() const;

private:
    QString m_notesPath;

    QString documentFilePath(const QString &id) const;
};
}

#endif // ZAMETKI_DOCUMENT_FILE_REPOSITORY_H

