#ifndef ZAMETKI_CRDT_ERRORS_H
#define ZAMETKI_CRDT_ERRORS_H

#include <QString>

namespace zametki::crdt
{
enum class CRDTError
{
    None,
    InvalidArgument,
    InvalidState,
    NotFound,
    Conflict,
    SerializationError,
    DeserializationError,
    InternalError
};

QString toString(CRDTError error);
CRDTError errorFromString(const QString &text);
}

#endif // ZAMETKI_CRDT_ERRORS_H

