#include "crdt/crdt_map.h"

namespace zametki::crdt
{
bool CRDTMap::contains(const QString &key) const
{
    return m_entries.contains(key);
}

QVariant CRDTMap::value(const QString &key) const
{
    return m_entries.value(key).value;
}

quint64 CRDTMap::version(const QString &key) const
{
    return m_entries.value(key).version;
}

void CRDTMap::set(const QString &key, const QVariant &value, quint64 version)
{
    CRDTMapEntry entry;
    entry.version = version;
    entry.value = value;
    m_entries.insert(key, entry);
}
}

