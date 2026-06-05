#ifndef ZAMETKI_LINK_PARSER_H
#define ZAMETKI_LINK_PARSER_H

#include <QVector>
#include <QString>

namespace zametki::core
{
struct LinkTarget
{
    QString target;
};

class LinkParser
{
public:
    QVector<LinkTarget> parse(const QString &text) const;
};
}

#endif // ZAMETKI_LINK_PARSER_H

