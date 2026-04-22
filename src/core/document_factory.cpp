#include "core/document_factory.h"

namespace zametki::core
{
DocumentFactory::DocumentFactory(const IdGenerator &idGenerator)
    : m_idGenerator(idGenerator)
{
}

Document DocumentFactory::createEmptyDocument(const QString &title) const
{
    Document document;
    document.id = m_idGenerator.create();
    document.title = title;
    return document;
}
}

