#include "storage/json/document_json_serializer.h"

#include <QDate>
#include <QDateTime>
#include <QDebug>
#include <QJsonArray>
#include <QSet>
#include <QVariantMap>

#include "storage/json/block_type_codec.h"

namespace zametki::storage::json
{

QJsonObject DocumentJsonSerializer::serialize(const core::Document &document) const
{
    QJsonObject object;
    object.insert(QStringLiteral("format_version"), getCurrentFormatVersion());
    object.insert(QStringLiteral("snapshot_timestamp"), QDateTime::currentDateTimeUtc().toString(Qt::ISODate));
    object.insert(QStringLiteral("operations_count"), 0);
    object.insert(QStringLiteral("id"), document.id);
    object.insert(QStringLiteral("title"), document.title);

    QJsonArray tagsArray;
    for (const QString &tag : document.tags)
    {
        tagsArray.append(tag);
    }
    object.insert(QStringLiteral("tags"), tagsArray);

    QJsonArray blocksArray;
    for (const core::Block &block : document.blocks)
    {
        blocksArray.append(serializeBlock(block));
    }
    object.insert(QStringLiteral("blocks"), blocksArray);

    return object;
}

core::Document DocumentJsonSerializer::deserialize(const QJsonObject &object) const
{
    QString error;
    if (!validateFormatVersion(object, error))
    {
        qWarning().noquote() << QStringLiteral("Document JSON validation failed:") << error;
        return {};
    }

    const QString version = object.contains(QStringLiteral("format_version"))
                                ? object.value(QStringLiteral("format_version")).toString()
                                : QStringLiteral("v1");
    if (version == QStringLiteral("v1"))
    {
        qWarning() << "Document loaded in v1 format, auto-migrating to v2";
    }

    if (!validateDocumentObject(object, error))
    {
        qWarning().noquote() << QStringLiteral("Document JSON validation failed:") << error;
        return {};
    }

    core::Document document;
    document.id = object.value(QStringLiteral("id")).toString();
    document.title = object.value(QStringLiteral("title")).toString();

    const QJsonArray tagsArray = object.value(QStringLiteral("tags")).toArray();
    for (const auto &tagValue : tagsArray)
    {
        if (tagValue.isString())
        {
            document.tags.append(tagValue.toString());
        }
    }

    const QJsonArray blocksArray = object.value(QStringLiteral("blocks")).toArray();
    for (const auto &blockValue : blocksArray)
    {
        if (!blockValue.isObject())
        {
            continue;
        }

        const QJsonObject blockObject = blockValue.toObject();
        QString blockError;
        if (!validateBlockObject(blockObject, blockError))
        {
            qWarning().noquote() << QStringLiteral("Skipping invalid block:") << blockError;
            continue;
        }

        document.blocks.append(deserializeBlock(blockObject));
    }

    if (version == QStringLiteral("v1"))
    {
        return migrateFromV1ToV2(document);
    }
    return document;
}

QJsonObject DocumentJsonSerializer::serializeParagraphBlock(const core::ParagraphBlock &block) const
{
    QJsonObject object;
    object.insert(QStringLiteral("text"), block.text);
    return object;
}

QJsonObject DocumentJsonSerializer::serializeHeadingBlock(const core::HeadingBlock &block) const
{
    QJsonObject object;
    object.insert(QStringLiteral("text"), block.text);
    object.insert(QStringLiteral("level"), block.level);
    return object;
}

QJsonObject DocumentJsonSerializer::serializeTodoBlock(const core::TodoBlock &block) const
{
    QJsonObject object;
    object.insert(QStringLiteral("text"), block.text);
    object.insert(QStringLiteral("done"), block.done);
    object.insert(QStringLiteral("priority"), block.priority);
    object.insert(QStringLiteral("deadline"), block.deadline.toString(Qt::ISODate));
    object.insert(QStringLiteral("color"), block.color);
    return object;
}

QJsonObject DocumentJsonSerializer::serializeBlock(const core::Block &block) const
{
    QJsonObject blockObject;
    blockObject.insert(QStringLiteral("id"), block.id);

    if (block.type == core::BlockType::Unsupported)
    {
        QString sourceType = QStringLiteral("unsupported");
        QJsonObject sourceData;

        if (block.data.canConvert<QVariantMap>())
        {
            const QVariantMap map = block.data.toMap();
            const QString storedSourceType = map.value(QStringLiteral("sourceType")).toString();
            if (!storedSourceType.isEmpty())
            {
                sourceType = storedSourceType;
            }
            sourceData = QJsonObject::fromVariantMap(map.value(QStringLiteral("sourceData")).toMap());
        }

        blockObject.insert(QStringLiteral("type"), sourceType);
        blockObject.insert(QStringLiteral("data"), sourceData);
        return blockObject;
    }

    blockObject.insert(QStringLiteral("type"), BlockTypeCodec::toString(block.type));

    if (block.type == core::BlockType::Paragraph)
    {
        core::ParagraphBlock paragraphBlock;
        if (block.data.canConvert<QVariantMap>())
        {
            const QVariantMap map = block.data.toMap();
            paragraphBlock.text = map.value(QStringLiteral("text")).toString();
        }
        else
        {
            paragraphBlock.text = block.data.toString();
        }
        blockObject.insert(QStringLiteral("data"), serializeParagraphBlock(paragraphBlock));
    }
    else if (block.type == core::BlockType::Heading)
    {
        core::HeadingBlock headingBlock;
        if (block.data.canConvert<QVariantMap>())
        {
            const QVariantMap map = block.data.toMap();
            headingBlock.text = map.value(QStringLiteral("text")).toString();
            headingBlock.level = map.value(QStringLiteral("level"), 1).toInt();
        }
        else
        {
            headingBlock.text = block.data.toString();
        }
        blockObject.insert(QStringLiteral("data"), serializeHeadingBlock(headingBlock));
    }
    else if (block.type == core::BlockType::Todo)
    {
        core::TodoBlock todoBlock;
        if (block.data.canConvert<QVariantMap>())
        {
            const QVariantMap map = block.data.toMap();
            todoBlock.text = map.value(QStringLiteral("text")).toString();
            todoBlock.done = map.value(QStringLiteral("done"), false).toBool();
            todoBlock.priority = map.value(QStringLiteral("priority")).toString();
            todoBlock.deadline = QDate::fromString(map.value(QStringLiteral("deadline")).toString(), Qt::ISODate);
            todoBlock.color = map.value(QStringLiteral("color")).toString();
        }
        else
        {
            todoBlock.text = block.data.toString();
        }
        blockObject.insert(QStringLiteral("data"), serializeTodoBlock(todoBlock));
    }
    else
    {
        blockObject.insert(QStringLiteral("data"), QJsonObject{});
    }

    return blockObject;
}

core::Block DocumentJsonSerializer::deserializeBlock(const QJsonObject &object) const
{
    core::Block block;

    if (object.contains(QStringLiteral("id")) && object.value(QStringLiteral("id")).isString())
    {
        block.id = object.value(QStringLiteral("id")).toString();
    }

    QString typeStr;
    if (object.contains(QStringLiteral("type")) && object.value(QStringLiteral("type")).isString())
    {
        typeStr = object.value(QStringLiteral("type")).toString();
        block.type = BlockTypeCodec::fromString(typeStr);
    }
    else
    {
        block.type = core::BlockType::Unsupported;
    }

    if (object.contains(QStringLiteral("data")) && object.value(QStringLiteral("data")).isObject())
    {
        const QVariantMap dataMap = object.value(QStringLiteral("data")).toObject().toVariantMap();
        if (block.type == core::BlockType::Paragraph)
        {
            const core::ParagraphBlock paragraphBlock = deserializeParagraphBlock(object.value(QStringLiteral("data")).toObject());
            block.data = paragraphBlock.text;
        }
        else if (block.type == core::BlockType::Heading)
        {
            const core::HeadingBlock headingBlock = deserializeHeadingBlock(object.value(QStringLiteral("data")).toObject());
            QVariantMap headingData;
            headingData.insert(QStringLiteral("text"), headingBlock.text);
            headingData.insert(QStringLiteral("level"), headingBlock.level);
            block.data = headingData;
        }
        else if (block.type == core::BlockType::Todo)
        {
            const core::TodoBlock todoBlock = deserializeTodoBlock(object.value(QStringLiteral("data")).toObject());
            QVariantMap todoData;
            todoData.insert(QStringLiteral("text"), todoBlock.text);
            todoData.insert(QStringLiteral("done"), todoBlock.done);
            todoData.insert(QStringLiteral("priority"), todoBlock.priority);
            todoData.insert(QStringLiteral("deadline"), todoBlock.deadline.toString(Qt::ISODate));
            todoData.insert(QStringLiteral("color"), todoBlock.color);
            block.data = todoData;
        }
        else
        {
            QVariantMap unsupported;
            unsupported.insert(QStringLiteral("sourceType"), typeStr.isEmpty() ? QStringLiteral("unsupported") : typeStr);
            unsupported.insert(QStringLiteral("sourceData"), dataMap);
            block.data = unsupported;
        }
    }
    else
    {
        if (block.type == core::BlockType::Unsupported)
        {
            QVariantMap unsupported;
            unsupported.insert(QStringLiteral("sourceType"), typeStr.isEmpty() ? QStringLiteral("unsupported") : typeStr);
            unsupported.insert(QStringLiteral("sourceData"), QVariantMap{});
            block.data = unsupported;
        }
    }

    return block;
}

core::ParagraphBlock DocumentJsonSerializer::deserializeParagraphBlock(const QJsonObject &object) const
{
    core::ParagraphBlock block;
    if (object.contains(QStringLiteral("text")) && object.value(QStringLiteral("text")).isString())
    {
        block.text = object.value(QStringLiteral("text")).toString();
    }
    return block;
}

core::HeadingBlock DocumentJsonSerializer::deserializeHeadingBlock(const QJsonObject &object) const
{
    core::HeadingBlock block;
    if (object.contains(QStringLiteral("text")) && object.value(QStringLiteral("text")).isString())
    {
        block.text = object.value(QStringLiteral("text")).toString();
    }
    if (object.contains(QStringLiteral("level")) && object.value(QStringLiteral("level")).isDouble())
    {
        block.level = object.value(QStringLiteral("level")).toInt();
    }
    return block;
}

core::TodoBlock DocumentJsonSerializer::deserializeTodoBlock(const QJsonObject &object) const
{
    core::TodoBlock block;
    if (object.contains(QStringLiteral("text")) && object.value(QStringLiteral("text")).isString())
    {
        block.text = object.value(QStringLiteral("text")).toString();
    }
    if (object.contains(QStringLiteral("done")) && object.value(QStringLiteral("done")).isBool())
    {
        block.done = object.value(QStringLiteral("done")).toBool();
    }
    if (object.contains(QStringLiteral("priority")) && object.value(QStringLiteral("priority")).isString())
    {
        block.priority = object.value(QStringLiteral("priority")).toString();
    }
    if (object.contains(QStringLiteral("deadline")) && object.value(QStringLiteral("deadline")).isString())
    {
        block.deadline = QDate::fromString(object.value(QStringLiteral("deadline")).toString(), Qt::ISODate);
    }
    if (object.contains(QStringLiteral("color")) && object.value(QStringLiteral("color")).isString())
    {
        block.color = object.value(QStringLiteral("color")).toString();
    }
    return block;
}

bool DocumentJsonSerializer::validateDocumentObject(const QJsonObject &object, QString &error) const
{
    if (!validateFormatVersion(object, error))
    {
        return false;
    }

    if (!object.contains(QStringLiteral("id")) || !object.value(QStringLiteral("id")).isString())
    {
        error = QStringLiteral("missing or invalid 'id'");
        return false;
    }

    if (!object.contains(QStringLiteral("blocks")) || !object.value(QStringLiteral("blocks")).isArray())
    {
        error = QStringLiteral("missing or invalid 'blocks' array");
        return false;
    }

    if (object.contains(QStringLiteral("title")) && !object.value(QStringLiteral("title")).isString())
    {
        error = QStringLiteral("'title' is present but not a string");
        return false;
    }

    if (object.contains(QStringLiteral("tags")) && !object.value(QStringLiteral("tags")).isArray())
    {
        error = QStringLiteral("'tags' is present but not an array");
        return false;
    }

    const QJsonArray blocksArray = object.value(QStringLiteral("blocks")).toArray();
    QSet<QString> seenIds;
    for (const auto &blockValue : blocksArray)
    {
        if (!blockValue.isObject())
        {
            error = QStringLiteral("blocks array contains non-object item");
            return false;
        }

        const QJsonObject blockObject = blockValue.toObject();
        if (!blockObject.contains(QStringLiteral("id")) || !blockObject.value(QStringLiteral("id")).isString())
        {
            error = QStringLiteral("block missing or invalid 'id' (for uniqueness check)");
            return false;
        }

        const QString id = blockObject.value(QStringLiteral("id")).toString();
        if (seenIds.contains(id))
        {
            error = QStringLiteral("duplicate block id: %1").arg(id);
            return false;
        }
        seenIds.insert(id);
    }

    const QJsonArray tagsArray = object.value(QStringLiteral("tags")).toArray();
    for (const auto &tagValue : tagsArray)
    {
        if (!tagValue.isString())
        {
            error = QStringLiteral("tags array contains non-string item");
            return false;
        }
    }

    return true;
}

bool DocumentJsonSerializer::validateBlockObject(const QJsonObject &object, QString &error) const
{
    if (!object.contains(QStringLiteral("id")) || !object.value(QStringLiteral("id")).isString())
    {
        error = QStringLiteral("block missing or invalid 'id'");
        return false;
    }

    if (!object.contains(QStringLiteral("type")) || !object.value(QStringLiteral("type")).isString())
    {
        error = QStringLiteral("block missing or invalid 'type'");
        return false;
    }

    if (object.contains(QStringLiteral("data")) && !object.value(QStringLiteral("data")).isObject())
    {
        error = QStringLiteral("block 'data' is present but not an object");
        return false;
    }

    return true;
}

QString DocumentJsonSerializer::getCurrentFormatVersion() const
{
    return QStringLiteral("v2");
}

bool DocumentJsonSerializer::supportsVersion(const QString &version) const
{
    return version == QStringLiteral("v1") || version == QStringLiteral("v2");
}

bool DocumentJsonSerializer::validateFormatVersion(const QJsonObject &object, QString &error) const
{
    if (!object.contains(QStringLiteral("format_version")))
    {
        return true;
    }

    if (!object.value(QStringLiteral("format_version")).isString())
    {
        error = QStringLiteral("'format_version' field is not a string");
        return false;
    }

    const QString version = object.value(QStringLiteral("format_version")).toString();
    if (!supportsVersion(version))
    {
        error = QStringLiteral("Unsupported format version: %1. Supported: v1, v2").arg(version);
        return false;
    }

    return true;
}

core::Document DocumentJsonSerializer::migrateFromV1ToV2(const core::Document &docV1) const
{
    return docV1;
}

}
