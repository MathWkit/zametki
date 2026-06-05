#ifndef ZAMETKI_CRDT_BLOCK_SEQUENCE_H
#define ZAMETKI_CRDT_BLOCK_SEQUENCE_H

#include <QSet>
#include <QVector>

#include "crdt/crdt_block.h"
#include "crdt/crdt_sequence_id.h"

namespace zametki::crdt
{
struct CRDTBlockEntry
{
    CRDTSequenceId position;
    CRDTBlock block;
    bool deleted = false;
};

class CRDTBlockSequence
{
public:
    explicit CRDTBlockSequence(quint32 siteId = 0);

    quint32 siteId() const;
    void setSiteId(quint32 siteId);

    int size() const;
    int visibleCount() const;

    bool containsId(const CRDTId &blockId) const;
    CRDTBlock findById(const CRDTId &blockId) const;
    int indexOf(const CRDTId &blockId) const;
    CRDTBlock blockAt(int index) const;

    bool applyInsert(const QString &operationId, const CRDTBlock &block, const CRDTSequenceId &left, const CRDTSequenceId &right);
    bool applyDelete(const QString &operationId, const CRDTId &blockId);
    bool applyReorder(const QString &operationId, const CRDTId &blockId, const CRDTId &afterBlockId);

    bool insertAfter(const QString &operationId, const CRDTId &afterBlockId, const CRDTBlock &block);
    bool deleteBlock(const QString &operationId, const CRDTId &blockId);

    QVector<CRDTBlockEntry> exportSequence() const;
    void importSequence(const QVector<CRDTBlockEntry> &entries);

    bool hasConflict() const;

private:
    CRDTSequenceId nextVisiblePosition(int entryIndex) const;
    CRDTSequenceId generateIdBetween(const CRDTSequenceId &left, const CRDTSequenceId &right, bool &conflict);
    void insertEntrySorted(const CRDTBlockEntry &entry);
    bool isBlockIdUnique(const CRDTId &blockId) const;

    QVector<CRDTBlockEntry> m_entries;
    QSet<QString> m_appliedOperationIds;
    quint32 m_siteId = 0;
    quint64 m_localCounter = 0;
    bool m_hasConflict = false;
};
}

#endif // ZAMETKI_CRDT_BLOCK_SEQUENCE_H

