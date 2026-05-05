#include "crdt/crdt_block.h"

namespace zametki::crdt
{
bool CRDTBlock::isValid() const
{
    return id.siteId != 0 || id.counter != 0;
}
}

