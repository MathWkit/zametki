#include "storage/json/document_json_serializer.h"

#include <QJsonArray>
#include <QVariantMap>
#include <QDate>

#include "storage/json/block_type_codec.h"

namespace zametki::storage::json
{
QJsonObject DocumentJsonSerializer::serialize(const core::Document &document) const
{
    QJsonObject object;
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
    Q_UNUSED(object)
    return {};
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
        blockObject.insert(QStringLiteral("data"), QJsonObject{});
    }

    return blockObject;
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

