#ifndef ZAMETKI_UNSUPPORTED_BLOCK_H
#define ZAMETKI_UNSUPPORTED_BLOCK_H

#include <QString>
#include <QVariantMap>

namespace zametki::core
{
struct UnsupportedBlock
{
    QString sourceType;
    QVariantMap sourceData;
};
}

#endif // ZAMETKI_UNSUPPORTED_BLOCK_H

