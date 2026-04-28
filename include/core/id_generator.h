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

    virtual quint32 createSiteId() const = 0;

    virtual QString createOperationId() const = 0;
};

class UuidIdGenerator final : public IdGenerator
{
public:
    QString create() const override;
    quint32 createSiteId() const override;
    QString createOperationId() const override;

private:
    static quint32 getSiteId();
    static quint32 getAndIncrementOperationCounter();
};
}

#endif // ZAMETKI_ID_GENERATOR_H

