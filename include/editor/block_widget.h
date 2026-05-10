#ifndef ZAMETKI_BLOCK_WIDGET_H
#define ZAMETKI_BLOCK_WIDGET_H

#include <QWidget>

namespace zametki::editor
{
class BlockWidget : public QWidget
{
    Q_OBJECT
public:
    explicit BlockWidget(QWidget *parent = nullptr);

signals:
    void requestSplit();
    void requestMerge();
    void requestCreateBelow();
};
}

#endif // ZAMETKI_BLOCK_WIDGET_H

