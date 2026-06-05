#include "core/block_text_accessor.h"

#include "core/blocks/heading_block.h"
#include "core/blocks/paragraph_block.h"
#include "core/blocks/todo_block.h"

namespace zametki::core
{
QString BlockTextAccessor::getText(const Block &block)
{
    if (block.data.canConvert<ParagraphBlock>())
    {
        return block.data.value<ParagraphBlock>().text;
    }
    if (block.data.canConvert<HeadingBlock>())
    {
        return block.data.value<HeadingBlock>().text;
    }
    if (block.data.canConvert<TodoBlock>())
    {
        return block.data.value<TodoBlock>().text;
    }

    return QString();
}

bool BlockTextAccessor::setText(Block &block, const QString &text)
{
    if (block.data.canConvert<ParagraphBlock>())
    {
        ParagraphBlock data = block.data.value<ParagraphBlock>();
        data.text = text;
        block.data = QVariant::fromValue(data);
        return true;
    }
    if (block.data.canConvert<HeadingBlock>())
    {
        HeadingBlock data = block.data.value<HeadingBlock>();
        data.text = text;
        block.data = QVariant::fromValue(data);
        return true;
    }
    if (block.data.canConvert<TodoBlock>())
    {
        TodoBlock data = block.data.value<TodoBlock>();
        data.text = text;
        block.data = QVariant::fromValue(data);
        return true;
    }

    return false;
}
}

