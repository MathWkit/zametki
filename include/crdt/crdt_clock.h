#ifndef ZAMETKI_CRDT_CLOCK_H
#define ZAMETKI_CRDT_CLOCK_H

#include <QtGlobal>

namespace zametki::crdt
{
class CRDTClock
{
public:
    CRDTClock();

    quint64 value() const;
    quint64 increment();
    quint64 update(quint64 remote);

private:
    quint64 m_value;
};
}

#endif // ZAMETKI_CRDT_CLOCK_H

