#ifndef ZAMETKI_HEADING_WIDGET_H
#define ZAMETKI_HEADING_WIDGET_H

#include "editor/block_widget.h"

class QTextEdit;

namespace zametki::editor
{
class HeadingWidget : public BlockWidget
{
    Q_OBJECT
public:
    explicit HeadingWidget(QWidget *parent = nullptr);

    QString text() const;
    void setText(const QString &text);
    void setLevel(int level);

signals:
    void textEdited(const QString &text);

private:
    QTextEdit *m_editor = nullptr;
    int m_level = 1;
    bool m_ignoreChanges = false;
};
}

#endif // ZAMETKI_HEADING_WIDGET_H

