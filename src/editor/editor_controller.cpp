#include "editor/editor_controller.h"

#include <QVariantMap>

#include "core/block_text_accessor.h"
#include "core/document_manager.h"
#include "editor/block_widget.h"
#include "editor/editor_canvas_widget.h"
#include "editor/heading_widget.h"
#include "editor/paragraph_widget.h"
#include "editor/todo_widget.h"

namespace zametki::editor
{
EditorController::EditorController(QObject *parent)
    : QObject(parent)
{
}

void EditorController::setDocumentManager(zametki::core::DocumentManager *manager)
{
    if (m_manager == manager)
    {
        return;
    }

    if (m_manager)
    {
        disconnect(m_manager, nullptr, this, nullptr);
    }

    m_manager = manager;
    if (m_manager)
    {
        connect(m_manager, &zametki::core::DocumentManager::snapshotChanged, this, &EditorController::handleSnapshotChanged);
        handleSnapshotChanged();
    }
}

void EditorController::setCanvas(EditorCanvasWidget *canvas)
{
    m_canvas = canvas;
    if (m_canvas && m_manager)
    {
        handleSnapshotChanged();
    }
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
    if (!m_manager || !block)
    {
        return;
    }

    const QString blockId = block->blockId();
    if (blockId.isEmpty())
    {
        return;
    }

    m_manager->insertBlock(blockId, zametki::core::BlockType::Paragraph);
}

void EditorController::handleSnapshotChanged()
{
    if (!m_manager || !m_canvas)
    {
        return;
    }

    if (m_ignoreNextSnapshot)
    {
        m_ignoreNextSnapshot = false;
        return;
    }

    rebuildFromSnapshot(m_manager->getSnapshot());
}

void EditorController::rebuildFromSnapshot(const zametki::core::Document &snapshot)
{
    if (!m_canvas)
    {
        return;
    }

    m_canvas->clearBlocks();
    m_lastTextById.clear();

    for (const auto &block : snapshot.blocks)
    {
        BlockWidget *widget = nullptr;
        if (block.type == zametki::core::BlockType::Paragraph)
        {
            auto *paragraph = static_cast<ParagraphWidget *>(m_canvas->addParagraphBlock());
            paragraph->setText(zametki::core::BlockTextAccessor::getText(block));
            connect(paragraph, &ParagraphWidget::textEdited, this, [this, paragraph](const QString &text)
            {
                applyReplaceText(paragraph->blockId(), text);
            });
            widget = paragraph;
        }
        else if (block.type == zametki::core::BlockType::Heading)
        {
            auto *heading = static_cast<HeadingWidget *>(m_canvas->addHeadingBlock());
            const QVariantMap map = block.data.toMap();
            heading->setText(map.value(QStringLiteral("text")).toString());
            heading->setLevel(map.value(QStringLiteral("level"), 1).toInt());
            connect(heading, &HeadingWidget::textEdited, this, [this, heading](const QString &text)
            {
                applyReplaceText(heading->blockId(), text);
            });
            widget = heading;
        }
        else if (block.type == zametki::core::BlockType::Todo)
        {
            auto *todo = static_cast<TodoWidget *>(m_canvas->addTodoBlock());
            const QVariantMap map = block.data.toMap();
            todo->setText(map.value(QStringLiteral("text")).toString());
            todo->setDone(map.value(QStringLiteral("done")).toBool());
            connect(todo, &TodoWidget::textEdited, this, [this, todo](const QString &text)
            {
                applyTodoUpdate(todo->blockId(), text, todo->done());
            });
            connect(todo, &TodoWidget::doneToggled, this, [this, todo](bool done)
            {
                applyTodoUpdate(todo->blockId(), todo->text(), done);
            });
            widget = todo;
        }

        if (widget)
        {
            widget->setBlockId(block.id);
            m_lastTextById.insert(block.id, zametki::core::BlockTextAccessor::getText(block));
        }
    }
}

void EditorController::applyReplaceText(const QString &blockId, const QString &text)
{
    if (!m_manager || blockId.isEmpty())
    {
        return;
    }

    const QString previous = m_lastTextById.value(blockId);
    if (previous == text)
    {
        return;
    }

    if (!previous.isEmpty())
    {
        m_manager->applyTextDelete(blockId, 0, previous.size());
    }
    if (!text.isEmpty())
    {
        m_manager->applyTextInsert(blockId, 0, text);
    }

    m_lastTextById.insert(blockId, text);
    m_ignoreNextSnapshot = true;
}

void EditorController::applyTodoUpdate(const QString &blockId, const QString &text, bool done)
{
    if (!m_manager || blockId.isEmpty())
    {
        return;
    }

    zametki::core::TodoBlock data;
    data.text = text;
    data.done = done;
    m_manager->updateTodoBlock(blockId, data);
    m_lastTextById.insert(blockId, text);
    m_ignoreNextSnapshot = true;
}
}
