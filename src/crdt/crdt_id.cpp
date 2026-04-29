#include "crdt/crdt_id.h"

#include <QAtomicInteger>

namespace zametki::crdt
{
namespace
{
QAtomicInteger<quint64> g_counter(0);
}

CRDTId createCRDTId(quint32 siteId)
{
    CRDTId id;
    id.siteId = siteId;
    id.counter = static_cast<quint64>(g_counter.fetchAndAddRelaxed(1));
    return id;
}
}

