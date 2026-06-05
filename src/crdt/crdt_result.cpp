#include "crdt/crdt_result.h"

namespace zametki::crdt
{
CRDTResult CRDTResult::ok()
{
    return {};
}

CRDTResult CRDTResult::failure(CRDTError error, const QString &message)
{
    CRDTResult result;
    result.success = false;
    result.error = error;
    result.message = message;
    return result;
}

bool CRDTResult::isSuccess() const
{
    return success;
}

bool CRDTResult::isFailure() const
{
    return !success;
}
}

