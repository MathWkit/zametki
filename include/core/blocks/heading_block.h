#ifndef ZAMETKI_HEADING_BLOCK_H
#define ZAMETKI_HEADING_BLOCK_H

#include <QString>

namespace zametki::core
{
struct HeadingBlock
{
    QString text;
    int level = 1;
};
}

#endif // ZAMETKI_HEADING_BLOCK_H
