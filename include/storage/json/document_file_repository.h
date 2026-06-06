#ifndef ZAMETKI_DOCUMENT_FILE_REPOSITORY_H
#define ZAMETKI_DOCUMENT_FILE_REPOSITORY_H

#include <QString>
#include <QList>
#include <QDateTime>

#include "core/document.h"

namespace zametki::storage::json
{
class DocumentFileRepository
{
public:
    explicit DocumentFileRepository(QString notesPath);

    core::Document read(const QString &id) const;

    bool write(const QString &id, const core::Document &document) const;

    bool remove(const QString &id) const;

    QList<QString> listAll() const;

    QDateTime lastModifiedTime(const QString &id) const;

    bool hasChanged(const QString &id, const QDateTime &since) const;

    QString lastError() const;
    QString notesPath() const;
    QString documentPath(const QString &id) const;

private:
    QString m_notesPath;
    mutable QString m_lastError;

    QString resolveDocumentFilePath(const QString &id) const;
    QString documentFilePath(const QString &id) const;
};
}

#endif // ZAMETKI_DOCUMENT_FILE_REPOSITORY_H

