#ifndef ZAMETKI_EDITOR_CANVAS_WIDGET_H
#define ZAMETKI_EDITOR_CANVAS_WIDGET_H

#include <QWidget>

#include "editor/block_widget.h"

class QVBoxLayout;

namespace zametki::editor
{
class EditorCanvasWidget : public QWidget
{
    Q_OBJECT
public:
    explicit EditorCanvasWidget(QWidget *parent = nullptr);

    BlockWidget *addBlock(BlockWidget *block);
    void removeBlock(BlockWidget *block);
    void clearBlocks();

    BlockWidget *addParagraphBlock();
    BlockWidget *addHeadingBlock();
    BlockWidget *addTodoBlock();

private:
    QVBoxLayout *m_layout = nullptr;
    QWidget *m_spacer = nullptr;
};
}

#endif // ZAMETKI_EDITOR_CANVAS_WIDGET_H

