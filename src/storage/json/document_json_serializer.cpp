#include "storage/json/document_json_serializer.h"

#include <QJsonArray>
#include <QVariantMap>

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
        QJsonObject blockObject;
        blockObject.insert(QStringLiteral("id"), block.id);
        blockObject.insert(QStringLiteral("type"), BlockTypeCodec::toString(block.type));

        if (block.type == core::BlockType::Paragraph)
        {
            const core::ParagraphBlock paragraphBlock{block.data.toString()};
            blockObject.insert(QStringLiteral("data"), serializeParagraphBlock(paragraphBlock));
        }
        else if (block.type == core::BlockType::Heading)
        {
            core::HeadingBlock headingBlock;

            if (block.data.canConvert<QVariantMap>())
            {
                const QVariantMap headingData = block.data.toMap();
                headingBlock.text = headingData.value(QStringLiteral("text")).toString();
                headingBlock.level = headingData.value(QStringLiteral("level"), 1).toInt();
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
                const QVariantMap todoData = block.data.toMap();
                todoBlock.text = todoData.value(QStringLiteral("text")).toString();
                todoBlock.done = todoData.value(QStringLiteral("done"), false).toBool();
                todoBlock.priority = todoData.value(QStringLiteral("priority")).toString();
                todoBlock.deadline = QDate::fromString(
                    todoData.value(QStringLiteral("deadline")).toString(),
                    Qt::ISODate);
                todoBlock.color = todoData.value(QStringLiteral("color")).toString();
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

        blocksArray.append(blockObject);
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

