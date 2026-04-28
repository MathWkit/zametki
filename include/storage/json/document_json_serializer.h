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

    static QString getCurrentFormatVersion();
    static bool supportsVersion(const QString &version);
    static bool validateFormatVersion(const QJsonObject &object, QString &error);

private:
    static QJsonObject serializeParagraphBlock(const core::ParagraphBlock &block);
    static QJsonObject serializeHeadingBlock(const core::HeadingBlock &block);
    static QJsonObject serializeTodoBlock(const core::TodoBlock &block);
    static QJsonObject serializeBlock(const core::Block &block);
    core::Block deserializeBlock(const QJsonObject &object) const;
    bool validateDocumentObject(const QJsonObject &object, QString &error) const;
    static bool validateBlockObject(const QJsonObject &object, QString &error);
    core::ParagraphBlock deserializeParagraphBlock(const QJsonObject &object) const;
    core::HeadingBlock deserializeHeadingBlock(const QJsonObject &object) const;
    core::TodoBlock deserializeTodoBlock(const QJsonObject &object) const;
    static core::Document migrateFromV1ToV2(const core::Document &docV1);
};
}

#endif // ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

