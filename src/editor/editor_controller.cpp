#include "editor/editor_controller.h"

namespace zametki::editor
{
EditorController::EditorController(QObject *parent)
    : QObject(parent)
{
}

void EditorController::splitBlock(BlockWidget *block, int position)
{
    Q_UNUSED(block)
    Q_UNUSED(position)
}

void EditorController::mergeWithPrevious(BlockWidget *block)
{
    Q_UNUSED(block)
}

void EditorController::createBlockBelow(BlockWidget *block)
{
    Q_UNUSED(block)
}
}

