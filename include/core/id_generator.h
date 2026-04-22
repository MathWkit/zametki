#ifndef ZAMETKI_ID_GENERATOR_H
#define ZAMETKI_ID_GENERATOR_H

#include <QString>

namespace zametki::core
{
class IdGenerator
{
public:
    virtual ~IdGenerator() = default;
    virtual QString create() const = 0;
};
}

#endif // ZAMETKI_ID_GENERATOR_H

