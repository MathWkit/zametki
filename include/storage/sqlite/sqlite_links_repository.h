#ifndef ZAMETKI_SQLITE_LINKS_REPOSITORY_H
#define ZAMETKI_SQLITE_LINKS_REPOSITORY_H

#include <QString>
#include <QStringList>
#include <QVector>

#include "core/graph_edge.h"
#include "storage/sqlite/sqlite_connection_provider.h"

namespace zametki::storage::sqlite
{
struct LinkRecord
{
    QString toNoteId;
    QString toNoteTitle;
};

class SQLiteLinksRepository
{
public:
    explicit SQLiteLinksRepository(SQLiteConnectionProvider *provider = nullptr);

    void setProvider(SQLiteConnectionProvider *provider);

    bool clearLinks(const QString &fromNoteId);
    bool insertLinks(const QString &fromNoteId, const QVector<LinkRecord> &links);

    QStringList getOutgoingLinks(const QString &noteId);
    QStringList getBacklinks(const QString &noteId);

    QString resolveTitleToId(const QString &title);

    QVector<core::GraphEdge> neighborsDepth1(const QString &noteId);
    QVector<core::GraphEdge> neighborsDepth2(const QString &noteId);

    QString lastError() const;

private:
    bool ensureReady();
    QString noteTitleById(const QString &noteId);

    SQLiteConnectionProvider *m_provider = nullptr;
    QString m_lastError;
};
}

#endif // ZAMETKI_SQLITE_LINKS_REPOSITORY_H

