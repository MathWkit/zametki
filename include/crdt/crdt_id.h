#ifndef ZAMETKI_CRDT_ID_H
#define ZAMETKI_CRDT_ID_H

#include <QtGlobal>

namespace zametki::crdt
{
struct CRDTId
{
    quint32 siteId = 0;
    quint64 counter = 0;
};
}

#endif // ZAMETKI_CRDT_ID_H

