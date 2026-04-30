#ifndef ZAMETKI_CRDT_MAP_H
#define ZAMETKI_CRDT_MAP_H

#include <QHash>
#include <QString>
#include <QVariant>

namespace zametki::crdt
{
struct CRDTMapEntry
{
    quint64 version = 0;
    QVariant value;
};

class CRDTMap
{
public:
    bool contains(const QString &key) const;
    QVariant value(const QString &key) const;
    quint64 version(const QString &key) const;
    void set(const QString &key, const QVariant &value, quint64 version);

private:
    QHash<QString, CRDTMapEntry> m_entries;
};
}

#endif // ZAMETKI_CRDT_MAP_H

