#ifndef ZAMETKI_DOCUMENT_H
#define ZAMETKI_DOCUMENT_H

#include <QString>
#include <QStringList>
#include <QVector>

#include "core/block.h"

namespace zametki::core
{
struct Document
{
    QString id;
    QString title;
    QStringList tags;
    QVector<Block> blocks;
};
}

#endif // ZAMETKI_DOCUMENT_H

