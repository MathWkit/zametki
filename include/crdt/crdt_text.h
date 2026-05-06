#ifndef ZAMETKI_CRDT_TEXT_H
#define ZAMETKI_CRDT_TEXT_H

#include <QJsonObject>
#include <QSet>
#include <QString>
#include <QVector>

#include "crdt/crdt_sequence_id.h"

namespace zametki::crdt
{
struct CRDTTextElement
{
    CRDTSequenceId id;
    QChar value;
    bool deleted = false;
};

class CRDTText
{
public:
    explicit CRDTText(quint32 siteId = 0);

    quint32 siteId() const;
    void setSiteId(quint32 siteId);

    int length() const;
    int elementCount() const;

    bool applyInsert(const QString &operationId, int position, const QString &text);
    bool applyDelete(const QString &operationId, int position, int length);

    QString toQString() const;
    void fromQString(const QString &text, quint32 siteId);

    QJsonObject serialize() const;
    static CRDTText deserialize(const QJsonObject &object);

    QChar at(int index) const;
    bool hasConflict() const;

private:
    int clampPosition(int position) const;
    int elementIndexFromVisible(int position) const;
    void insertElementSorted(const CRDTTextElement &element);
    CRDTSequenceId generateIdBetween(const CRDTSequenceId &left, const CRDTSequenceId &right, bool &conflict);

    QVector<CRDTTextElement> m_elements;
    QSet<QString> m_appliedOperationIds;
    quint32 m_siteId = 0;
    quint64 m_localCounter = 0;
    bool m_hasConflict = false;
};
}

#endif // ZAMETKI_CRDT_TEXT_H

