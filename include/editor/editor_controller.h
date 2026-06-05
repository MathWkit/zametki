#ifndef ZAMETKI_EDITOR_CONTROLLER_H
#define ZAMETKI_EDITOR_CONTROLLER_H

#include <QObject>
#include <QHash>
#include <QString>

#include "core/document.h"
#include "core/blocks/todo_block.h"

namespace zametki::core
{
class DocumentManager;
}

namespace zametki::editor
{
class EditorCanvasWidget;
class BlockWidget;

class EditorController : public QObject
{
    Q_OBJECT
public:
    explicit EditorController(QObject *parent = nullptr);

    void setDocumentManager(zametki::core::DocumentManager *manager);
    void setCanvas(EditorCanvasWidget *canvas);

    void splitBlock(BlockWidget *block, int position);
    void mergeWithPrevious(BlockWidget *block);
    void createBlockBelow(BlockWidget *block);

private:
    void handleSnapshotChanged();
    void rebuildFromSnapshot(const zametki::core::Document &snapshot);
    void applyReplaceText(const QString &blockId, const QString &text);
    void applyTodoUpdate(const QString &blockId, const QString &text, bool done);

    zametki::core::DocumentManager *m_manager = nullptr;
    EditorCanvasWidget *m_canvas = nullptr;
    QHash<QString, QString> m_lastTextById;
    bool m_ignoreNextSnapshot = false;
};
}

#endif // ZAMETKI_EDITOR_CONTROLLER_H

