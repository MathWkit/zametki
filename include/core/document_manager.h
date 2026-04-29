#ifndef ZAMETKI_DOCUMENT_MANAGER_H
#define ZAMETKI_DOCUMENT_MANAGER_H

#include <QObject>
#include <QString>

#include "core/document.h"
#include "core/block_type.h"
#include "core/blocks/todo_block.h"

namespace zametki::core
{
class DocumentManager : public QObject
{
    Q_OBJECT
public:
    explicit DocumentManager(QObject *parent = nullptr);

    Document getSnapshot() const;

    bool load(const QString &id);
    bool save();

    void applyTextInsert(const QString &blockId, int position, const QString &text);
    void applyTextDelete(const QString &blockId, int position, int length);

    void insertBlock(const QString &afterBlockId, BlockType type);
    void deleteBlock(const QString &blockId);

    void updateTodoBlock(const QString &blockId, const TodoBlock &data);

signals:
    void snapshotChanged();
};
}

#endif // ZAMETKI_DOCUMENT_MANAGER_H

