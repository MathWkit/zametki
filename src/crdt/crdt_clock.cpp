#include "crdt/crdt_clock.h"

namespace zametki::crdt
{
CRDTClock::CRDTClock()
    : m_value(0)
{
}

quint64 CRDTClock::value() const
{
    return m_value;
}

quint64 CRDTClock::increment()
{
    ++m_value;
    return m_value;
}

quint64 CRDTClock::update(quint64 remote)
{
    if (remote > m_value)
        m_value = remote;

    ++m_value;
    return m_value;
}
}

