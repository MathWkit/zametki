#ifndef ZAMETKI_MARKDOWN_EXPORTER_H
#define ZAMETKI_MARKDOWN_EXPORTER_H

#include <QString>

#include "core/document.h"

namespace zametki::exporter
{
class MarkdownExporter
{
public:
    QString toMarkdown(const core::Document &document) const;
    QString exportToFile(const core::Document &document, const QString &baseDir = QString());
    QString lastError() const;

private:
    QString m_lastError;
};
}

#endif // ZAMETKI_MARKDOWN_EXPORTER_H

