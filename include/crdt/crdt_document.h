#ifndef ZAMETKI_CRDT_DOCUMENT_H
#define ZAMETKI_CRDT_DOCUMENT_H

#include <QJsonObject>
#include <QSet>
#include <QStringList>
#include <QVector>

#include "core/blocks/heading_block.h"
#include "core/blocks/paragraph_block.h"
#include "core/blocks/todo_block.h"
#include "crdt/crdt_block_sequence.h"
#include "crdt/crdt_operation.h"
#include "crdt/crdt_text.h"

namespace zametki::crdt
{
class CRDTDocument
{
public:
    CRDTDocument();
    explicit CRDTDocument(quint32 siteId);

    QString id;
    QString title;
    QStringList tags;
    CRDTBlockSequence blocks;

    bool isEmpty() const;
    void clear();

    bool applyUpdateBlockField(const QString &operationId, const CRDTId &blockId, const QString &key, const QVariant &value, quint64 version);
    bool applyUpdateDocumentField(const QString &operationId, const QString &key, const QVariant &value);
    bool applyUpdateParagraph(const QString &operationId, const CRDTId &blockId, const CRDTText &text, quint64 version);
    bool applyUpdateHeading(const QString &operationId, const CRDTId &blockId, const CRDTText &text, int level, quint64 version);
    bool applyUpdateTodo(const QString &operationId, const CRDTId &blockId, const CRDTText &text, const core::TodoBlock &data, quint64 version);
    bool applyUpdateUnsupported(const QString &operationId, const CRDTId &blockId, const QString &sourceType, const QVariant &sourceData, quint64 version);
    bool applySetBlockType(const QString &operationId, const CRDTId &blockId, core::BlockType type);

    bool applyInsertBlock(const QString &operationId, const CRDTBlock &block, const CRDTSequenceId &left, const CRDTSequenceId &right);
    bool applyDeleteBlock(const QString &operationId, const CRDTId &blockId);
    bool applyReorderBlock(const QString &operationId, const CRDTId &blockId, const CRDTId &afterBlockId);

    QVector<QJsonObject> exportOperations() const;
    void importOperations(const QVector<QJsonObject> &operations);
    int mergeOperations(const QVector<QJsonObject> &operations);

    QJsonObject snapshot() const;
    bool restoreFromSnapshot(const QJsonObject &object);

    bool validate() const;

private:
    void logOperation(const QJsonObject &operation);
    bool applyUpdateBlockFieldInternal(const QString &operationId, const CRDTId &blockId, const QString &key, const QVariant &value, quint64 version, CRDTOperationType type);
    QJsonObject makeOperation(CRDTOperationType type, const QString &operationId) const;
    QJsonObject blockToJson(const CRDTBlock &block) const;
    CRDTBlock blockFromJson(const QJsonObject &object) const;

    QSet<QString> m_appliedOperationIds;
    QVector<QJsonObject> m_operationLog;
    quint32 m_siteId = 0;
};
}

#endif // ZAMETKI_CRDT_DOCUMENT_H

