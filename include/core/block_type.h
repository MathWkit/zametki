#ifndef ZAMETKI_BLOCK_TYPE_H
#define ZAMETKI_BLOCK_TYPE_H

namespace zametki::core
{
enum class BlockType
{
    Paragraph,
    Heading,
    Todo,
    Quote,
    Bulleted,
    Numbered,
    Code,
    Divider,
    Unsupported
};
}

#endif // ZAMETKI_BLOCK_TYPE_H
