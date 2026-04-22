#ifndef ZAMETKI_BLOCK_H
#define ZAMETKI_BLOCK_H

#include <QString>
#include <QVariant>

#include "core/block_type.h"

namespace zametki::core
{
struct Block
{
    QString id;
    BlockType type = BlockType::Paragraph;
    QVariant data;
};
}

#endif // ZAMETKI_BLOCK_H

