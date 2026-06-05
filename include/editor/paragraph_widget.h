#ifndef ZAMETKI_PARAGRAPH_WIDGET_H
#define ZAMETKI_PARAGRAPH_WIDGET_H

#include "editor/block_widget.h"

class QTextEdit;

namespace zametki::editor
{
class ParagraphWidget : public BlockWidget
{
    Q_OBJECT
public:
    explicit ParagraphWidget(QWidget *parent = nullptr);

    QString text() const;
    void setText(const QString &text);

signals:
    void textEdited(const QString &text);

private:
    QTextEdit *m_editor = nullptr;
    bool m_ignoreChanges = false;
};
}

#endif // ZAMETKI_PARAGRAPH_WIDGET_H

