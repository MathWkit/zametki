#include "core/crdt_snapshot_converter.h"

#include <QJsonObject>

#include "core/block_text_accessor.h"
#include "core/unsupported_block.h"
#include "crdt/crdt_id.h"
#include "storage/json/document_file_repository.h"
#include "storage/json/document_json_serializer.h"

namespace zametki::core
{
CRDTSnapshotConverter::CRDTSnapshotConverter(quint32 siteId)
    : m_siteId(siteId)
{
}

quint32 CRDTSnapshotConverter::siteId() const
{
    return m_siteId;
}

void CRDTSnapshotConverter::setSiteId(quint32 siteId)
{
    m_siteId = siteId;
}

crdt::CRDTDocument CRDTSnapshotConverter::toCrdt(const Document &snapshot) const
{
    crdt::CRDTDocument document(m_siteId);
    document.id = snapshot.id;
    document.title = snapshot.title;
    document.tags = snapshot.tags;

    QSet<QString> seen;
    QVector<crdt::CRDTBlockEntry> entries;
    quint64 positionCounter = 0;

    for (const auto &block : snapshot.blocks)
    {
        if (block.id.isEmpty())
        {
            continue;
        }

        if (seen.contains(block.id))
        {
            continue;
        }
        seen.insert(block.id);

        crdt::CRDTBlock crdtBlock;
        crdt::CRDTId blockId;
        if (!parseId(block.id, blockId))
        {
            blockId = crdt::createCRDTId(m_siteId);
        }
        crdtBlock.id = blockId;
        crdtBlock.type = block.type;

        if (block.type == BlockType::Paragraph)
        {
            core::ParagraphBlock data = block.data.value<core::ParagraphBlock>();
            crdt::CRDTText text(m_siteId);
            text.fromQString(data.text, m_siteId);
            crdtBlock.data.set(QStringLiteral("text"), text.serialize(), 0);
        }
        else if (block.type == BlockType::Heading)
        {
            core::HeadingBlock data = block.data.value<core::HeadingBlock>();
            crdt::CRDTText text(m_siteId);
            text.fromQString(data.text, m_siteId);
            crdtBlock.data.set(QStringLiteral("text"), text.serialize(), 0);
            crdtBlock.data.set(QStringLiteral("level"), data.level, 0);
        }
        else if (block.type == BlockType::Todo)
        {
            core::TodoBlock data = block.data.value<core::TodoBlock>();
            crdt::CRDTText text(m_siteId);
            text.fromQString(data.text, m_siteId);
            crdtBlock.data.set(QStringLiteral("text"), text.serialize(), 0);
            crdtBlock.data.set(QStringLiteral("done"), data.done, 0);
            crdtBlock.data.set(QStringLiteral("priority"), data.priority, 0);
            crdtBlock.data.set(QStringLiteral("deadline"), data.deadline, 0);
            crdtBlock.data.set(QStringLiteral("color"), data.color, 0);
        }
        else if (block.type == BlockType::Unsupported)
        {
            core::UnsupportedBlock data = block.data.value<core::UnsupportedBlock>();
            crdtBlock.data.set(QStringLiteral("source_type"), data.sourceType, 0);
            crdtBlock.data.set(QStringLiteral("source_data"), data.sourceData, 0);
        }
        else
        {
            const QString text = core::BlockTextAccessor::getText(block);
            crdt::CRDTText crdtText(m_siteId);
            crdtText.fromQString(text, m_siteId);
            crdtBlock.data.set(QStringLiteral("text"), crdtText.serialize(), 0);
        }

        crdt::CRDTBlockEntry entry;
        entry.block = crdtBlock;
        entry.deleted = false;
        entry.position.siteId = m_siteId;
        entry.position.counter = ++positionCounter;
        entries.push_back(entry);
    }

    document.blocks.importSequence(entries);
    return document;
}

Document CRDTSnapshotConverter::toSnapshot(const crdt::CRDTDocument &document) const
{
    Document snapshot;
    snapshot.id = document.id;
    snapshot.title = document.title;
    snapshot.tags = document.tags;

    QSet<QString> seen;
    const QVector<crdt::CRDTBlockEntry> entries = document.blocks.exportSequence();

    for (const auto &entry : entries)
    {
        if (entry.deleted)
        {
            continue;
        }

        const QString blockId = toStringId(entry.block.id);
        if (blockId.isEmpty())
        {
            continue;
        }

        if (seen.contains(blockId))
        {
            continue;
        }
        seen.insert(blockId);

        core::Block block;
        block.id = blockId;
        block.type = entry.block.type;

        if (entry.block.type == BlockType::Paragraph)
        {
            core::ParagraphBlock data;
            QJsonObject textObj = entry.block.data.value(QStringLiteral("text")).toJsonObject();
            crdt::CRDTText text = crdt::CRDTText::deserialize(textObj);
            data.text = text.toQString();
            block.data = QVariant::fromValue(data);
        }
        else if (entry.block.type == BlockType::Heading)
        {
            core::HeadingBlock data;
            QJsonObject textObj = entry.block.data.value(QStringLiteral("text")).toJsonObject();
            crdt::CRDTText text = crdt::CRDTText::deserialize(textObj);
            data.text = text.toQString();
            data.level = entry.block.data.value(QStringLiteral("level")).toInt();
            block.data = QVariant::fromValue(data);
        }
        else if (entry.block.type == BlockType::Todo)
        {
            core::TodoBlock data;
            QJsonObject textObj = entry.block.data.value(QStringLiteral("text")).toJsonObject();
            crdt::CRDTText text = crdt::CRDTText::deserialize(textObj);
            data.text = text.toQString();
            data.done = entry.block.data.value(QStringLiteral("done")).toBool();
            data.priority = entry.block.data.value(QStringLiteral("priority")).toString();
            data.deadline = entry.block.data.value(QStringLiteral("deadline")).toDate();
            data.color = entry.block.data.value(QStringLiteral("color")).toString();
            block.data = QVariant::fromValue(data);
        }
        else if (entry.block.type == BlockType::Unsupported)
        {
            core::UnsupportedBlock data;
            data.sourceType = entry.block.data.value(QStringLiteral("source_type")).toString();
            data.sourceData = entry.block.data.value(QStringLiteral("source_data")).toMap();
            block.data = QVariant::fromValue(data);
        }
        else
        {
            core::ParagraphBlock data;
            QJsonObject textObj = entry.block.data.value(QStringLiteral("text")).toJsonObject();
            crdt::CRDTText text = crdt::CRDTText::deserialize(textObj);
            data.text = text.toQString();
            block.type = BlockType::Paragraph;
            block.data = QVariant::fromValue(data);
        }

        snapshot.blocks.push_back(block);
    }

    return snapshot;
}

bool CRDTSnapshotConverter::loadFromRepository(const QString &id,
                                               const storage::json::DocumentFileRepository &repository,
                                               const storage::json::DocumentJsonSerializer &serializer,
                                               crdt::CRDTDocument &outDocument)
{
    Q_UNUSED(serializer)
    const core::Document snapshot = repository.read(id);
    if (snapshot.id.isEmpty())
    {
        return false;
    }

    outDocument = toCrdt(snapshot);
    storeSnapshot(snapshot);
    return true;
}

bool CRDTSnapshotConverter::saveToRepository(const QString &id,
                                             const crdt::CRDTDocument &document,
                                             const storage::json::DocumentFileRepository &repository,
                                             const storage::json::DocumentJsonSerializer &serializer)
{
    Q_UNUSED(serializer)
    Document snapshot = toSnapshot(document);
    if (snapshot.id.isEmpty())
    {
        snapshot.id = id;
    }

    if (!repository.write(snapshot.id, snapshot))
    {
        return false;
    }

    storeSnapshot(snapshot);
    return true;
}

void CRDTSnapshotConverter::storeSnapshot(const Document &snapshot)
{
    if (!snapshot.id.isEmpty())
    {
        m_snapshotCache.insert(snapshot.id, snapshot);
    }
}

bool CRDTSnapshotConverter::hasSnapshot(const QString &id) const
{
    return m_snapshotCache.contains(id);
}

Document CRDTSnapshotConverter::cachedSnapshot(const QString &id) const
{
    return m_snapshotCache.value(id);
}

void CRDTSnapshotConverter::clearCache()
{
    m_snapshotCache.clear();
}

QString CRDTSnapshotConverter::toStringId(const crdt::CRDTId &id) const
{
    return QString::number(id.siteId) + QLatin1Char(':') + QString::number(id.counter);
}

bool CRDTSnapshotConverter::parseId(const QString &text, crdt::CRDTId &id) const
{
    const QStringList parts = text.split(QLatin1Char(':'));
    if (parts.size() != 2)
    {
        return false;
    }

    bool okSite = false;
    bool okCounter = false;
    id.siteId = parts.at(0).toUInt(&okSite);
    id.counter = parts.at(1).toULongLong(&okCounter);
    return okSite && okCounter;
}
}

