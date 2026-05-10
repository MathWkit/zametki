#include "editor/todo_widget.h"

#include <QCheckBox>
#include <QHBoxLayout>
#include <QTextEdit>

namespace zametki::editor
{
TodoWidget::TodoWidget(QWidget *parent)
    : BlockWidget(parent)
{
    auto *layout = new QHBoxLayout(this);
    layout->setContentsMargins(0, 0, 0, 0);

    m_check = new QCheckBox(this);
    layout->addWidget(m_check);

    m_editor = new QTextEdit(this);
    m_editor->setAcceptRichText(false);
    layout->addWidget(m_editor, 1);
}

QString TodoWidget::text() const
{
    return m_editor ? m_editor->toPlainText() : QString();
}

void TodoWidget::setText(const QString &text)
{
    if (m_editor)
    {
        m_editor->setPlainText(text);
    }
}

bool TodoWidget::done() const
{
    return m_check && m_check->isChecked();
}

void TodoWidget::setDone(bool done)
{
    if (m_check)
    {
        m_check->setChecked(done);
    }
}
}

