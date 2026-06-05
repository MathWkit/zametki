#ifndef ZAMETKI_TODO_WIDGET_H
#define ZAMETKI_TODO_WIDGET_H

#include "editor/block_widget.h"

class QCheckBox;
class QTextEdit;

namespace zametki::editor
{
class TodoWidget : public BlockWidget
{
    Q_OBJECT
public:
    explicit TodoWidget(QWidget *parent = nullptr);

    QString text() const;
    void setText(const QString &text);
    bool done() const;
    void setDone(bool done);

signals:
    void textEdited(const QString &text);
    void doneToggled(bool done);

private:
    QCheckBox *m_check = nullptr;
    QTextEdit *m_editor = nullptr;
    bool m_ignoreChanges = false;
};
}

#endif // ZAMETKI_TODO_WIDGET_H

