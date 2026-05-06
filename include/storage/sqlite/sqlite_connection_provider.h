#ifndef ZAMETKI_SQLITE_CONNECTION_PROVIDER_H
#define ZAMETKI_SQLITE_CONNECTION_PROVIDER_H

#include <QSqlDatabase>
#include <QString>

namespace zametki::storage::sqlite
{
class SQLiteConnectionProvider
{
public:
    explicit SQLiteConnectionProvider(const QString &databasePath = QString());

    void setDatabasePath(const QString &databasePath);
    QString databasePath() const;

    QSqlDatabase database() const;
    bool open();
    bool ensureSchema();
    QString lastError() const;

private:
    bool execQuery(QSqlDatabase &db, const QString &sql);
    int currentSchemaVersion(QSqlDatabase &db);
    bool setSchemaVersion(QSqlDatabase &db, int version);

    QString m_databasePath;
    QString m_connectionName;
    QString m_lastError;
};
}

#endif // ZAMETKI_SQLITE_CONNECTION_PROVIDER_H

