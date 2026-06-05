#include "core/document_manager.h"

#include <QDate>
#include <QDir>
#include <QStandardPaths>
#include <QStringList>
#include <QSet>

#include "core/block_text_accessor.h"
#include "crdt/crdt_id.h"

namespace zametki::core
{
DocumentManager::DocumentManager(QObject *parent)
    : QObject(parent),
      m_siteId(m_idGenerator.createSiteId()),
      m_repository(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/notes")),
      m_converter(m_siteId),
      m_sqliteProvider(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/index.db")),
      m_noteIndexRepository(&m_sqliteProvider),
      m_linksRepository(&m_sqliteProvider),
      m_searchIndexer(&m_sqliteProvider)
{
    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/notes"));
    m_document = crdt::CRDTDocument(m_siteId);
}

bool DocumentManager::setStorageRoot(const QString &notesPath)
{
    const QString trimmed = notesPath.trimmed();
    if (trimmed.isEmpty())
    {
        setError(QStringLiteral("storage_path_empty"));
        return false;
    }

    QDir dir(trimmed);
    if (!dir.exists() && !dir.mkpath(QStringLiteral(".")))
    {
        setError(QStringLiteral("storage_path_create_failed"));
        return false;
    }

    const QString absoluteNotesPath = dir.absolutePath();
    m_repository = storage::json::DocumentFileRepository(absoluteNotesPath);

    const QString indexPath = dir.absoluteFilePath(QStringLiteral("index.db"));
    m_sqliteProvider.setDatabasePath(indexPath);
    m_noteIndexRepository.setProvider(&m_sqliteProvider);
    m_linksRepository.setProvider(&m_sqliteProvider);
    m_searchIndexer.setProvider(&m_sqliteProvider);

    return true;
}

Document DocumentManager::getSnapshot() const
{
    return m_snapshot;
}

QString DocumentManager::lastError() const
{
    return m_lastError;
}

QVector<Document> DocumentManager::listAllDocuments()
{
    setError(QString());
    QVector<Document> documents;
    const QList<QString> ids = m_repository.listAll();
    documents.reserve(ids.size());

    for (const auto &id : ids)
    {
        Document snapshot;
        if (m_converter.hasSnapshot(id))
        {
            snapshot = m_converter.cachedSnapshot(id);
        }
        else
        {
            snapshot = m_repository.read(id);
            if (snapshot.id.isEmpty())
            {
                continue;
            }
            m_converter.storeSnapshot(snapshot);
        }

        documents.push_back(snapshot);
    }

    return documents;
}

QVector<Document> DocumentManager::searchDocuments(const QString &query)
{
    setError(QString());
    const QString trimmed = query.trimmed();
    if (trimmed.isEmpty())
    {
        return listAllDocuments();
    }

    QVector<Document> documents;
    const QStringList ids = m_searchIndexer.search(trimmed);
    documents.reserve(ids.size());

    QSet<QString> seen;
    for (const auto &id : ids)
    {
        if (seen.contains(id))
        {
            continue;
        }
        seen.insert(id);

        Document snapshot;
        if (m_converter.hasSnapshot(id))
        {
            snapshot = m_converter.cachedSnapshot(id);
        }
        else
        {
            snapshot = m_repository.read(id);
            if (snapshot.id.isEmpty())
            {
                continue;
            }
            m_converter.storeSnapshot(snapshot);
        }

        documents.push_back(snapshot);
    }

    return documents;
}

QVector<Document> DocumentManager::getBacklinks(const QString &noteId)
{
    setError(QString());
    QVector<Document> documents;
    const QStringList ids = m_linksRepository.getBacklinks(noteId);
    documents.reserve(ids.size());

    QSet<QString> seen;
    for (const auto &id : ids)
    {
        if (seen.contains(id))
        {
            continue;
        }
        seen.insert(id);

        Document snapshot;
        if (m_converter.hasSnapshot(id))
        {
            snapshot = m_converter.cachedSnapshot(id);
        }
        else
        {
            snapshot = m_repository.read(id);
            if (snapshot.id.isEmpty())
            {
                continue;
            }
            m_converter.storeSnapshot(snapshot);
        }

        documents.push_back(snapshot);
    }

    return documents;
}

bool DocumentManager::load(const QString &id)
{
    setError(QString());
    crdt::CRDTDocument document(m_siteId);
    if (!m_converter.loadFromRepository(id, m_repository, m_serializer, document))
    {
        setError(m_repository.lastError().isEmpty() ? QStringLiteral("load_failed") : m_repository.lastError());
        return false;
    }

    m_document = document;
    updateSnapshot();
    emit snapshotChanged();
    return true;
}

bool DocumentManager::save()
{
    setError(QString());
    if (!m_converter.saveToRepository(m_document.id, m_document, m_repository, m_serializer))
    {
        setError(m_repository.lastError().isEmpty() ? QStringLiteral("save_failed") : m_repository.lastError());
        return false;
    }

    updateSnapshot();

    const QString path = m_repository.documentPath(m_document.id);
    if (!m_noteIndexRepository.upsertNote(m_document.id, m_document.title, path))
    {
        setError(m_noteIndexRepository.lastError());
        return false;
    }

    if (!m_noteIndexRepository.upsertTags(m_document.id, m_document.tags))
    {
        setError(m_noteIndexRepository.lastError());
        return false;
    }

    if (!m_noteIndexRepository.cleanupOrphanTags())
    {
        setError(m_noteIndexRepository.lastError());
        return false;
    }

    if (!m_searchIndexer.upsert(m_snapshot))
    {
        setError(m_searchIndexer.lastError());
        return false;
    }

    if (!m_linksRepository.clearLinks(m_document.id))
    {
        setError(m_linksRepository.lastError());
        return false;
    }

    QSet<QString> linkKeys;
    QVector<storage::sqlite::LinkRecord> linkRecords;
    for (const auto &block : m_snapshot.blocks)
    {
        const QString text = core::BlockTextAccessor::getText(block);
        const auto links = m_linkParser.parse(text);
        for (const auto &link : links)
        {
            storage::sqlite::LinkRecord record;
            const QString resolved = m_linksRepository.resolveTitleToId(link.target);
            if (!resolved.isEmpty())
            {
                record.toNoteId = resolved;
            }
            else
            {
                record.toNoteTitle = link.target;
            }

            const QString key = record.toNoteId + QLatin1Char('|') + record.toNoteTitle;
            if (linkKeys.contains(key))
            {
                continue;
            }
            linkKeys.insert(key);
            linkRecords.push_back(record);
        }
    }

    if (!linkRecords.isEmpty())
    {
        if (!m_linksRepository.insertLinks(m_document.id, linkRecords))
        {
            setError(m_linksRepository.lastError());
            return false;
        }
    }

    return true;
}

bool DocumentManager::createEmptyDocument()
{
    setError(QString());
    const QVector<Document> existingDocuments = listAllDocuments();
    QString title = QStringLiteral("Новая заметка");
    int suffix = 2;
    QSet<QString> existingTitles;
    for (const auto &document : existingDocuments)
    {
        if (!document.title.trimmed().isEmpty())
        {
            existingTitles.insert(document.title.trimmed());
        }
    }
    while (existingTitles.contains(title))
    {
        title = QStringLiteral("Новая заметка %1").arg(suffix++);
    }

    m_document = crdt::CRDTDocument(m_siteId);
    m_document.id = m_idGenerator.create();
    m_document.title = title;
    m_document.tags.clear();
    m_document.blocks = crdt::CRDTBlockSequence(m_siteId);

    crdt::CRDTBlock block;
    block.id = crdt::createCRDTId(m_siteId);
    block.type = BlockType::Paragraph;
    crdt::CRDTText text(m_siteId);
    text.fromQString(QString(), m_siteId);
    block.data.set(QStringLiteral("text"), text.serialize(), 0);

    const QString opId = m_idGenerator.createOperationId();
    if (m_document.applyInsertBlock(opId, block, crdt::CRDTSequenceId(), crdt::CRDTSequenceId()))
    {
        updateSnapshot();
        emit snapshotChanged();
        return true;
    }

    updateSnapshot();
    emit snapshotChanged();
    return true;
}

bool DocumentManager::renameDocument(const QString &title)
{
    const QString opId = m_idGenerator.createOperationId();
    if (!m_document.applyUpdateDocumentField(opId, QStringLiteral("title"), title))
    {
        setError(QStringLiteral("rename_failed"));
        return false;
    }

    updateSnapshot();
    emit snapshotChanged();
    return true;
}

bool DocumentManager::deleteDocument(const QString &id)
{
    setError(QString());
    if (!m_repository.remove(id))
    {
        setError(m_repository.lastError().isEmpty() ? QStringLiteral("delete_failed") : m_repository.lastError());
        return false;
    }

    if (!m_noteIndexRepository.deleteNote(id))
    {
        setError(m_noteIndexRepository.lastError());
        return false;
    }

    if (!m_noteIndexRepository.cleanupOrphanTags())
    {
        setError(m_noteIndexRepository.lastError());
        return false;
    }

    if (!m_searchIndexer.remove(id))
    {
        setError(m_searchIndexer.lastError());
        return false;
    }

    if (m_document.id == id)
    {
        m_document.clear();
        m_snapshot = {};
        emit snapshotChanged();
    }

    return true;
}

void DocumentManager::applyTextInsert(const QString &blockId, int position, const QString &text)
{
    crdt::CRDTId id;
    if (!parseBlockId(blockId, id))
    {
        return;
    }

    QVector<crdt::CRDTBlockEntry> entries = m_document.blocks.exportSequence();
    bool updated = false;

    for (auto &entry : entries)
    {
        if (entry.deleted)
        {
            continue;
        }

        if (entry.block.id.siteId == id.siteId && entry.block.id.counter == id.counter)
        {
            QJsonObject textObj = entry.block.data.value(QStringLiteral("text")).toJsonObject();
            crdt::CRDTText crdtText = crdt::CRDTText::deserialize(textObj);
            crdtText.setSiteId(m_siteId);
            const QString opId = m_idGenerator.createOperationId();
            if (!crdtText.applyInsert(opId, position, text))
            {
                return;
            }

            const QString opFieldId = m_idGenerator.createOperationId();
            m_document.applyUpdateBlockField(opFieldId, id, QStringLiteral("text"), crdtText.serialize(), ++m_blockVersionCounter);
            updated = true;
            break;
        }
    }

    if (updated)
    {
        updateSnapshot();
        emit snapshotChanged();
    }
}

void DocumentManager::applyTextDelete(const QString &blockId, int position, int length)
{
    crdt::CRDTId id;
    if (!parseBlockId(blockId, id))
    {
        return;
    }

    QVector<crdt::CRDTBlockEntry> entries = m_document.blocks.exportSequence();
    bool updated = false;

    for (auto &entry : entries)
    {
        if (entry.deleted)
        {
            continue;
        }

        if (entry.block.id.siteId == id.siteId && entry.block.id.counter == id.counter)
        {
            QJsonObject textObj = entry.block.data.value(QStringLiteral("text")).toJsonObject();
            crdt::CRDTText crdtText = crdt::CRDTText::deserialize(textObj);
            crdtText.setSiteId(m_siteId);
            const QString opId = m_idGenerator.createOperationId();
            if (!crdtText.applyDelete(opId, position, length))
            {
                return;
            }

            const QString opFieldId = m_idGenerator.createOperationId();
            m_document.applyUpdateBlockField(opFieldId, id, QStringLiteral("text"), crdtText.serialize(), ++m_blockVersionCounter);
            updated = true;
            break;
        }
    }

    if (updated)
    {
        updateSnapshot();
        emit snapshotChanged();
    }
}

QString DocumentManager::insertBlock(const QString &afterBlockId, BlockType type)
{
    if (m_document.id.isEmpty())
    {
        m_document.id = m_idGenerator.create();
        m_document.title.clear();
        m_document.tags.clear();
    }

    crdt::CRDTId afterId;
    if (!afterBlockId.isEmpty() && !parseBlockId(afterBlockId, afterId))
    {
        return {};
    }

    crdt::CRDTBlock block;
    block.id = crdt::createCRDTId(m_siteId);
    block.type = type;

    if (type == BlockType::Paragraph)
    {
        crdt::CRDTText text(m_siteId);
        text.fromQString(QString(), m_siteId);
        block.data.set(QStringLiteral("text"), text.serialize(), 0);
    }
    else if (type == BlockType::Heading)
    {
        crdt::CRDTText text(m_siteId);
        text.fromQString(QString(), m_siteId);
        block.data.set(QStringLiteral("text"), text.serialize(), 0);
        block.data.set(QStringLiteral("level"), 1, 0);
    }
    else if (type == BlockType::Todo)
    {
        crdt::CRDTText text(m_siteId);
        text.fromQString(QString(), m_siteId);
        block.data.set(QStringLiteral("text"), text.serialize(), 0);
        block.data.set(QStringLiteral("done"), false, 0);
        block.data.set(QStringLiteral("priority"), QString(), 0);
        block.data.set(QStringLiteral("deadline"), QDate(), 0);
        block.data.set(QStringLiteral("color"), QString(), 0);
    }
    else if (type == BlockType::Unsupported)
    {
        block.data.set(QStringLiteral("source_type"), QStringLiteral("unsupported"), 0);
        block.data.set(QStringLiteral("source_data"), QVariantMap(), 0);
    }

    crdt::CRDTSequenceId left;
    crdt::CRDTSequenceId right;
    const QVector<crdt::CRDTBlockEntry> entries = m_document.blocks.exportSequence();

    if (afterId.siteId != 0 || afterId.counter != 0)
    {
        for (int i = 0; i < entries.size(); ++i)
        {
            const auto &entry = entries.at(i);
            if (!entry.deleted && entry.block.id.siteId == afterId.siteId && entry.block.id.counter == afterId.counter)
            {
                left = entry.position;
                for (int j = i + 1; j < entries.size(); ++j)
                {
                    if (!entries.at(j).deleted)
                    {
                        right = entries.at(j).position;
                        break;
                    }
                }
                break;
            }
        }
    }

    if (!left.isValid())
    {
        for (const auto &entry : entries)
        {
            if (!entry.deleted)
            {
                right = entry.position;
                break;
            }
        }
    }

    const QString opId = m_idGenerator.createOperationId();
    if (m_document.applyInsertBlock(opId, block, left, right))
    {
        updateSnapshot();
        emit snapshotChanged();
        return makeBlockId(block.id);
    }

    return {};
}

void DocumentManager::deleteBlock(const QString &blockId)
{
    crdt::CRDTId id;
    if (!parseBlockId(blockId, id))
    {
        return;
    }

    const QString opId = m_idGenerator.createOperationId();
    if (m_document.applyDeleteBlock(opId, id))
    {
        updateSnapshot();
        emit snapshotChanged();
    }
}

void DocumentManager::updateTodoBlock(const QString &blockId, const TodoBlock &data)
{
    crdt::CRDTId id;
    if (!parseBlockId(blockId, id))
    {
        return;
    }

    crdt::CRDTText text(m_siteId);
    text.fromQString(data.text, m_siteId);
    const QString opId = m_idGenerator.createOperationId();
    if (m_document.applyUpdateTodo(opId, id, text, data, ++m_blockVersionCounter))
    {
        updateSnapshot();
        emit snapshotChanged();
    }
}

void DocumentManager::convertBlockType(const QString &blockId, BlockType type, int headingLevel, bool todoDone)
{
    crdt::CRDTId id;
    if (!parseBlockId(blockId, id))
    {
        return;
    }

    const QString typeOpId = m_idGenerator.createOperationId();
    if (!m_document.applySetBlockType(typeOpId, id, type))
    {
        return;
    }

    if (type == BlockType::Heading)
    {
        const int level = qBound(1, headingLevel, 3);
        const QString levelOpId = m_idGenerator.createOperationId();
        m_document.applyUpdateBlockField(levelOpId, id, QStringLiteral("level"), level, ++m_blockVersionCounter);
    }
    else if (type == BlockType::Todo)
    {
        const QString doneOpId = m_idGenerator.createOperationId();
        m_document.applyUpdateBlockField(doneOpId, id, QStringLiteral("done"), todoDone, ++m_blockVersionCounter);
        const QString priorityOpId = m_idGenerator.createOperationId();
        m_document.applyUpdateBlockField(priorityOpId, id, QStringLiteral("priority"), QString(), ++m_blockVersionCounter);
        const QString deadlineOpId = m_idGenerator.createOperationId();
        m_document.applyUpdateBlockField(deadlineOpId, id, QStringLiteral("deadline"), QDate(), ++m_blockVersionCounter);
        const QString colorOpId = m_idGenerator.createOperationId();
        m_document.applyUpdateBlockField(colorOpId, id, QStringLiteral("color"), QString(), ++m_blockVersionCounter);
    }

    updateSnapshot();
    emit snapshotChanged();
}

bool DocumentManager::parseBlockId(const QString &text, crdt::CRDTId &outId) const
{
    const QStringList parts = text.split(QLatin1Char(':'));
    if (parts.size() != 2)
    {
        return false;
    }

    bool okSite = false;
    bool okCounter = false;
    outId.siteId = parts.at(0).toUInt(&okSite);
    outId.counter = parts.at(1).toULongLong(&okCounter);
    return okSite && okCounter;
}

QString DocumentManager::makeBlockId(const crdt::CRDTId &id) const
{
    return QString::number(id.siteId) + QLatin1Char(':') + QString::number(id.counter);
}

void DocumentManager::updateSnapshot()
{
    m_snapshot = m_converter.toSnapshot(m_document);
}

void DocumentManager::setError(const QString &message)
{
    m_lastError = message;
}
}
