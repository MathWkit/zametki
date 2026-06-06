#ifndef ZAMETKI_TEXT_BLOCK_H
#define ZAMETKI_TEXT_BLOCK_H

#include <QString>

namespace zametki::core
{
// Shared payload for simple text-bearing block types (quote, bulleted,
// numbered, code). The concrete kind is distinguished by Block::type.
struct TextBlock
{
    QString text;
};
}

#endif // ZAMETKI_TEXT_BLOCK_H
