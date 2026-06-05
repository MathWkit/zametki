#include "storage/sqlite/sqlite_note_index_repository.h"

#include <QSet>
#include <QSqlError>
#include <QSqlQuery>

namespace zametki::storage::sqlite
{
SQLiteNoteIndexRepository::SQLiteNoteIndexRepository(SQLiteConnectionProvider *provider)
    : m_provider(provider)
{
}

void SQLiteNoteIndexRepository::setProvider(SQLiteConnectionProvider *provider)
{
    m_provider = provider;
}

bool SQLiteNoteIndexRepository::upsertNote(const QString &id, const QString &title, const QString &path)
{
    if (!ensureReady())
    {
        return false;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("INSERT INTO notes(id, title, path) VALUES (?, ?, ?) ON CONFLICT(id) DO UPDATE SET title=excluded.title, path=excluded.path"));
    query.addBindValue(id);
    query.addBindValue(title);
    query.addBindValue(path);

    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}

bool SQLiteNoteIndexRepository::deleteNote(const QString &id)
{
    if (!ensureReady())
    {
        return false;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("DELETE FROM notes WHERE id = ?"));
    query.addBindValue(id);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}

bool SQLiteNoteIndexRepository::upsertTags(const QString &noteId, const QStringList &tags)
{
    if (!ensureReady())
    {
        return false;
    }

    QSet<QString> normalized;
    for (const auto &tag : tags)
    {
        const QString cleaned = normalizeTag(tag);
        if (!cleaned.isEmpty())
        {
            normalized.insert(cleaned);
        }
    }

    QSqlDatabase db = m_provider->database();
    if (!db.transaction())
    {
        m_lastError = db.lastError().text();
        return false;
    }

    QSqlQuery deleteQuery(db);
    deleteQuery.prepare(QStringLiteral("DELETE FROM note_tags WHERE note_id = ?"));
    deleteQuery.addBindValue(noteId);
    if (!deleteQuery.exec())
    {
        m_lastError = deleteQuery.lastError().text();
        db.rollback();
        return false;
    }

    QSqlQuery insertTagQuery(db);
    insertTagQuery.prepare(QStringLiteral("INSERT OR IGNORE INTO tags(name) VALUES (?)"));

    QSqlQuery selectTagQuery(db);
    selectTagQuery.prepare(QStringLiteral("SELECT id FROM tags WHERE name = ?"));

    QSqlQuery insertLinkQuery(db);
    insertLinkQuery.prepare(QStringLiteral("INSERT OR IGNORE INTO note_tags(note_id, tag_id) VALUES (?, ?)"));

    for (const auto &tag : normalized)
    {
        insertTagQuery.addBindValue(tag);
        if (!insertTagQuery.exec())
        {
            m_lastError = insertTagQuery.lastError().text();
            db.rollback();
            return false;
        }
        insertTagQuery.finish();

        selectTagQuery.addBindValue(tag);
        if (!selectTagQuery.exec())
        {
            m_lastError = selectTagQuery.lastError().text();
            db.rollback();
            return false;
        }

        if (selectTagQuery.next())
        {
            const int tagId = selectTagQuery.value(0).toInt();
            insertLinkQuery.addBindValue(noteId);
            insertLinkQuery.addBindValue(tagId);
            if (!insertLinkQuery.exec())
            {
                m_lastError = insertLinkQuery.lastError().text();
                db.rollback();
                return false;
            }
            insertLinkQuery.finish();
        }
        selectTagQuery.finish();
    }

    if (!db.commit())
    {
        m_lastError = db.lastError().text();
        return false;
    }

    return true;
}

bool SQLiteNoteIndexRepository::cleanupOrphanTags()
{
    if (!ensureReady())
    {
        return false;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    if (!query.exec(QStringLiteral("DELETE FROM tags WHERE id NOT IN (SELECT DISTINCT tag_id FROM note_tags)")))
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}

QString SQLiteNoteIndexRepository::lastError() const
{
    return m_lastError;
}

bool SQLiteNoteIndexRepository::ensureReady()
{
    if (!m_provider)
    {
        m_lastError = QStringLiteral("no_provider");
        return false;
    }

    if (!m_provider->ensureSchema())
    {
        m_lastError = m_provider->lastError();
        return false;
    }

    return true;
}

QString SQLiteNoteIndexRepository::normalizeTag(const QString &tag) const
{
    return tag.trimmed().toLower();
}
}

