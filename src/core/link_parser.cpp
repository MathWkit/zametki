#include "core/link_parser.h"

#include <QRegularExpression>
#include <QSet>

namespace zametki::core
{
QVector<LinkTarget> LinkParser::parse(const QString &text) const
{
    QVector<LinkTarget> links;
    QSet<QString> seen;

    if (text.isEmpty())
    {
        return links;
    }

    const QRegularExpression re(QStringLiteral("\\[\\[([^\\]]+)\\]\\]"));
    QRegularExpressionMatchIterator it = re.globalMatch(text);
    while (it.hasNext())
    {
        const QRegularExpressionMatch match = it.next();
        const QString value = match.captured(1).trimmed();
        if (value.isEmpty())
        {
            continue;
        }

        if (seen.contains(value))
        {
            continue;
        }
        seen.insert(value);

        LinkTarget target;
        target.target = value;
        links.push_back(target);
    }

    return links;
}
}

