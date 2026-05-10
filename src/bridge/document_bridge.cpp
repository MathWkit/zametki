#include "bridge/document_bridge.h"

#include <QSettings>
#include <QVariantMap>

#include "core/document_manager.h"
#include "export/markdown_exporter.h"

namespace zametki::bridge
{
namespace
{
QVariantMap toVariantMap(const zametki::core::Document &doc)
{
    QVariantMap map;
    map.insert(QStringLiteral("id"), doc.id);
    map.insert(QStringLiteral("title"), doc.title);
    map.insert(QStringLiteral("tags"), doc.tags);
    map.insert(QStringLiteral("blocksCount"), doc.blocks.size());
    return map;
}

QVariantList toVariantList(const QVector<zametki::core::Document> &docs)
{
    QVariantList list;
    list.reserve(docs.size());
    for (const auto &doc : docs)
    {
        list.append(toVariantMap(doc));
    }
    return list;
}
}

DocumentBridge::DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent)
    : QObject(parent)
    , m_manager(manager)
{
    QSettings settings;
    m_blockEditorEnabled = settings.value(QStringLiteral("features/blockEditorEnabled"), true).toBool();
}

QVariantList DocumentBridge::getAllDocuments() const
{
    if (!m_manager)
    {
        return {};
    }
    return toVariantList(m_manager->listAllDocuments());
}

QVariantList DocumentBridge::searchDocuments(const QString &query) const
{
    if (!m_manager)
    {
        return {};
    }
    return toVariantList(m_manager->searchDocuments(query));
}

QVariantList DocumentBridge::getBacklinks(const QString &noteId) const
{
    if (!m_manager)
    {
        return {};
    }
    return toVariantList(m_manager->getBacklinks(noteId));
}

bool DocumentBridge::openDocument(const QString &id)
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }

    const bool ok = m_manager->load(id);
    if (!ok)
    {
        m_lastError = m_manager->lastError();
    }
    return ok;
}

bool DocumentBridge::saveDocument()
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }

    const bool ok = m_manager->save();
    if (!ok)
    {
        m_lastError = m_manager->lastError();
    }
    return ok;
}

QString DocumentBridge::exportCurrentToMarkdown()
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return QString();
    }

    const zametki::core::Document snapshot = m_manager->getSnapshot();
    zametki::exporter::MarkdownExporter exporter;
    const QString path = exporter.exportToFile(snapshot);
    if (path.isEmpty())
    {
        m_lastError = exporter.lastError();
    }
    return path;
}

QString DocumentBridge::lastError() const
{
    return m_lastError;
}

bool DocumentBridge::blockEditorEnabled() const
{
    return m_blockEditorEnabled;
}

void DocumentBridge::setBlockEditorEnabled(bool enabled)
{
    if (m_blockEditorEnabled == enabled)
    {
        return;
    }

    m_blockEditorEnabled = enabled;
    QSettings settings;
    settings.setValue(QStringLiteral("features/blockEditorEnabled"), m_blockEditorEnabled);
    emit blockEditorEnabledChanged();
}
}
