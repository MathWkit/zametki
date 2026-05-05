#include "crdt/crdt_errors.h"

namespace zametki::crdt
{
QString toString(CRDTError error)
{
    switch (error)
    {
    case CRDTError::None:
        return QStringLiteral("none");
    case CRDTError::InvalidArgument:
        return QStringLiteral("invalid_argument");
    case CRDTError::InvalidState:
        return QStringLiteral("invalid_state");
    case CRDTError::NotFound:
        return QStringLiteral("not_found");
    case CRDTError::Conflict:
        return QStringLiteral("conflict");
    case CRDTError::SerializationError:
        return QStringLiteral("serialization_error");
    case CRDTError::DeserializationError:
        return QStringLiteral("deserialization_error");
    case CRDTError::InternalError:
        return QStringLiteral("internal_error");
    }

    return QStringLiteral("unknown");
}

CRDTError errorFromString(const QString &text)
{
    if (text == QStringLiteral("none"))
        return CRDTError::None;
    if (text == QStringLiteral("invalid_argument"))
        return CRDTError::InvalidArgument;
    if (text == QStringLiteral("invalid_state"))
        return CRDTError::InvalidState;
    if (text == QStringLiteral("not_found"))
        return CRDTError::NotFound;
    if (text == QStringLiteral("conflict"))
        return CRDTError::Conflict;
    if (text == QStringLiteral("serialization_error"))
        return CRDTError::SerializationError;
    if (text == QStringLiteral("deserialization_error"))
        return CRDTError::DeserializationError;
    if (text == QStringLiteral("internal_error"))
        return CRDTError::InternalError;

    return CRDTError::InternalError;
}
}

