#ifndef ZAMETKI_DOCUMENT_JSON_SERIALIZER_H
#define ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

#include <QJsonObject>
#include <QString>

#include "core/blocks/heading_block.h"
#include "core/blocks/paragraph_block.h"
#include "core/blocks/todo_block.h"
#include "core/document.h"

namespace zametki::storage::json
{

class DocumentJsonSerializer
{
public:
    QJsonObject serialize(const core::Document &document) const;
    core::Document deserialize(const QJsonObject &object) const;

    QString getCurrentFormatVersion() const;
    bool supportsVersion(const QString &version) const;
    bool validateFormatVersion(const QJsonObject &object, QString &error) const;

private:
    QJsonObject serializeParagraphBlock(const core::ParagraphBlock &block) const;
    QJsonObject serializeHeadingBlock(const core::HeadingBlock &block) const;
    QJsonObject serializeTodoBlock(const core::TodoBlock &block) const;
    QJsonObject serializeBlock(const core::Block &block) const;
    core::Block deserializeBlock(const QJsonObject &object) const;
    bool validateDocumentObject(const QJsonObject &object, QString &error) const;
    bool validateBlockObject(const QJsonObject &object, QString &error) const;
    core::ParagraphBlock deserializeParagraphBlock(const QJsonObject &object) const;
    core::HeadingBlock deserializeHeadingBlock(const QJsonObject &object) const;
    core::TodoBlock deserializeTodoBlock(const QJsonObject &object) const;
    core::Document migrateFromV1ToV2(const core::Document &docV1) const;
};
}

#endif // ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

