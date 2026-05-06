#include "core/autosave_manager.h"

#include "core/document_manager.h"

namespace zametki::core
{
AutosaveManager::AutosaveManager(QObject *parent)
    : QObject(parent)
{
    m_timer.setSingleShot(true);
    m_manager = qobject_cast<DocumentManager *>(parent);
    if (m_manager)
    {
        QObject::connect(m_manager, &DocumentManager::snapshotChanged, this, &AutosaveManager::markDirty);
    }
    QObject::connect(&m_timer, &QTimer::timeout, this, &AutosaveManager::flushNow);
}

void AutosaveManager::setDebounceInterval(int milliseconds)
{
    m_timer.setInterval(milliseconds);
}

void AutosaveManager::markDirty()
{
    scheduleSave();
}

void AutosaveManager::scheduleSave()
{
    if (!m_timer.isActive())
    {
        m_timer.start();
    }
    else
    {
        m_timer.start(m_timer.interval());
    }
}

void AutosaveManager::flushNow()
{
    if (m_manager)
    {
        m_manager->save();
    }
}

void AutosaveManager::setDocumentManager(DocumentManager *manager)
{
    if (m_manager == manager)
    {
        return;
    }

    if (m_manager)
    {
        QObject::disconnect(m_manager, &DocumentManager::snapshotChanged, this, &AutosaveManager::markDirty);
    }

    m_manager = manager;
    if (m_manager)
    {
        QObject::connect(m_manager, &DocumentManager::snapshotChanged, this, &AutosaveManager::markDirty);
    }
}
}
