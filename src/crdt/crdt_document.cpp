#include "crdt/crdt_document.h"

namespace zametki::crdt
{
bool CRDTDocument::isEmpty() const
{
    return id.isEmpty() && blocks.isEmpty();
}

void CRDTDocument::clear()
{
    id.clear();
    blocks.clear();
}
}

