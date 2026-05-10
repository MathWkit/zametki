#ifndef ZAMETKI_EDITOR_CONTROLLER_H
#define ZAMETKI_EDITOR_CONTROLLER_H

#include <QObject>

namespace zametki::editor
{
class BlockWidget;

class EditorController : public QObject
{
    Q_OBJECT
public:
    explicit EditorController(QObject *parent = nullptr);

    void splitBlock(BlockWidget *block, int position);
    void mergeWithPrevious(BlockWidget *block);
    void createBlockBelow(BlockWidget *block);
};
}

#endif // ZAMETKI_EDITOR_CONTROLLER_H

