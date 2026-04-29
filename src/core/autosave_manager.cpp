#include "core/autosave_manager.h"

namespace zametki::core
{
AutosaveManager::AutosaveManager(QObject *parent)
    : QObject(parent)
{
}

void AutosaveManager::setDebounceInterval(int milliseconds)
{
    Q_UNUSED(milliseconds)
}

void AutosaveManager::markDirty()
{
}

void AutosaveManager::scheduleSave()
{
}

void AutosaveManager::flushNow()
{
}
}

