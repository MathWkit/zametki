#include "core/document_factory.h"

#include <QVariantMap>

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

Block DocumentFactory::createParagraphBlock(const QString &text) const
{
    Block block;
    block.id = m_idGenerator.create();
    block.type = BlockType::Paragraph;
    block.data = text;
    return block;
}

Block DocumentFactory::createHeadingBlock(const QString &text, const int level) const
{
    Block block;
    block.id = m_idGenerator.create();
    block.type = BlockType::Heading;
    block.data = QVariantMap{{QStringLiteral("text"), text}, {QStringLiteral("level"), level}};
    return block;
}

Block DocumentFactory::createTodoBlock(const QString &text) const
{
    Block block;
    block.id = m_idGenerator.create();
    block.type = BlockType::Todo;
    block.data = QVariantMap{
        {QStringLiteral("text"), text},
        {QStringLiteral("done"), false},
        {QStringLiteral("priority"), QString()},
        {QStringLiteral("deadline"), QString()},
        {QStringLiteral("color"), QString()}
    };
    return block;
}
}
