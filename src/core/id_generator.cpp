#include "core/id_generator.h"

#include <QUuid>
#include <QDateTime>
#include <QAtomicInteger>

namespace zametki::core
{

// Static singleton site ID (generated once per application instance)
static quint32 g_siteId = 0;
static bool g_siteIdInitialized = false;

// Operation counter (incremented for each operation)
static QAtomicInteger<quint32> g_operationCounter(0);

quint32 UuidIdGenerator::getSiteId()
{
    if (!g_siteIdInitialized) {
        // Generate unique site ID from UUID hash
        QUuid uuid = QUuid::createUuid();
        g_siteId = qHash(uuid) % (1u << 31);  // limit to 31-bit unsigned int
        g_siteIdInitialized = true;
    }
    return g_siteId;
}

quint32 UuidIdGenerator::getAndIncrementOperationCounter()
{
    return g_operationCounter.fetchAndAddRelaxed(1);
}

QString UuidIdGenerator::create() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

quint32 UuidIdGenerator::createSiteId() const
{
    return getSiteId();
}

QString UuidIdGenerator::createOperationId() const
{
    quint32 siteId = createSiteId();
    quint32 counter = getAndIncrementOperationCounter();
    qint64 timestamp = QDateTime::currentMSecsSinceEpoch();

    return QString("%1:%2:%3")
        .arg(siteId)
        .arg(counter)
        .arg(timestamp);
}

}

