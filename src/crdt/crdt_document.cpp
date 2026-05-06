#include "crdt/crdt_document.h"

#include <QJsonArray>

namespace zametki::crdt
{
CRDTDocument::CRDTDocument() = default;

CRDTDocument::CRDTDocument(quint32 siteId)
    : blocks(siteId),
      m_siteId(siteId)
{
}

bool CRDTDocument::isEmpty() const
{
    return id.isEmpty() && title.isEmpty() && tags.isEmpty() && blocks.visibleCount() == 0;
}

void CRDTDocument::clear()
{
    id.clear();
    title.clear();
    tags.clear();
    blocks = CRDTBlockSequence(m_siteId);
    m_appliedOperationIds.clear();
    m_operationLog.clear();
}

bool CRDTDocument::applyUpdateBlockField(const QString &operationId, const CRDTId &blockId, const QString &key, const QVariant &value, quint64 version)
{
    return applyUpdateBlockFieldInternal(operationId, blockId, key, value, version, CRDTOperationType::UpdateBlockField);
}

bool CRDTDocument::applyUpdateDocumentField(const QString &operationId, const QString &key, const QVariant &value)
{
    if (key.isEmpty())
    {
        return false;
    }

    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    if (key == QLatin1String("title"))
    {
        title = value.toString();
    }
    else if (key == QLatin1String("tags"))
    {
        tags = value.toStringList();
    }
    else
    {
        return false;
    }

    m_appliedOperationIds.insert(operationId);
    QJsonObject op = makeOperation(CRDTOperationType::UpdateDocumentField, operationId);
    op.insert(QStringLiteral("key"), key);
    op.insert(QStringLiteral("value"), QJsonValue::fromVariant(value));
    logOperation(op);
    return true;
}

bool CRDTDocument::applyUpdateParagraph(const QString &operationId, const CRDTId &blockId, const CRDTText &text, quint64 version)
{
    QJsonObject textObj = text.serialize();
    return applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("text"), textObj, version, CRDTOperationType::UpdateBlockField);
}

bool CRDTDocument::applyUpdateHeading(const QString &operationId, const CRDTId &blockId, const CRDTText &text, int level, quint64 version)
{
    if (!applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("text"), text.serialize(), version, CRDTOperationType::UpdateBlockField))
    {
        return false;
    }

    return applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("level"), level, version, CRDTOperationType::UpdateBlockField);
}

bool CRDTDocument::applyUpdateTodo(const QString &operationId, const CRDTId &blockId, const CRDTText &text, const core::TodoBlock &data, quint64 version)
{
    if (!applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("text"), text.serialize(), version, CRDTOperationType::UpdateBlockField))
    {
        return false;
    }

    if (!applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("done"), data.done, version, CRDTOperationType::UpdateBlockField))
    {
        return false;
    }

    if (!applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("priority"), data.priority, version, CRDTOperationType::UpdateBlockField))
    {
        return false;
    }

    if (!applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("deadline"), data.deadline, version, CRDTOperationType::UpdateBlockField))
    {
        return false;
    }

    return applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("color"), data.color, version, CRDTOperationType::UpdateBlockField);
}

bool CRDTDocument::applyUpdateUnsupported(const QString &operationId, const CRDTId &blockId, const QString &sourceType, const QVariant &sourceData, quint64 version)
{
    if (!applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("source_type"), sourceType, version, CRDTOperationType::UpdateBlockField))
    {
        return false;
    }

    return applyUpdateBlockFieldInternal(operationId, blockId, QStringLiteral("source_data"), sourceData, version, CRDTOperationType::UpdateBlockField);
}

bool CRDTDocument::applySetBlockType(const QString &operationId, const CRDTId &blockId, core::BlockType type)
{
    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    QVector<CRDTBlockEntry> entries = blocks.exportSequence();
    bool updated = false;
    for (auto &entry : entries)
    {
        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            entry.block.type = type;
            updated = true;
            break;
        }
    }

    if (!updated)
    {
        return false;
    }

    blocks.importSequence(entries);
    m_appliedOperationIds.insert(operationId);
    QJsonObject op = makeOperation(CRDTOperationType::SetBlockType, operationId);
    op.insert(QStringLiteral("block_site"), static_cast<qint64>(blockId.siteId));
    op.insert(QStringLiteral("block_counter"), static_cast<qint64>(blockId.counter));
    op.insert(QStringLiteral("block_type"), static_cast<int>(type));
    logOperation(op);
    return true;
}

bool CRDTDocument::applyInsertBlock(const QString &operationId, const CRDTBlock &block, const CRDTSequenceId &left, const CRDTSequenceId &right)
{
    if (blocks.applyInsert(operationId, block, left, right))
    {
        QJsonObject op = makeOperation(CRDTOperationType::InsertBlock, operationId);
        op.insert(QStringLiteral("left"), left.toString());
        op.insert(QStringLiteral("right"), right.toString());
        op.insert(QStringLiteral("block"), blockToJson(block));
        logOperation(op);
        return true;
    }

    return false;
}

bool CRDTDocument::applyDeleteBlock(const QString &operationId, const CRDTId &blockId)
{
    if (blocks.applyDelete(operationId, blockId))
    {
        QJsonObject op = makeOperation(CRDTOperationType::DeleteBlock, operationId);
        op.insert(QStringLiteral("block_site"), static_cast<qint64>(blockId.siteId));
        op.insert(QStringLiteral("block_counter"), static_cast<qint64>(blockId.counter));
        logOperation(op);
        return true;
    }

    return false;
}

bool CRDTDocument::applyReorderBlock(const QString &operationId, const CRDTId &blockId, const CRDTId &afterBlockId)
{
    if (blocks.applyReorder(operationId, blockId, afterBlockId))
    {
        QJsonObject op = makeOperation(CRDTOperationType::ReorderBlock, operationId);
        op.insert(QStringLiteral("block_site"), static_cast<qint64>(blockId.siteId));
        op.insert(QStringLiteral("block_counter"), static_cast<qint64>(blockId.counter));
        op.insert(QStringLiteral("after_site"), static_cast<qint64>(afterBlockId.siteId));
        op.insert(QStringLiteral("after_counter"), static_cast<qint64>(afterBlockId.counter));
        logOperation(op);
        return true;
    }

    return false;
}

QVector<QJsonObject> CRDTDocument::exportOperations() const
{
    return m_operationLog;
}

void CRDTDocument::importOperations(const QVector<QJsonObject> &operations)
{
    m_operationLog = operations;
    m_appliedOperationIds.clear();
    for (const auto &op : operations)
    {
        const QString opId = op.value(QStringLiteral("id")).toString();
        if (!opId.isEmpty())
        {
            m_appliedOperationIds.insert(opId);
        }
    }
}

int CRDTDocument::mergeOperations(const QVector<QJsonObject> &operations)
{
    int applied = 0;
    for (const auto &op : operations)
    {
        const QString opId = op.value(QStringLiteral("id")).toString();
        if (opId.isEmpty() || m_appliedOperationIds.contains(opId))
        {
            continue;
        }

        const int typeValue = op.value(QStringLiteral("type")).toInt(-1);
        if (typeValue < 0)
        {
            continue;
        }

        const CRDTOperationType type = static_cast<CRDTOperationType>(typeValue);
        bool success = false;

        if (type == CRDTOperationType::UpdateDocumentField)
        {
            const QString key = op.value(QStringLiteral("key")).toString();
            const QVariant value = op.value(QStringLiteral("value")).toVariant();
            success = applyUpdateDocumentField(opId, key, value);
        }
        else if (type == CRDTOperationType::UpdateBlockField)
        {
            CRDTId blockId;
            blockId.siteId = static_cast<quint32>(op.value(QStringLiteral("block_site")).toInteger());
            blockId.counter = static_cast<quint64>(op.value(QStringLiteral("block_counter")).toInteger());
            const QString key = op.value(QStringLiteral("key")).toString();
            const QVariant value = op.value(QStringLiteral("value")).toVariant();
            const quint64 version = static_cast<quint64>(op.value(QStringLiteral("version")).toInteger());
            success = applyUpdateBlockField(opId, blockId, key, value, version);
        }
        else if (type == CRDTOperationType::SetBlockType)
        {
            CRDTId blockId;
            blockId.siteId = static_cast<quint32>(op.value(QStringLiteral("block_site")).toInteger());
            blockId.counter = static_cast<quint64>(op.value(QStringLiteral("block_counter")).toInteger());
            const int typeValueLocal = op.value(QStringLiteral("block_type")).toInt();
            success = applySetBlockType(opId, blockId, static_cast<core::BlockType>(typeValueLocal));
        }
        else if (type == CRDTOperationType::InsertBlock)
        {
            CRDTSequenceId left = CRDTSequenceId::fromString(op.value(QStringLiteral("left")).toString());
            CRDTSequenceId right = CRDTSequenceId::fromString(op.value(QStringLiteral("right")).toString());
            const QJsonObject blockObj = op.value(QStringLiteral("block")).toObject();
            CRDTBlock block = blockFromJson(blockObj);
            success = applyInsertBlock(opId, block, left, right);
        }
        else if (type == CRDTOperationType::DeleteBlock)
        {
            CRDTId blockId;
            blockId.siteId = static_cast<quint32>(op.value(QStringLiteral("block_site")).toInteger());
            blockId.counter = static_cast<quint64>(op.value(QStringLiteral("block_counter")).toInteger());
            success = applyDeleteBlock(opId, blockId);
        }
        else if (type == CRDTOperationType::ReorderBlock)
        {
            CRDTId blockId;
            blockId.siteId = static_cast<quint32>(op.value(QStringLiteral("block_site")).toInteger());
            blockId.counter = static_cast<quint64>(op.value(QStringLiteral("block_counter")).toInteger());
            CRDTId afterBlockId;
            afterBlockId.siteId = static_cast<quint32>(op.value(QStringLiteral("after_site")).toInteger());
            afterBlockId.counter = static_cast<quint64>(op.value(QStringLiteral("after_counter")).toInteger());
            success = applyReorderBlock(opId, blockId, afterBlockId);
        }

        if (success)
        {
            ++applied;
        }
    }

    return applied;
}

QJsonObject CRDTDocument::snapshot() const
{
    QJsonObject root;
    root.insert(QStringLiteral("id"), id);
    root.insert(QStringLiteral("title"), title);

    QJsonArray tagsArray;
    for (const auto &tag : tags)
    {
        tagsArray.append(tag);
    }
    root.insert(QStringLiteral("tags"), tagsArray);

    QJsonArray entriesArray;
    const QVector<CRDTBlockEntry> entries = blocks.exportSequence();
    for (const auto &entry : entries)
    {
        QJsonObject entryObj;
        entryObj.insert(QStringLiteral("pos"), entry.position.toString());
        entryObj.insert(QStringLiteral("deleted"), entry.deleted);
        entryObj.insert(QStringLiteral("block"), blockToJson(entry.block));
        entriesArray.append(entryObj);
    }
    root.insert(QStringLiteral("blocks"), entriesArray);

    QJsonArray applied;
    for (const auto &opId : m_appliedOperationIds)
    {
        applied.append(opId);
    }
    root.insert(QStringLiteral("applied"), applied);

    QJsonArray ops;
    for (const auto &op : m_operationLog)
    {
        ops.append(op);
    }
    root.insert(QStringLiteral("operations"), ops);

    return root;
}

bool CRDTDocument::restoreFromSnapshot(const QJsonObject &object)
{
    if (!object.contains(QStringLiteral("id")))
    {
        return false;
    }

    id = object.value(QStringLiteral("id")).toString();
    title = object.value(QStringLiteral("title")).toString();

    tags.clear();
    const QJsonArray tagsArray = object.value(QStringLiteral("tags")).toArray();
    for (const auto &tagValue : tagsArray)
    {
        if (tagValue.isString())
        {
            tags.append(tagValue.toString());
        }
    }

    QVector<CRDTBlockEntry> entries;
    const QJsonArray entriesArray = object.value(QStringLiteral("blocks")).toArray();
    for (const auto &value : entriesArray)
    {
        if (!value.isObject())
        {
            continue;
        }

        const QJsonObject entryObj = value.toObject();
        CRDTBlockEntry entry;
        entry.position = CRDTSequenceId::fromString(entryObj.value(QStringLiteral("pos")).toString());
        entry.deleted = entryObj.value(QStringLiteral("deleted")).toBool(false);
        entry.block = blockFromJson(entryObj.value(QStringLiteral("block")).toObject());
        entries.push_back(entry);
    }
    blocks.importSequence(entries);

    m_appliedOperationIds.clear();
    const QJsonArray applied = object.value(QStringLiteral("applied")).toArray();
    for (const auto &value : applied)
    {
        if (value.isString())
        {
            m_appliedOperationIds.insert(value.toString());
        }
    }

    m_operationLog.clear();
    const QJsonArray ops = object.value(QStringLiteral("operations")).toArray();
    for (const auto &value : ops)
    {
        if (value.isObject())
        {
            m_operationLog.append(value.toObject());
        }
    }

    return true;
}

bool CRDTDocument::validate() const
{
    QSet<QString> seen;
    const QVector<CRDTBlockEntry> entries = blocks.exportSequence();
    for (const auto &entry : entries)
    {
        const QString key = QString::number(entry.block.id.siteId) + QLatin1Char(':') + QString::number(entry.block.id.counter);
        if (seen.contains(key))
        {
            return false;
        }
        seen.insert(key);

        switch (entry.block.type)
        {
        case core::BlockType::Paragraph:
        case core::BlockType::Heading:
        case core::BlockType::Todo:
        case core::BlockType::Unsupported:
            break;
        default:
            return false;
        }
    }

    return true;
}

void CRDTDocument::logOperation(const QJsonObject &operation)
{
    m_operationLog.append(operation);
}

bool CRDTDocument::applyUpdateBlockFieldInternal(const QString &operationId, const CRDTId &blockId, const QString &key, const QVariant &value, quint64 version, CRDTOperationType type)
{
    if (key.isEmpty())
    {
        return false;
    }

    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    QVector<CRDTBlockEntry> entries = blocks.exportSequence();
    bool updated = false;
    for (auto &entry : entries)
    {
        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            entry.block.data.set(key, value, version);
            updated = true;
            break;
        }
    }

    if (!updated)
    {
        return false;
    }

    blocks.importSequence(entries);
    m_appliedOperationIds.insert(operationId);

    QJsonObject op = makeOperation(type, operationId);
    op.insert(QStringLiteral("block_site"), static_cast<qint64>(blockId.siteId));
    op.insert(QStringLiteral("block_counter"), static_cast<qint64>(blockId.counter));
    op.insert(QStringLiteral("key"), key);
    op.insert(QStringLiteral("value"), QJsonValue::fromVariant(value));
    op.insert(QStringLiteral("version"), static_cast<qint64>(version));
    logOperation(op);
    return true;
}

QJsonObject CRDTDocument::makeOperation(CRDTOperationType type, const QString &operationId) const
{
    QJsonObject op;
    op.insert(QStringLiteral("id"), operationId);
    op.insert(QStringLiteral("type"), static_cast<int>(type));
    return op;
}

QJsonObject CRDTDocument::blockToJson(const CRDTBlock &block) const
{
    QJsonObject object;
    object.insert(QStringLiteral("site"), static_cast<qint64>(block.id.siteId));
    object.insert(QStringLiteral("counter"), static_cast<qint64>(block.id.counter));
    object.insert(QStringLiteral("type"), static_cast<int>(block.type));
    object.insert(QStringLiteral("data"), block.data.serialize());
    return object;
}

CRDTBlock CRDTDocument::blockFromJson(const QJsonObject &object) const
{
    CRDTBlock block;
    block.id.siteId = static_cast<quint32>(object.value(QStringLiteral("site")).toInteger());
    block.id.counter = static_cast<quint64>(object.value(QStringLiteral("counter")).toInteger());
    block.type = static_cast<core::BlockType>(object.value(QStringLiteral("type")).toInt(static_cast<int>(core::BlockType::Paragraph)));
    block.data = CRDTMap::deserialize(object.value(QStringLiteral("data")).toObject());
    return block;
}
}
