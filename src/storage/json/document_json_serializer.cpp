#include "storage/json/document_json_serializer.h"

#include <QJsonArray>
#include <QVariantMap>
#include <QDate>
#include <QSet>

#include "storage/json/block_type_codec.h"
#include <QDebug>

namespace zametki::storage::json
{
QJsonObject DocumentJsonSerializer::serialize(const core::Document &document) const
{
    QJsonObject object;
    object.insert(QStringLiteral("format_version"), QStringLiteral("v1"));
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
    if (!validateDocumentObject(object, error))
    {
        qWarning().noquote() << QStringLiteral("Document JSON validation failed:") << error;
        return {};
    }

    core::Document document;
    document.id = object.value(QStringLiteral("id")).toString();
    document.title = object.value(QStringLiteral("title")).toString();

    const QJsonArray tagsArray = object.value(QStringLiteral("tags")).toArray();
    for (const QJsonValue &v : tagsArray)
    {
        if (v.isString())
            document.tags.append(v.toString());
    }

    const QJsonArray blocksArray = object.value(QStringLiteral("blocks")).toArray();
    for (const QJsonValue &bv : blocksArray)
    {
        if (!bv.isObject())
            continue;
        const QJsonObject bobj = bv.toObject();
        QString berr;
        if (!validateBlockObject(bobj, berr))
        {
            qWarning().noquote() << QStringLiteral("Skipping invalid block:") << berr;
            continue;
        }
        document.blocks.append(deserializeBlock(bobj));
    }

    return document;
}

QJsonObject DocumentJsonSerializer::serializeParagraphBlock(const core::ParagraphBlock &block) const
{
    QJsonObject object;
    object.insert(QStringLiteral("text"), block.text);
    return object;
}

core::ParagraphBlock DocumentJsonSerializer::deserializeParagraphBlock(const QJsonObject &object) const
{
    core::ParagraphBlock block;
    if (object.contains(QStringLiteral("text")) && object.value(QStringLiteral("text")).isString())
    {
        block.text = object.value(QStringLiteral("text")).toString();
    }
    else
    {
        block.text.clear();
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
    else
    {
        block.text.clear();
    }

    if (object.contains(QStringLiteral("level")) && object.value(QStringLiteral("level")).isDouble())
    {
        block.level = object.value(QStringLiteral("level")).toInt();
    }
    else
    {
        block.level = 1;
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
    else
    {
        block.text.clear();
    }

    if (object.contains(QStringLiteral("done")))
    {
        const QJsonValue v = object.value(QStringLiteral("done"));
        if (v.isBool()) block.done = v.toBool();
        else block.done = v.toInt() != 0;
    }
    else
    {
        block.done = false;
    }

    if (object.contains(QStringLiteral("priority")) && object.value(QStringLiteral("priority")).isString())
    {
        block.priority = object.value(QStringLiteral("priority")).toString();
    }
    else
    {
        block.priority.clear();
    }

    if (object.contains(QStringLiteral("deadline")) && object.value(QStringLiteral("deadline")).isString())
    {
        block.deadline = QDate::fromString(object.value(QStringLiteral("deadline")).toString(), Qt::ISODate);
    }
    else
    {
        block.deadline = QDate();
    }

    if (object.contains(QStringLiteral("color")) && object.value(QStringLiteral("color")).isString())
    {
        block.color = object.value(QStringLiteral("color")).toString();
    }
    else
    {
        block.color.clear();
    }

    return block;
}

QJsonObject DocumentJsonSerializer::serializeBlock(const core::Block &block) const
{
    QJsonObject blockObject;
    blockObject.insert(QStringLiteral("id"), block.id);
    blockObject.insert(QStringLiteral("type"), BlockTypeCodec::toString(block.type));

    if (block.type == core::BlockType::Paragraph)
    {
        core::ParagraphBlock paragraphBlock;
        if (block.data.canConvert<QVariantMap>())
        {
            const QVariantMap m = block.data.toMap();
            paragraphBlock.text = m.value(QStringLiteral("text")).toString();
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
            const QVariantMap m = block.data.toMap();
            headingBlock.text = m.value(QStringLiteral("text")).toString();
            headingBlock.level = m.value(QStringLiteral("level"), 1).toInt();
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
            const QVariantMap m = block.data.toMap();
            todoBlock.text = m.value(QStringLiteral("text")).toString();
            todoBlock.done = m.value(QStringLiteral("done"), false).toBool();
            todoBlock.priority = m.value(QStringLiteral("priority")).toString();
            todoBlock.deadline = QDate::fromString(m.value(QStringLiteral("deadline")).toString(), Qt::ISODate);
            todoBlock.color = m.value(QStringLiteral("color")).toString();
        }
        else
        {
            todoBlock.text = block.data.toString();
        }
        blockObject.insert(QStringLiteral("data"), serializeTodoBlock(todoBlock));
    }
    else
    {
        if (block.type == core::BlockType::Unsupported)
        {
            if (block.data.canConvert<QVariantMap>())
            {
                const QVariantMap um = block.data.toMap();
                const QString sourceType = um.value(QStringLiteral("sourceType")).toString();
                const QVariantMap sourceData = um.value(QStringLiteral("sourceData")).toMap();

                if (!sourceType.isEmpty())
                {
                    blockObject.insert(QStringLiteral("type"), sourceType);
                }
                QJsonObject dataObj = QJsonObject::fromVariantMap(sourceData);
                blockObject.insert(QStringLiteral("data"), dataObj);
            }
            else
            {
                blockObject.insert(QStringLiteral("data"), QJsonObject{});
            }
        }
        else
        {
            blockObject.insert(QStringLiteral("data"), QJsonObject{});
        }
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
    else
    {
        block.id.clear();
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
        const QJsonObject dataObj = object.value(QStringLiteral("data")).toObject();
        const QVariantMap vm = dataObj.toVariantMap();
        if (block.type == core::BlockType::Unsupported)
        {
            QVariantMap umap;
            umap.insert(QStringLiteral("sourceType"), typeStr);
            umap.insert(QStringLiteral("sourceData"), vm);
            block.data = umap;
        }
        else
        {
            block.data = vm;
        }
    }
    else
    {
        if (block.type == core::BlockType::Unsupported)
        {
            QVariantMap umap;
            umap.insert(QStringLiteral("sourceType"), typeStr);
            umap.insert(QStringLiteral("sourceData"), QVariantMap{});
            block.data = umap;
        }
        else
        {
            block.data = QVariant();
        }
    }

    return block;
}

bool DocumentJsonSerializer::validateDocumentObject(const QJsonObject &object, QString &error) const
{
    // version check: if present only v1 is supported for now
    if (object.contains(QStringLiteral("format_version")))
    {
        if (!object.value(QStringLiteral("format_version")).isString())
        {
            error = QStringLiteral("invalid 'format_version' field");
            return false;
        }
        const QString ver = object.value(QStringLiteral("format_version")).toString();
        if (ver != QStringLiteral("v1"))
        {
            error = QStringLiteral("unsupported format version: %1").arg(ver);
            return false;
        }
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
    {
        const QJsonArray blocksArray = object.value(QStringLiteral("blocks")).toArray();
        QSet<QString> seenIds;
        for (const QJsonValue &bv : blocksArray)
        {
            if (!bv.isObject())
            {
                error = QStringLiteral("blocks array contains non-object item");
                return false;
            }
            const QJsonObject bobj = bv.toObject();
            if (!bobj.contains(QStringLiteral("id")) || !bobj.value(QStringLiteral("id")).isString())
            {
                error = QStringLiteral("block missing or invalid 'id' (for uniqueness check)");
                return false;
            }
            const QString id = bobj.value(QStringLiteral("id")).toString();
            if (seenIds.contains(id))
            {
                error = QStringLiteral("duplicate block id: %1").arg(id);
                return false;
            }
            seenIds.insert(id);
        }
    }
    // title is optional but if present must be string
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
    if (object.contains(QStringLiteral("tags")))
    {
        const QJsonArray tagsArray = object.value(QStringLiteral("tags")).toArray();
        for (const QJsonValue &tv : tagsArray)
        {
            if (!tv.isString())
            {
                error = QStringLiteral("tags array contains non-string item");
                return false;
            }
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
}

