#include "editor/paragraph_widget.h"

#include <QTextEdit>
#include <QVBoxLayout>

namespace zametki::editor
{
ParagraphWidget::ParagraphWidget(QWidget *parent)
    : BlockWidget(parent)
{
    auto *layout = new QVBoxLayout(this);
    layout->setContentsMargins(0, 0, 0, 0);

    m_editor = new QTextEdit(this);
    m_editor->setAcceptRichText(false);
    layout->addWidget(m_editor);
}

QString ParagraphWidget::text() const
{
    return m_editor ? m_editor->toPlainText() : QString();
}

void ParagraphWidget::setText(const QString &text)
{
    if (m_editor)
    {
        m_editor->setPlainText(text);
    }
}
}

