#include "storage/json/block_type_codec.h"

namespace zametki::storage::json
{
QString BlockTypeCodec::toString(const core::BlockType type)
{
    switch (type)
    {
    case core::BlockType::Paragraph:
        return QStringLiteral("paragraph");
    case core::BlockType::Heading:
        return QStringLiteral("heading");
    case core::BlockType::Todo:
        return QStringLiteral("todo");
    }

    return QStringLiteral("paragraph");
}

core::BlockType BlockTypeCodec::fromString(const QString &value)
{
    if (value == QStringLiteral("paragraph"))
    {
        return core::BlockType::Paragraph;
    }

    if (value == QStringLiteral("heading"))
    {
        return core::BlockType::Heading;
    }

    if (value == QStringLiteral("todo"))
    {
        return core::BlockType::Todo;
    }

    return core::BlockType::Paragraph;
}
}

