#include "crdt/crdt_map.h"

#include <QJsonValue>

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

QJsonObject CRDTMap::serialize() const
{
    QJsonObject object;
    for (auto it = m_entries.constBegin(); it != m_entries.constEnd(); ++it)
    {
        QJsonObject entryObj;
        entryObj.insert(QStringLiteral("version"), static_cast<qint64>(it.value().version));
        entryObj.insert(QStringLiteral("value"), QJsonValue::fromVariant(it.value().value));
        object.insert(it.key(), entryObj);
    }

    return object;
}

CRDTMap CRDTMap::deserialize(const QJsonObject &object)
{
    CRDTMap map;
    for (auto it = object.constBegin(); it != object.constEnd(); ++it)
    {
        if (!it.value().isObject())
        {
            continue;
        }

        const QJsonObject entryObj = it.value().toObject();
        const quint64 version = static_cast<quint64>(entryObj.value(QStringLiteral("version")).toInteger());
        const QVariant value = entryObj.value(QStringLiteral("value")).toVariant();
        map.set(it.key(), value, version);
    }

    return map;
}
}
