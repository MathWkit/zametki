#include "export/markdown_exporter.h"

#include <QDate>
#include <QDir>
#include <QtGlobal>
#include <QSaveFile>
#include <QStandardPaths>
#include <QStringList>
#include <QVariantMap>

#include "core/block_text_accessor.h"
#include "core/blocks/heading_block.h"
#include "core/blocks/paragraph_block.h"
#include "core/blocks/todo_block.h"

namespace zametki::exporter
{
namespace
{
QString paragraphText(const core::Block &block)
{
    if (block.data.canConvert<core::ParagraphBlock>())
    {
        return block.data.value<core::ParagraphBlock>().text;
    }

    if (block.data.canConvert<QVariantMap>())
    {
        const QVariantMap map = block.data.toMap();
        return map.value(QStringLiteral("text")).toString();
    }

    return block.data.toString();
}

QString headingText(const core::Block &block, int &level)
{
    level = 1;

    if (block.data.canConvert<core::HeadingBlock>())
    {
        const core::HeadingBlock data = block.data.value<core::HeadingBlock>();
        level = data.level;
        return data.text;
    }

    if (block.data.canConvert<QVariantMap>())
    {
        const QVariantMap map = block.data.toMap();
        level = map.value(QStringLiteral("level"), 1).toInt();
        return map.value(QStringLiteral("text")).toString();
    }

    return block.data.toString();
}

core::TodoBlock todoBlockFromVariant(const QVariant &data)
{
    core::TodoBlock block;
    if (data.canConvert<core::TodoBlock>())
    {
        return data.value<core::TodoBlock>();
    }

    if (data.canConvert<QVariantMap>())
    {
        const QVariantMap map = data.toMap();
        block.text = map.value(QStringLiteral("text")).toString();
        block.done = map.value(QStringLiteral("done"), false).toBool();
        block.priority = map.value(QStringLiteral("priority")).toString();
        block.deadline = QDate::fromString(map.value(QStringLiteral("deadline")).toString(), Qt::ISODate);
        block.color = map.value(QStringLiteral("color")).toString();
        return block;
    }

    block.text = data.toString();
    return block;
}

QString formatTodoMetadata(const core::TodoBlock &block)
{
    QStringList parts;
    if (!block.priority.isEmpty())
    {
        parts.append(QStringLiteral("priority: %1").arg(block.priority));
    }
    if (block.deadline.isValid())
    {
        parts.append(QStringLiteral("deadline: %1").arg(block.deadline.toString(Qt::ISODate)));
    }
    if (!block.color.isEmpty())
    {
        parts.append(QStringLiteral("color: %1").arg(block.color));
    }

    if (parts.isEmpty())
    {
        return QString();
    }

    return QStringLiteral(" (") + parts.join(QStringLiteral(", ")) + QStringLiteral(")");
}
}

QString MarkdownExporter::toMarkdown(const core::Document &document) const
{
    QStringList lines;

    if (!document.title.isEmpty())
    {
        lines.append(QStringLiteral("# ") + document.title);
        lines.append(QString());
    }

    for (const auto &block : document.blocks)
    {
        if (block.type == core::BlockType::Paragraph)
        {
            lines.append(paragraphText(block));
            lines.append(QString());
        }
        else if (block.type == core::BlockType::Heading)
        {
            int level = 1;
            const QString text = headingText(block, level);
            level = qBound(1, level, 6);
            lines.append(QString(level, QLatin1Char('#')) + QLatin1Char(' ') + text);
            lines.append(QString());
        }
        else if (block.type == core::BlockType::Todo)
        {
            const core::TodoBlock todo = todoBlockFromVariant(block.data);
            const QString doneMark = todo.done ? QStringLiteral("x") : QStringLiteral(" ");
            lines.append(QStringLiteral("- [%1] ").arg(doneMark) + todo.text + formatTodoMetadata(todo));
            lines.append(QString());
        }
        else
        {
            const QString text = core::BlockTextAccessor::getText(block);
            if (!text.isEmpty())
            {
                lines.append(text);
                lines.append(QString());
            }
        }
    }

    while (!lines.isEmpty() && lines.last().isEmpty())
    {
        lines.removeLast();
    }

    return lines.join(QLatin1Char('\n'));
}

QString MarkdownExporter::exportToFile(const core::Document &document, const QString &baseDir)
{
    m_lastError.clear();
    const QString rootDir = baseDir.isEmpty()
                                ? QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
                                : baseDir;
    if (rootDir.isEmpty())
    {
        m_lastError = QStringLiteral("export_root_missing");
        return QString();
    }

    QDir dir(rootDir);
    if (!dir.exists() && !dir.mkpath(QStringLiteral(".")))
    {
        m_lastError = QStringLiteral("export_root_unavailable");
        return QString();
    }

    const QString exportDir = dir.filePath(QStringLiteral("exports"));
    if (!dir.mkpath(exportDir))
    {
        m_lastError = QStringLiteral("export_dir_failed");
        return QString();
    }

    const QString fileId = document.id.isEmpty() ? QStringLiteral("untitled") : document.id;
    const QString filePath = QDir(exportDir).filePath(fileId + QStringLiteral(".md"));

    QSaveFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        m_lastError = QStringLiteral("export_open_failed");
        return QString();
    }

    const QByteArray data = toMarkdown(document).toUtf8();
    if (file.write(data) != data.size())
    {
        m_lastError = QStringLiteral("export_write_failed");
        file.cancelWriting();
        return QString();
    }

    if (!file.commit())
    {
        m_lastError = QStringLiteral("export_commit_failed");
        return QString();
    }

    return filePath;
}

QString MarkdownExporter::lastError() const
{
    return m_lastError;
}
}

