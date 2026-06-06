#ifndef ZAMETKI_BLOCK_TEXT_ACCESSOR_H
#define ZAMETKI_BLOCK_TEXT_ACCESSOR_H

#include <QString>

#include "core/block.h"

namespace zametki::core
{
class BlockTextAccessor
{
public:
    static QString getText(const Block &block);
    static bool setText(Block &block, const QString &text);
};
}

#endif // ZAMETKI_BLOCK_TEXT_ACCESSOR_H

