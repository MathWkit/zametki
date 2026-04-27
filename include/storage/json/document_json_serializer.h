#ifndef ZAMETKI_DOCUMENT_JSON_SERIALIZER_H
#define ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

#include <QJsonObject>

#include "core/blocks/heading_block.h"
#include "core/blocks/paragraph_block.h"
#include "core/document.h"

namespace zametki::storage::json
{
class DocumentJsonSerializer
{
public:
    QJsonObject serialize(const core::Document &document) const;
    core::Document deserialize(const QJsonObject &object) const;

private:
    QJsonObject serializeParagraphBlock(const core::ParagraphBlock &block) const;
    QJsonObject serializeHeadingBlock(const core::HeadingBlock &block) const;
};
}

#endif // ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

