#include "crdt/crdt_text.h"

#include <QJsonArray>
#include <algorithm>

namespace zametki::crdt
{
CRDTText::CRDTText(quint32 siteId)
    : m_siteId(siteId)
{
}

quint32 CRDTText::siteId() const
{
    return m_siteId;
}

void CRDTText::setSiteId(quint32 siteId)
{
    m_siteId = siteId;
}

int CRDTText::length() const
{
    int count = 0;
    for (const auto &element : m_elements)
    {
        if (!element.deleted)
        {
            ++count;
        }
    }

    return count;
}

int CRDTText::elementCount() const
{
    return m_elements.size();
}

bool CRDTText::applyInsert(const QString &operationId, int position, const QString &text)
{
    if (text.isEmpty())
    {
        return false;
    }

    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    position = clampPosition(position);
    bool conflictSeen = false;

    for (int i = 0; i < text.size(); ++i)
    {
        const int targetPosition = position + i;
        const int elementIndex = elementIndexFromVisible(targetPosition);

        CRDTSequenceId left;
        for (int leftIndex = elementIndex - 1; leftIndex >= 0; --leftIndex)
        {
            if (!m_elements.at(leftIndex).deleted)
            {
                left = m_elements.at(leftIndex).id;
                break;
            }
        }

        CRDTSequenceId right;
        for (int rightIndex = elementIndex; rightIndex < m_elements.size(); ++rightIndex)
        {
            if (!m_elements.at(rightIndex).deleted)
            {
                right = m_elements.at(rightIndex).id;
                break;
            }
        }

        bool conflict = false;
        CRDTSequenceId id = generateIdBetween(left, right, conflict);
        conflictSeen = conflictSeen || conflict;

        CRDTTextElement element;
        element.id = id;
        element.value = text.at(i);
        element.deleted = false;
        insertElementSorted(element);
    }

    if (conflictSeen)
    {
        m_hasConflict = true;
    }

    m_appliedOperationIds.insert(operationId);
    return true;
}

bool CRDTText::applyDelete(const QString &operationId, int position, int length)
{
    if (length <= 0)
    {
        return false;
    }

    if (m_appliedOperationIds.contains(operationId))
    {
        return false;
    }

    const int currentLength = this->length();
    if (currentLength == 0)
    {
        return false;
    }

    position = clampPosition(position);
    if (position >= currentLength)
    {
        return false;
    }

    if (position + length > currentLength)
    {
        length = currentLength - position;
    }

    int visibleIndex = 0;
    int deletedCount = 0;
    for (auto &element : m_elements)
    {
        if (element.deleted)
        {
            continue;
        }

        if (visibleIndex >= position && deletedCount < length)
        {
            element.deleted = true;
            ++deletedCount;
        }

        ++visibleIndex;
        if (deletedCount >= length)
        {
            break;
        }
    }

    if (deletedCount == 0)
    {
        return false;
    }

    m_appliedOperationIds.insert(operationId);
    return true;
}

QString CRDTText::toQString() const
{
    QString result;
    result.reserve(length());

    for (const auto &element : m_elements)
    {
        if (!element.deleted)
        {
            result.append(element.value);
        }
    }

    return result;
}

void CRDTText::fromQString(const QString &text, quint32 siteId)
{
    m_elements.clear();
    m_appliedOperationIds.clear();
    m_siteId = siteId;
    m_localCounter = 0;
    m_hasConflict = false;

    for (int i = 0; i < text.size(); ++i)
    {
        CRDTTextElement element;
        element.id.siteId = siteId;
        element.id.counter = ++m_localCounter;
        element.value = text.at(i);
        element.deleted = false;
        m_elements.push_back(element);
    }
}

QJsonObject CRDTText::serialize() const
{
    QJsonObject object;
    object.insert(QStringLiteral("site_id"), static_cast<qint64>(m_siteId));
    object.insert(QStringLiteral("counter"), static_cast<qint64>(m_localCounter));

    QJsonArray elements;
    for (const auto &element : m_elements)
    {
        QJsonObject elementObj;
        elementObj.insert(QStringLiteral("id"), element.id.toString());
        elementObj.insert(QStringLiteral("ch"), QString(element.value));
        elementObj.insert(QStringLiteral("deleted"), element.deleted);
        elements.append(elementObj);
    }
    object.insert(QStringLiteral("elements"), elements);

    QJsonArray applied;
    for (const auto &opId : m_appliedOperationIds)
    {
        applied.append(opId);
    }
    object.insert(QStringLiteral("applied"), applied);

    return object;
}

CRDTText CRDTText::deserialize(const QJsonObject &object)
{
    CRDTText text;

    text.m_siteId = static_cast<quint32>(object.value(QStringLiteral("site_id")).toInteger());
    text.m_localCounter = static_cast<quint64>(object.value(QStringLiteral("counter")).toInteger());

    const QJsonArray elements = object.value(QStringLiteral("elements")).toArray();
    for (const auto &value : elements)
    {
        if (!value.isObject())
        {
            continue;
        }

        const QJsonObject elementObj = value.toObject();
        CRDTSequenceId id = CRDTSequenceId::fromString(elementObj.value(QStringLiteral("id")).toString());
        if (!id.isValid())
        {
            continue;
        }

        const QString ch = elementObj.value(QStringLiteral("ch")).toString();
        if (ch.isEmpty())
        {
            continue;
        }

        CRDTTextElement element;
        element.id = id;
        element.value = ch.at(0);
        element.deleted = elementObj.value(QStringLiteral("deleted")).toBool(false);
        text.m_elements.push_back(element);
    }

    const QJsonArray applied = object.value(QStringLiteral("applied")).toArray();
    for (const auto &value : applied)
    {
        if (value.isString())
        {
            text.m_appliedOperationIds.insert(value.toString());
        }
    }

    std::sort(text.m_elements.begin(), text.m_elements.end(), [](const CRDTTextElement &lhs, const CRDTTextElement &rhs) {
        return lhs.id < rhs.id;
    });

    return text;
}

QChar CRDTText::at(int index) const
{
    if (index < 0)
    {
        return {};
    }

    int visibleIndex = 0;
    for (const auto &element : m_elements)
    {
        if (element.deleted)
        {
            continue;
        }

        if (visibleIndex == index)
        {
            return element.value;
        }

        ++visibleIndex;
    }

    return {};
}

bool CRDTText::hasConflict() const
{
    return m_hasConflict;
}

int CRDTText::clampPosition(int position) const
{
    if (position < 0)
    {
        return 0;
    }

    const int maxPos = length();
    if (position > maxPos)
    {
        return maxPos;
    }

    return position;
}

int CRDTText::elementIndexFromVisible(int position) const
{
    if (position <= 0)
    {
        return 0;
    }

    int visibleIndex = 0;
    for (int i = 0; i < m_elements.size(); ++i)
    {
        if (m_elements.at(i).deleted)
        {
            continue;
        }

        if (visibleIndex == position)
        {
            return i;
        }

        ++visibleIndex;
    }

    return m_elements.size();
}

void CRDTText::insertElementSorted(const CRDTTextElement &element)
{
    auto it = std::lower_bound(m_elements.begin(), m_elements.end(), element, [](const CRDTTextElement &lhs, const CRDTTextElement &rhs) {
        return lhs.id < rhs.id;
    });

    m_elements.insert(it, element);
    if (element.id.counter > m_localCounter)
    {
        m_localCounter = element.id.counter;
    }
}

CRDTSequenceId CRDTText::generateIdBetween(const CRDTSequenceId &left, const CRDTSequenceId &right, bool &conflict)
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
}

