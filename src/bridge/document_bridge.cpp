#include "bridge/document_bridge.h"

#include "core/document_manager.h"

namespace zametki::bridge
{
DocumentBridge::DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent)
    : QObject(parent)
    , m_manager(manager)
{
}

QVariantList DocumentBridge::getAllDocuments() const
{
    return {};
}

QVariantList DocumentBridge::searchDocuments(const QString &query) const
{
    Q_UNUSED(query)
    return {};
}

QVariantList DocumentBridge::getBacklinks(const QString &noteId) const
{
    Q_UNUSED(noteId)
    return {};
}

bool DocumentBridge::openDocument(const QString &id)
{
    Q_UNUSED(id)
    return false;
}

bool DocumentBridge::saveDocument()
{
    return false;
}
}

