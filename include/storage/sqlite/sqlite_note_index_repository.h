#ifndef ZAMETKI_SQLITE_NOTE_INDEX_REPOSITORY_H
#define ZAMETKI_SQLITE_NOTE_INDEX_REPOSITORY_H

#include <QString>
#include <QStringList>

#include "storage/sqlite/sqlite_connection_provider.h"

namespace zametki::storage::sqlite
{
class SQLiteNoteIndexRepository
{
public:
    explicit SQLiteNoteIndexRepository(SQLiteConnectionProvider *provider = nullptr);

    void setProvider(SQLiteConnectionProvider *provider);

    bool upsertNote(const QString &id, const QString &title, const QString &path);
    bool deleteNote(const QString &id);
    bool upsertTags(const QString &noteId, const QStringList &tags);
    bool cleanupOrphanTags();

    QString lastError() const;

private:
    bool ensureReady();
    QString normalizeTag(const QString &tag) const;

    SQLiteConnectionProvider *m_provider = nullptr;
    QString m_lastError;
};
}

#endif // ZAMETKI_SQLITE_NOTE_INDEX_REPOSITORY_H

