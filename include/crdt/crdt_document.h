#ifndef ZAMETKI_CRDT_DOCUMENT_H
#define ZAMETKI_CRDT_DOCUMENT_H

#include <QString>
#include <QVector>

#include "crdt/crdt_block.h"

namespace zametki::crdt
{
class CRDTDocument
{
public:
    QString id;
    QVector<CRDTBlock> blocks;

    bool isEmpty() const;
    void clear();
};
}

#endif // ZAMETKI_CRDT_DOCUMENT_H

