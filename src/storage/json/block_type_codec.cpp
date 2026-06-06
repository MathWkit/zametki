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
    case core::BlockType::Quote:
        return QStringLiteral("quote");
    case core::BlockType::Bulleted:
        return QStringLiteral("bulleted");
    case core::BlockType::Numbered:
        return QStringLiteral("numbered");
    case core::BlockType::Code:
        return QStringLiteral("code");
    case core::BlockType::Divider:
        return QStringLiteral("divider");
    case core::BlockType::Unsupported:
        return QStringLiteral("unsupported");
    }

    return QStringLiteral("unsupported");
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

    if (value == QStringLiteral("quote"))
    {
        return core::BlockType::Quote;
    }

    if (value == QStringLiteral("bulleted"))
    {
        return core::BlockType::Bulleted;
    }

    if (value == QStringLiteral("numbered"))
    {
        return core::BlockType::Numbered;
    }

    if (value == QStringLiteral("code"))
    {
        return core::BlockType::Code;
    }

    if (value == QStringLiteral("divider"))
    {
        return core::BlockType::Divider;
    }

    // unknown type
    return core::BlockType::Unsupported;
}
}

