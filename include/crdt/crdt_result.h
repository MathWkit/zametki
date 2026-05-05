#ifndef ZAMETKI_CRDT_RESULT_H
#define ZAMETKI_CRDT_RESULT_H

#include <QString>

#include "crdt/crdt_errors.h"

namespace zametki::crdt
{
struct CRDTResult
{
    bool success = true;
    CRDTError error = CRDTError::None;
    QString message;

    static CRDTResult ok();
    static CRDTResult failure(CRDTError error, const QString &message = QString());

    bool isSuccess() const;
    bool isFailure() const;
};
}

#endif // ZAMETKI_CRDT_RESULT_H

