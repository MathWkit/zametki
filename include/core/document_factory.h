#ifndef ZAMETKI_DOCUMENT_FACTORY_H
#define ZAMETKI_DOCUMENT_FACTORY_H

#include <QString>

#include "core/block.h"
#include "core/document.h"
#include "core/id_generator.h"

namespace zametki::core
{
class DocumentFactory
{
public:
    explicit DocumentFactory(const IdGenerator &idGenerator);

    Document createEmptyDocument(const QString &title = QString()) const;
    Block createParagraphBlock(const QString &text = QString()) const;
    Block createHeadingBlock(const QString &text = QString(), int level = 1) const;
    Block createTodoBlock(const QString &text = QString()) const;

private:
    const IdGenerator &m_idGenerator;
};
}

#endif // ZAMETKI_DOCUMENT_FACTORY_H

