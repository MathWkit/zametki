#ifndef ZAMETKI_DOCUMENT_JSON_SERIALIZER_H
#define ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

#include <QJsonObject>

#include "core/document.h"

namespace zametki::storage::json
{
class DocumentJsonSerializer
{
public:
    QJsonObject serialize(const core::Document &document) const;
    core::Document deserialize(const QJsonObject &object) const;
};
}

#endif // ZAMETKI_DOCUMENT_JSON_SERIALIZER_H

