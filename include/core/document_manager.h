#ifndef ZAMETKI_DOCUMENT_MANAGER_H
#define ZAMETKI_DOCUMENT_MANAGER_H

#include <QObject>
#include <QString>

#include "core/document.h"
#include "core/block_type.h"
#include "core/blocks/todo_block.h"
#include "core/id_generator.h"
#include "core/crdt_snapshot_converter.h"
#include "crdt/crdt_document.h"
#include "storage/json/document_file_repository.h"
#include "storage/json/document_json_serializer.h"
#include "storage/sqlite/sqlite_connection_provider.h"
#include "storage/sqlite/sqlite_note_index_repository.h"
#include "storage/sqlite/sqlite_links_repository.h"
#include "storage/search/search_indexer.h"
#include "core/link_parser.h"

namespace zametki::core
{
class DocumentManager : public QObject
{
    Q_OBJECT
public:
    explicit DocumentManager(QObject *parent = nullptr);

    Document getSnapshot() const;
    QString lastError() const;

    QVector<Document> listAllDocuments();
    QVector<Document> searchDocuments(const QString &query);
    QVector<Document> getBacklinks(const QString &noteId);

    bool load(const QString &id);
    bool save();
    bool createEmptyDocument();
    bool renameDocument(const QString &title);
    bool deleteDocument(const QString &id);

    void applyTextInsert(const QString &blockId, int position, const QString &text);
    void applyTextDelete(const QString &blockId, int position, int length);

    void insertBlock(const QString &afterBlockId, BlockType type);
    void deleteBlock(const QString &blockId);

    void updateTodoBlock(const QString &blockId, const TodoBlock &data);

signals:
    void snapshotChanged();

private:
    bool parseBlockId(const QString &text, crdt::CRDTId &outId) const;
    QString makeBlockId(const crdt::CRDTId &id) const;
    void updateSnapshot();
    void setError(const QString &message);

    crdt::CRDTDocument m_document;
    Document m_snapshot;
    storage::json::DocumentFileRepository m_repository;
    storage::json::DocumentJsonSerializer m_serializer;
    CRDTSnapshotConverter m_converter;
    UuidIdGenerator m_idGenerator;
    QString m_lastError;
    quint32 m_siteId = 0;
    quint64 m_blockVersionCounter = 0;
    storage::sqlite::SQLiteConnectionProvider m_sqliteProvider;
    storage::sqlite::SQLiteNoteIndexRepository m_noteIndexRepository;
    storage::sqlite::SQLiteLinksRepository m_linksRepository;
    storage::search::SearchIndexer m_searchIndexer;
    core::LinkParser m_linkParser;
};
}

#endif // ZAMETKI_DOCUMENT_MANAGER_H

