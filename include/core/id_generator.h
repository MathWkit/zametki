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

class UuidIdGenerator final : public IdGenerator
{
public:
    QString create() const override;
};
}

#endif // ZAMETKI_ID_GENERATOR_H

