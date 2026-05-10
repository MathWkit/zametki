#include "editor/heading_widget.h"

#include <QFont>
#include <QTextEdit>
#include <QtGlobal>
#include <QVBoxLayout>

namespace zametki::editor
{
HeadingWidget::HeadingWidget(QWidget *parent)
	: BlockWidget(parent)
{
	auto *layout = new QVBoxLayout(this);
	layout->setContentsMargins(0, 0, 0, 0);

	m_editor = new QTextEdit(this);
	m_editor->setAcceptRichText(false);
	layout->addWidget(m_editor);

	setLevel(1);
}

QString HeadingWidget::text() const
{
	return m_editor ? m_editor->toPlainText() : QString();
}

void HeadingWidget::setText(const QString &text)
{
	if (m_editor)
	{
		m_editor->setPlainText(text);
	}
}

void HeadingWidget::setLevel(int level)
{
	m_level = qBound(1, level, 6);
	if (!m_editor)
	{
		return;
	}

	QFont font = m_editor->font();
	font.setBold(true);
	const int baseSize = 18;
	font.setPointSize(baseSize - (m_level - 1));
	m_editor->setFont(font);
}
}

