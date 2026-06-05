#ifndef ZAMETKI_SEARCH_INDEXER_H
#define ZAMETKI_SEARCH_INDEXER_H

#include <QString>
#include <QStringList>

#include "core/document.h"
#include "storage/sqlite/sqlite_connection_provider.h"

namespace zametki::storage::search
{
class SearchIndexer
{
public:
    explicit SearchIndexer(sqlite::SQLiteConnectionProvider *provider = nullptr);

    void setProvider(sqlite::SQLiteConnectionProvider *provider);

    QString buildContent(const core::Document &document) const;
    bool upsert(const core::Document &document);
    bool remove(const QString &documentId);
    QStringList search(const QString &query, int limit = 20);

    QString lastError() const;

private:
    bool ensureReady();

    sqlite::SQLiteConnectionProvider *m_provider = nullptr;
    QString m_lastError;
};
}

#endif // ZAMETKI_SEARCH_INDEXER_H

