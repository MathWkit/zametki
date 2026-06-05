#include "storage/search/search_indexer.h"

#include <QSqlError>
#include <QSqlQuery>

#include "core/block_text_accessor.h"

namespace zametki::storage::search
{
SearchIndexer::SearchIndexer(sqlite::SQLiteConnectionProvider *provider)
    : m_provider(provider)
{
}

void SearchIndexer::setProvider(sqlite::SQLiteConnectionProvider *provider)
{
    m_provider = provider;
}

QString SearchIndexer::buildContent(const core::Document &document) const
{
    QString result;
    for (const auto &block : document.blocks)
    {
        const QString text = core::BlockTextAccessor::getText(block);
        if (!text.isEmpty())
        {
            result.append(text);
            result.append(QLatin1Char('\n'));
        }
    }

    return result;
}

bool SearchIndexer::upsert(const core::Document &document)
{
    if (!ensureReady())
    {
        return false;
    }

    QSqlDatabase db = m_provider->database();
    if (!db.transaction())
    {
        m_lastError = db.lastError().text();
        return false;
    }

    QSqlQuery deleteQuery(db);
    deleteQuery.prepare(QStringLiteral("DELETE FROM notes_fts WHERE note_id = ?"));
    deleteQuery.addBindValue(document.id);
    if (!deleteQuery.exec())
    {
        m_lastError = deleteQuery.lastError().text();
        db.rollback();
        return false;
    }

    const QString content = buildContent(document);
    QSqlQuery insertQuery(db);
    insertQuery.prepare(QStringLiteral("INSERT INTO notes_fts(note_id, content) VALUES (?, ?)"));
    insertQuery.addBindValue(document.id);
    insertQuery.addBindValue(content);
    if (!insertQuery.exec())
    {
        m_lastError = insertQuery.lastError().text();
        db.rollback();
        return false;
    }

    if (!db.commit())
    {
        m_lastError = db.lastError().text();
        return false;
    }

    return true;
}

bool SearchIndexer::remove(const QString &documentId)
{
    if (!ensureReady())
    {
        return false;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("DELETE FROM notes_fts WHERE note_id = ?"));
    query.addBindValue(documentId);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}

QStringList SearchIndexer::search(const QString &queryText, int limit)
{
    QStringList results;
    if (!ensureReady())
    {
        return results;
    }

    if (queryText.trimmed().isEmpty())
    {
        return results;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("SELECT note_id FROM notes_fts WHERE notes_fts MATCH ? LIMIT ?"));
    query.addBindValue(queryText);
    query.addBindValue(limit);

    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return results;
    }

    while (query.next())
    {
        results.append(query.value(0).toString());
    }

    return results;
}

QString SearchIndexer::lastError() const
{
    return m_lastError;
}

bool SearchIndexer::ensureReady()
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
}

