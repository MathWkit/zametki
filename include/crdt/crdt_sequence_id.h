#ifndef ZAMETKI_CRDT_SEQUENCE_ID_H
#define ZAMETKI_CRDT_SEQUENCE_ID_H

#include <QtGlobal>
#include <QString>

namespace zametki::crdt
{
struct CRDTSequenceId
{
    quint32 siteId = 0;
    quint64 counter = 0;

    bool isValid() const;
    QString toString() const;

    static CRDTSequenceId fromString(const QString &text);
};

bool operator==(const CRDTSequenceId &lhs, const CRDTSequenceId &rhs);
bool operator!=(const CRDTSequenceId &lhs, const CRDTSequenceId &rhs);
bool operator<(const CRDTSequenceId &lhs, const CRDTSequenceId &rhs);
}

#endif // ZAMETKI_CRDT_SEQUENCE_ID_H

