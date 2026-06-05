#include "storage/sqlite/sqlite_connection_provider.h"

#include <QSqlError>
#include <QSqlQuery>
#include <QUuid>

namespace zametki::storage::sqlite
{
SQLiteConnectionProvider::SQLiteConnectionProvider(const QString &databasePath)
    : m_databasePath(databasePath),
      m_connectionName(QUuid::createUuid().toString(QUuid::WithoutBraces))
{
}

void SQLiteConnectionProvider::setDatabasePath(const QString &databasePath)
{
    m_databasePath = databasePath;
}

QString SQLiteConnectionProvider::databasePath() const
{
    return m_databasePath;
}

QSqlDatabase SQLiteConnectionProvider::database() const
{
    if (QSqlDatabase::contains(m_connectionName))
    {
        return QSqlDatabase::database(m_connectionName);
    }

    return {};
}

bool SQLiteConnectionProvider::open()
{
    m_lastError.clear();
    QSqlDatabase db;

    if (QSqlDatabase::contains(m_connectionName))
    {
        db = QSqlDatabase::database(m_connectionName);
    }
    else
    {
        db = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"), m_connectionName);
        db.setDatabaseName(m_databasePath);
    }

    if (!db.isOpen() && !db.open())
    {
        m_lastError = db.lastError().text();
        return false;
    }

    QSqlQuery pragma(db);
    if (!pragma.exec(QStringLiteral("PRAGMA foreign_keys = ON")))
    {
        m_lastError = pragma.lastError().text();
        return false;
    }

    return true;
}

bool SQLiteConnectionProvider::ensureSchema()
{
    if (!open())
    {
        return false;
    }

    QSqlDatabase db = database();
    if (!db.isValid())
    {
        m_lastError = QStringLiteral("invalid_connection");
        return false;
    }

    if (!execQuery(db, QStringLiteral("CREATE TABLE IF NOT EXISTS schema_version (version INTEGER NOT NULL)")))
    {
        return false;
    }

    int version = currentSchemaVersion(db);
    if (version == 0)
    {
        if (!execQuery(db, QStringLiteral("CREATE TABLE IF NOT EXISTS notes (id TEXT PRIMARY KEY, title TEXT, path TEXT)")))
        {
            return false;
        }

        if (!execQuery(db, QStringLiteral("CREATE TABLE IF NOT EXISTS tags (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE)")))
        {
            return false;
        }

        if (!execQuery(db, QStringLiteral("CREATE TABLE IF NOT EXISTS note_tags (note_id TEXT, tag_id INTEGER, PRIMARY KEY (note_id, tag_id), FOREIGN KEY(note_id) REFERENCES notes(id) ON DELETE CASCADE, FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE CASCADE)")))
        {
            return false;
        }

        if (!execQuery(db, QStringLiteral("CREATE TABLE IF NOT EXISTS links (from_note TEXT, to_note TEXT, FOREIGN KEY(from_note) REFERENCES notes(id) ON DELETE CASCADE, FOREIGN KEY(to_note) REFERENCES notes(id) ON DELETE CASCADE)")))
        {
            return false;
        }

        if (!execQuery(db, QStringLiteral("CREATE VIRTUAL TABLE IF NOT EXISTS notes_fts USING fts5(note_id, content)")))
        {
            return false;
        }

        if (!setSchemaVersion(db, 1))
        {
            return false;
        }

        version = 1;
    }

    Q_UNUSED(version)
    return true;
}

QString SQLiteConnectionProvider::lastError() const
{
    return m_lastError;
}

bool SQLiteConnectionProvider::execQuery(QSqlDatabase &db, const QString &sql)
{
    QSqlQuery query(db);
    if (!query.exec(sql))
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}

int SQLiteConnectionProvider::currentSchemaVersion(QSqlDatabase &db)
{
    QSqlQuery query(db);
    if (!query.exec(QStringLiteral("SELECT version FROM schema_version LIMIT 1")))
    {
        return 0;
    }

    if (!query.next())
    {
        return 0;
    }

    return query.value(0).toInt();
}

bool SQLiteConnectionProvider::setSchemaVersion(QSqlDatabase &db, int version)
{
    QSqlQuery query(db);
    if (!query.exec(QStringLiteral("DELETE FROM schema_version")))
    {
        m_lastError = query.lastError().text();
        return false;
    }

    query.prepare(QStringLiteral("INSERT INTO schema_version(version) VALUES (?)"));
    query.addBindValue(version);
    if (!query.exec())
    {
        m_lastError = query.lastError().text();
        return false;
    }

    return true;
}
}

