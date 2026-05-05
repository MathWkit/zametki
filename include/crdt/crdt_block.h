#ifndef ZAMETKI_CRDT_BLOCK_H
#define ZAMETKI_CRDT_BLOCK_H

#include <QVariant>

#include "crdt/crdt_id.h"
#include "crdt/crdt_map.h"
#include "core/block_type.h"

namespace zametki::crdt
{
struct CRDTBlock
{
    CRDTId id;
    core::BlockType type = core::BlockType::Paragraph;
    CRDTMap data;

    bool isValid() const;
};
}

#endif // ZAMETKI_CRDT_BLOCK_H

