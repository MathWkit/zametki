#include "core/id_generator.h"

#include <QUuid>

namespace zametki::core
{
QString UuidIdGenerator::create() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}
}

