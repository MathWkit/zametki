#include "editor/block_widget.h"

namespace zametki::editor
{
BlockWidget::BlockWidget(QWidget *parent)
    : QWidget(parent)
{
}

QString BlockWidget::blockId() const
{
    return m_blockId;
}

void BlockWidget::setBlockId(const QString &blockId)
{
    m_blockId = blockId;
}
}
