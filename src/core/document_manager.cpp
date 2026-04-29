#include "core/document_manager.h"

namespace zametki::core
{
DocumentManager::DocumentManager(QObject *parent)
    : QObject(parent)
{
}

Document DocumentManager::getSnapshot() const
{
    return {};
}

bool DocumentManager::load(const QString &id)
{
    Q_UNUSED(id)
    return false;
}

bool DocumentManager::save()
{
    return false;
}

void DocumentManager::applyTextInsert(const QString &blockId, int position, const QString &text)
{
    Q_UNUSED(blockId)
    Q_UNUSED(position)
    Q_UNUSED(text)
}

void DocumentManager::applyTextDelete(const QString &blockId, int position, int length)
{
    Q_UNUSED(blockId)
    Q_UNUSED(position)
    Q_UNUSED(length)
}

void DocumentManager::insertBlock(const QString &afterBlockId, BlockType type)
{
    Q_UNUSED(afterBlockId)
    Q_UNUSED(type)
}

void DocumentManager::deleteBlock(const QString &blockId)
{
    Q_UNUSED(blockId)
}

void DocumentManager::updateTodoBlock(const QString &blockId, const TodoBlock &data)
{
    Q_UNUSED(blockId)
    Q_UNUSED(data)
}
}

