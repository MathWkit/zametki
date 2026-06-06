#include "crdt/crdt_block_sequence.h"

#include <algorithm>

namespace zametki::crdt
{
CRDTBlockSequence::CRDTBlockSequence(quint32 siteId)
    : m_siteId(siteId)
{
}

quint32 CRDTBlockSequence::siteId() const
{
    return m_siteId;
}

void CRDTBlockSequence::setSiteId(quint32 siteId)
{
    m_siteId = siteId;
}

int CRDTBlockSequence::size() const
{
    return m_entries.size();
}

int CRDTBlockSequence::visibleCount() const
{
    int count = 0;
    for (const auto &entry : m_entries)
    {
        if (!entry.deleted)
        {
            ++count;
        }
    }

    return count;
}

bool CRDTBlockSequence::containsId(const CRDTId &blockId) const
{
    for (const auto &entry : m_entries)
    {
        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            return !entry.deleted;
        }
    }

    return false;
}

CRDTBlock CRDTBlockSequence::findById(const CRDTId &blockId) const
{
    for (const auto &entry : m_entries)
    {
        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            return entry.block;
        }
    }

    return {};
}

int CRDTBlockSequence::indexOf(const CRDTId &blockId) const
{
    int visibleIndex = 0;
    for (const auto &entry : m_entries)
    {
        if (entry.deleted)
        {
            continue;
        }

        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            return visibleIndex;
        }

        ++visibleIndex;
    }

    return -1;
}

CRDTBlock CRDTBlockSequence::blockAt(int index) const
{
    if (index < 0)
    {
        return {};
    }

    int visibleIndex = 0;
    for (const auto &entry : m_entries)
    {
        if (entry.deleted)
        {
            continue;
        }

        if (visibleIndex == index)
        {
            return entry.block;
        }

        ++visibleIndex;
    }

    return {};
}

bool CRDTBlockSequence::applyInsert(const QString &operationId, const CRDTBlock &block, const CRDTSequenceId &left, const CRDTSequenceId &right)
{
    if (!block.isValid())
    {
        return false;
    }

    if (!isBlockIdUnique(block.id))
    {
        return false;
    }

    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    bool conflict = false;
    CRDTSequenceId position = generateIdBetween(left, right, conflict);

    CRDTBlockEntry entry;
    entry.position = position;
    entry.block = block;
    entry.deleted = false;
    insertEntrySorted(entry);

    if (conflict)
    {
        m_hasConflict = true;
    }

    m_appliedOperationIds.insert(operationId);
    return true;
}

bool CRDTBlockSequence::applyDelete(const QString &operationId, const CRDTId &blockId)
{
    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    for (auto &entry : m_entries)
    {
        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            if (!entry.deleted)
            {
                entry.deleted = true;
                m_appliedOperationIds.insert(operationId);
                return true;
            }

            return false;
        }
    }

    return false;
}

bool CRDTBlockSequence::applyReorder(const QString &operationId, const CRDTId &blockId, const CRDTId &afterBlockId)
{
    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    int entryIndex = -1;
    for (int i = 0; i < m_entries.size(); ++i)
    {
        const auto &entry = m_entries.at(i);
        if (!entry.deleted && entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            entryIndex = i;
            break;
        }
    }

    if (entryIndex < 0)
    {
        return false;
    }

    CRDTBlockEntry entry = m_entries.takeAt(entryIndex);

    CRDTSequenceId left;
    CRDTSequenceId right;

    if (afterBlockId.siteId != 0 || afterBlockId.counter != 0)
    {
        for (int i = 0; i < m_entries.size(); ++i)
        {
            const auto &candidate = m_entries.at(i);
            if (!candidate.deleted && candidate.block.id.siteId == afterBlockId.siteId && candidate.block.id.counter == afterBlockId.counter)
            {
                left = candidate.position;
                right = nextVisiblePosition(i);
                break;
            }
        }
    }

    if (!left.isValid())
    {
        for (const auto &candidate : m_entries)
        {
            if (!candidate.deleted)
            {
                right = candidate.position;
                break;
            }
        }
    }

    bool conflict = false;
    entry.position = generateIdBetween(left, right, conflict);
    insertEntrySorted(entry);

    if (conflict)
    {
        m_hasConflict = true;
    }

    m_appliedOperationIds.insert(operationId);
    return true;
}

bool CRDTBlockSequence::insertAfter(const QString &operationId, const CRDTId &afterBlockId, const CRDTBlock &block)
{
    CRDTSequenceId left;
    CRDTSequenceId right;

    if (afterBlockId.siteId != 0 || afterBlockId.counter != 0)
    {
        for (int i = 0; i < m_entries.size(); ++i)
        {
            const auto &entry = m_entries.at(i);
            if (!entry.deleted && entry.block.id.siteId == afterBlockId.siteId && entry.block.id.counter == afterBlockId.counter)
            {
                left = entry.position;
                right = nextVisiblePosition(i);
                break;
            }
        }
    }

    if (!left.isValid())
    {
        for (const auto &entry : m_entries)
        {
            if (!entry.deleted)
            {
                right = entry.position;
                break;
            }
        }
    }

    return applyInsert(operationId, block, left, right);
}

bool CRDTBlockSequence::deleteBlock(const QString &operationId, const CRDTId &blockId)
{
    return applyDelete(operationId, blockId);
}

QVector<CRDTBlockEntry> CRDTBlockSequence::exportSequence() const
{
    return m_entries;
}

void CRDTBlockSequence::importSequence(const QVector<CRDTBlockEntry> &entries)
{
    m_entries = entries;
    std::sort(m_entries.begin(), m_entries.end(), [](const CRDTBlockEntry &lhs, const CRDTBlockEntry &rhs) {
        if (lhs.position == rhs.position)
        {
            if (lhs.block.id.counter != rhs.block.id.counter)
            {
                return lhs.block.id.counter < rhs.block.id.counter;
            }

            return lhs.block.id.siteId < rhs.block.id.siteId;
        }

        return lhs.position < rhs.position;
    });
}

bool CRDTBlockSequence::hasConflict() const
{
    return m_hasConflict;
}

CRDTSequenceId CRDTBlockSequence::nextVisiblePosition(int entryIndex) const
{
    for (int i = entryIndex + 1; i < m_entries.size(); ++i)
    {
        if (!m_entries.at(i).deleted)
        {
            return m_entries.at(i).position;
        }
    }

    return {};
}

CRDTSequenceId CRDTBlockSequence::generateIdBetween(const CRDTSequenceId &left, const CRDTSequenceId &right, bool &conflict)
{
    CRDTSequenceId id;
    id.siteId = m_siteId;

    if (!left.isValid() && !right.isValid())
    {
        id.counter = ++m_localCounter;
        return id;
    }

    if (!left.isValid())
    {
        if (right.counter > 1)
        {
            id.counter = right.counter / 2;
        }
        else
        {
            id.counter = right.counter;
            conflict = true;
        }

        if (id.counter > m_localCounter)
        {
            m_localCounter = id.counter;
        }

        return id;
    }

    if (!right.isValid())
    {
        id.counter = left.counter + 1;
        if (id.counter > m_localCounter)
        {
            m_localCounter = id.counter;
        }

        return id;
    }

    if (left.counter + 1 < right.counter)
    {
        id.counter = left.counter + (right.counter - left.counter) / 2;
    }
    else
    {
        id.counter = left.counter + 1;
        conflict = true;
    }

    if (id.counter > m_localCounter)
    {
        m_localCounter = id.counter;
    }

    return id;
}

void CRDTBlockSequence::insertEntrySorted(const CRDTBlockEntry &entry)
{
    auto it = std::lower_bound(m_entries.begin(), m_entries.end(), entry, [](const CRDTBlockEntry &lhs, const CRDTBlockEntry &rhs) {
        if (lhs.position == rhs.position)
        {
            if (lhs.block.id.counter != rhs.block.id.counter)
            {
                return lhs.block.id.counter < rhs.block.id.counter;
            }

            return lhs.block.id.siteId < rhs.block.id.siteId;
        }

        return lhs.position < rhs.position;
    });

    m_entries.insert(it, entry);

    if (entry.position.counter > m_localCounter)
    {
        m_localCounter = entry.position.counter;
    }
}

bool CRDTBlockSequence::isBlockIdUnique(const CRDTId &blockId) const
{
    for (const auto &entry : m_entries)
    {
        if (entry.block.id.siteId == blockId.siteId && entry.block.id.counter == blockId.counter)
        {
            return false;
        }
    }

    return true;
}
}

