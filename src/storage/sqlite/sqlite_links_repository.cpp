#include "storage/sqlite/sqlite_links_repository.h"

#include <QSet>
#include <QVariant>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>

namespace zametki::storage::sqlite
{
SQLiteLinksRepository::SQLiteLinksRepository(SQLiteConnectionProvider *provider)
    : m_provider(provider)
{
}

void SQLiteLinksRepository::setProvider(SQLiteConnectionProvider *provider)
{
    m_provider = provider;
}

bool SQLiteLinksRepository::clearLinks(const QString &fromNoteId)
{
    if (!ensureReady())
    {
        return false;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("DELETE FROM links WHERE from_note = ?"));
    query.addBindValue(fromNoteId);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}

bool SQLiteLinksRepository::insertLinks(const QString &fromNoteId, const QVector<LinkRecord> &links)
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

    QSqlQuery query(db);
    query.prepare(QStringLiteral("INSERT INTO links(from_note, to_note, to_note_title) VALUES (?, ?, ?)"));

    for (const auto &link : links)
    {
        query.addBindValue(fromNoteId);
        if (link.toNoteId.isEmpty())
        {
            query.addBindValue(QVariant(QVariant::String));
        }
        else
        {
            query.addBindValue(link.toNoteId);
        }
        query.addBindValue(link.toNoteTitle);

        if (!query.exec())
        {
            m_lastError = query.lastError().text();
            db.rollback();
            return false;
        }
        query.finish();
    }

    if (!db.commit())
    {
        m_lastError = db.lastError().text();
        return false;
    }

    return true;
}

QStringList SQLiteLinksRepository::getOutgoingLinks(const QString &noteId)
{
    QStringList results;
    if (!ensureReady())
    {
        return results;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("SELECT to_note FROM links WHERE from_note = ? AND to_note IS NOT NULL"));
    query.addBindValue(noteId);
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

QStringList SQLiteLinksRepository::getBacklinks(const QString &noteId)
{
    QStringList results;
    if (!ensureReady())
    {
        return results;
    }

    const QString title = noteTitleById(noteId);

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("SELECT from_note FROM links WHERE to_note = ? OR (to_note_title = ? AND ? <> '')"));
    query.addBindValue(noteId);
    query.addBindValue(title);
    query.addBindValue(title);
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

QString SQLiteLinksRepository::resolveTitleToId(const QString &title)
{
    if (!ensureReady())
    {
        return {};
    }

    if (title.trimmed().isEmpty())
    {
        return {};
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("SELECT id FROM notes WHERE title = ? LIMIT 1"));
    query.addBindValue(title);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return {};
    }

    if (!query.next())
    {
        return {};
    }

    return query.value(0).toString();
}

QVector<core::GraphEdge> SQLiteLinksRepository::neighborsDepth1(const QString &noteId)
{
    QVector<core::GraphEdge> edges;
    if (!ensureReady())
    {
        return edges;
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("SELECT from_note, to_note FROM links WHERE (from_note = ? OR to_note = ?) AND to_note IS NOT NULL"));
    query.addBindValue(noteId);
    query.addBindValue(noteId);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return edges;
    }

    QSet<QString> seen;
    while (query.next())
    {
        core::GraphEdge edge;
        edge.fromId = query.value(0).toString();
        edge.toId = query.value(1).toString();
        const QString key = edge.fromId + QLatin1Char('|') + edge.toId;
        if (seen.contains(key))
        {
            continue;
        }
        seen.insert(key);
        edges.push_back(edge);
    }

    return edges;
}

QVector<core::GraphEdge> SQLiteLinksRepository::neighborsDepth2(const QString &noteId)
{
    QVector<core::GraphEdge> edges;
    QSet<QString> visited;

    const QVector<core::GraphEdge> depth1 = neighborsDepth1(noteId);
    for (const auto &edge : depth1)
    {
        const QString key = edge.fromId + QLatin1Char('|') + edge.toId;
        visited.insert(key);
        edges.push_back(edge);
    }

    QSet<QString> frontier;
    for (const auto &edge : depth1)
    {
        frontier.insert(edge.fromId);
        frontier.insert(edge.toId);
    }

    for (const auto &node : frontier)
    {
        const QVector<core::GraphEdge> local = neighborsDepth1(node);
        for (const auto &edge : local)
        {
            const QString key = edge.fromId + QLatin1Char('|') + edge.toId;
            if (visited.contains(key))
            {
                continue;
            }
            visited.insert(key);
            edges.push_back(edge);
        }
    }

    return edges;
}

QString SQLiteLinksRepository::lastError() const
{
    return m_lastError;
}

bool SQLiteLinksRepository::ensureReady()
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

QString SQLiteLinksRepository::noteTitleById(const QString &noteId)
{
    if (!ensureReady())
    {
        return {};
    }

    QSqlDatabase db = m_provider->database();
    QSqlQuery query(db);
    query.prepare(QStringLiteral("SELECT title FROM notes WHERE id = ?"));
    query.addBindValue(noteId);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return {};
    }

    if (!query.next())
    {
        return {};
    }

    return query.value(0).toString();
}
}

