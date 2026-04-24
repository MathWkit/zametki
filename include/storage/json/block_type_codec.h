#ifndef ZAMETKI_BLOCK_TYPE_CODEC_H
#define ZAMETKI_BLOCK_TYPE_CODEC_H

#include <QString>

#include "core/block_type.h"

namespace zametki::storage::json
{
class BlockTypeCodec
{
public:
    static QString toString(core::BlockType type);
    static core::BlockType fromString(const QString &value);
};
}

#endif // ZAMETKI_BLOCK_TYPE_CODEC_H

