#include "core/block_text_accessor.h"


namespace zametki::core
{
QString BlockTextAccessor::getText(const Block &block)
{
    switch (block.type)
    {
    case BlockType::Paragraph:
        return block.data.toString();
    case BlockType::Heading:
    case BlockType::Todo:
    {
        const QVariantMap map = block.data.toMap();
        return map.value(QStringLiteral("text")).toString();
    }
    }

    return QString();
}

bool BlockTextAccessor::setText(Block &block, const QString &text)
{
    switch (block.type)
    {
    case BlockType::Paragraph:
        block.data = text;
        return true;
    case BlockType::Heading:
    case BlockType::Todo:
    {
        QVariantMap map = block.data.toMap();
        map.insert(QStringLiteral("text"), text);
        block.data = map;
        return true;
    }
    }

    return false;
}
}

