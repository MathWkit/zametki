#ifndef ZAMETKI_CRDT_OPERATION_H
#define ZAMETKI_CRDT_OPERATION_H

namespace zametki::crdt
{
enum class CRDTOperationType
{
    InsertText,
    DeleteText,
    InsertBlock,
    DeleteBlock,
    UpdateBlockField,
    UpdateDocumentField
};
}

#endif // ZAMETKI_CRDT_OPERATION_H

