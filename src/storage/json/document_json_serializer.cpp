#include "storage/json/document_json_serializer.h"

#include <QJsonArray>

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
}

