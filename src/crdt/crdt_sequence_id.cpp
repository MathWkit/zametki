#include "crdt/crdt_sequence_id.h"

#include <QStringList>

namespace zametki::crdt
{
bool CRDTSequenceId::isValid() const
{
    return siteId != 0 || counter != 0;
}

QString CRDTSequenceId::toString() const
{
    return QString::number(siteId) + QLatin1Char(':') + QString::number(counter);
}

CRDTSequenceId CRDTSequenceId::fromString(const QString &text)
{
    CRDTSequenceId id;
    const QStringList parts = text.split(QLatin1Char(':'));
    if (parts.size() != 2)
    {
        return id;
    }

    bool okSite = false;
    bool okCounter = false;
    id.siteId = parts.at(0).toUInt(&okSite);
    id.counter = parts.at(1).toULongLong(&okCounter);
    if (!okSite || !okCounter)
    {
        return {};
    }

    return id;
}

bool operator==(const CRDTSequenceId &lhs, const CRDTSequenceId &rhs)
{
    return lhs.siteId == rhs.siteId && lhs.counter == rhs.counter;
}

bool operator!=(const CRDTSequenceId &lhs, const CRDTSequenceId &rhs)
{
    return !(lhs == rhs);
}

bool operator<(const CRDTSequenceId &lhs, const CRDTSequenceId &rhs)
{
    if (lhs.counter != rhs.counter)
    {
        return lhs.counter < rhs.counter;
    }

    return lhs.siteId < rhs.siteId;
}
}

