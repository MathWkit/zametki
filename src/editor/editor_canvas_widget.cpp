#include "editor/editor_canvas_widget.h"

#include <QSizePolicy>
#include <QVBoxLayout>

#include "editor/heading_widget.h"
#include "editor/paragraph_widget.h"
#include "editor/todo_widget.h"

namespace zametki::editor
{
EditorCanvasWidget::EditorCanvasWidget(QWidget *parent)
    : QWidget(parent)
{
    m_layout = new QVBoxLayout(this);
    m_layout->setContentsMargins(8, 8, 8, 8);
    m_layout->setSpacing(8);

    m_spacer = new QWidget(this);
    m_spacer->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Expanding);
    m_layout->addWidget(m_spacer);
}

BlockWidget *EditorCanvasWidget::addBlock(BlockWidget *block)
{
    if (!block || !m_layout)
    {
        return nullptr;
    }

    m_layout->insertWidget(m_layout->count() - 1, block);
    return block;
}

void EditorCanvasWidget::removeBlock(BlockWidget *block)
{
    if (!block || !m_layout)
    {
        return;
    }

    m_layout->removeWidget(block);
    block->deleteLater();
}

void EditorCanvasWidget::clearBlocks()
{
    if (!m_layout)
    {
        return;
    }

    while (m_layout->count() > 1)
    {
        QLayoutItem *item = m_layout->takeAt(0);
        if (item && item->widget())
        {
            item->widget()->deleteLater();
        }
        delete item;
    }
}

BlockWidget *EditorCanvasWidget::addParagraphBlock()
{
    return addBlock(new ParagraphWidget(this));
}

BlockWidget *EditorCanvasWidget::addHeadingBlock()
{
    return addBlock(new HeadingWidget(this));
}

BlockWidget *EditorCanvasWidget::addTodoBlock()
{
    return addBlock(new TodoWidget(this));
}
}
