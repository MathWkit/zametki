#include "bridge/document_bridge.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QHash>
#include <QRegularExpression>
#include <QSettings>
#include <QUrl>
#include <QVariantMap>

#include "core/block_text_accessor.h"
#include "core/blocks/heading_block.h"
#include "core/blocks/todo_block.h"
#include "core/document_manager.h"
#include "export/markdown_exporter.h"

namespace zametki::bridge
{
namespace
{
const QString kDatabaseDirectorySettingsKey = QStringLiteral("storage/databaseDirectory");

bool isValidRelativeFolderPath(const QString &folderPath)
{
    if (folderPath.isEmpty())
    {
        return true;
    }

    if (QDir::isAbsolutePath(folderPath))
    {
        return false;
    }

    const QString cleanedPath = QDir::cleanPath(folderPath);
    return !(cleanedPath == QStringLiteral(".") || cleanedPath == QStringLiteral("..")
             || cleanedPath.startsWith(QStringLiteral("../")) || cleanedPath.contains(QStringLiteral("/../")));
}

QString normalizeRelativeFolderPath(const QString &folderPath)
{
    const QString trimmed = folderPath.trimmed();
    if (trimmed.isEmpty() || !isValidRelativeFolderPath(trimmed))
    {
        return {};
    }

    return QDir::cleanPath(trimmed);
}

QString combineRelativeFolderPath(const QString &parentFolderPath, const QString &folderName)
{
    const QString normalizedParent = normalizeRelativeFolderPath(parentFolderPath);
    const QString trimmedName = folderName.trimmed();
    if (trimmedName.isEmpty() || trimmedName.contains(QLatin1Char('/')) || trimmedName.contains(QLatin1Char('\\')))
    {
        return {};
    }

    if (normalizedParent.isEmpty())
    {
        return trimmedName;
    }

    return normalizedParent + QLatin1Char('/') + trimmedName;
}

QString makeUniqueFolderName(const QDir &parentDir, const QString &baseName)
{
    QString candidate = baseName;
    int suffix = 2;
    while (parentDir.exists(candidate))
    {
        candidate = QStringLiteral("%1 %2").arg(baseName).arg(suffix++);
    }
    return candidate;
}

QString documentFilePathForId(const QString &notesRoot, const QString &documentId)
{
    const QString directPath = QDir(notesRoot).absoluteFilePath(documentId + QStringLiteral(".json"));
    if (QFileInfo::exists(directPath))
    {
        return directPath;
    }

    QDirIterator it(notesRoot, QStringList() << (documentId + QStringLiteral(".json")), QDir::Files, QDirIterator::Subdirectories);
    if (it.hasNext())
    {
        return it.next();
    }

    return directPath;
}

QString documentIdForTitle(zametki::core::DocumentManager *manager, const QString &titleOrId)
{
    if (!manager)
    {
        return {};
    }

    const QString trimmed = titleOrId.trimmed();
    if (trimmed.isEmpty())
    {
        return {};
    }

    const auto docs = manager->listAllDocuments();
    for (const auto &doc : docs)
    {
        if (doc.id == trimmed || doc.title == trimmed)
        {
            return doc.id;
        }
    }

    return {};
}

QVariantList toFolderEntries(const QString &notesRoot, zametki::core::DocumentManager *manager, const QString &folderPath)
{
    QVariantList entries;
    const QString normalizedFolderPath = normalizeRelativeFolderPath(folderPath);
    if (!folderPath.isEmpty() && normalizedFolderPath.isEmpty())
    {
        return entries;
    }

    const QDir baseDir(notesRoot);
    const QString absoluteFolderPath = normalizedFolderPath.isEmpty() ? baseDir.absolutePath() : baseDir.absoluteFilePath(normalizedFolderPath);
    const QDir folderDir(absoluteFolderPath);
    if (!folderDir.exists())
    {
        return entries;
    }

    QHash<QString, QString> titlesById;
    if (manager)
    {
        const auto docs = manager->listAllDocuments();
        for (const auto &doc : docs)
        {
            titlesById.insert(doc.id, doc.title.isEmpty() ? doc.id : doc.title);
        }
    }

    const QStringList childFolders = folderDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    for (const QString &childFolder : childFolders)
    {
        QVariantMap entry;
        entry.insert(QStringLiteral("name"), childFolder);
        entry.insert(QStringLiteral("path"), normalizedFolderPath.isEmpty() ? childFolder : normalizedFolderPath + QLatin1Char('/') + childFolder);
        entry.insert(QStringLiteral("isFolder"), true);
        entries.push_back(entry);
    }

    const QStringList jsonFiles = folderDir.entryList(QStringList() << QStringLiteral("*.json"), QDir::Files, QDir::Name);
    for (const QString &fileName : jsonFiles)
    {
        const QString documentId = QFileInfo(fileName).baseName();
        QVariantMap entry;
        entry.insert(QStringLiteral("name"), titlesById.value(documentId, documentId));
        entry.insert(QStringLiteral("path"), documentId);
        entry.insert(QStringLiteral("isFolder"), false);
        entries.push_back(entry);
    }

    return entries;
}

void computeTextDiff(const QString &before, const QString &after, int &start, int &removed, QString &inserted)
{
    start = 0;
    removed = 0;
    inserted.clear();

    const int beforeLen = before.size();
    const int afterLen = after.size();

    while (start < beforeLen && start < afterLen && before.at(start) == after.at(start))
    {
        ++start;
    }

    int beforeEnd = beforeLen - 1;
    int afterEnd = afterLen - 1;
    while (beforeEnd >= start && afterEnd >= start && before.at(beforeEnd) == after.at(afterEnd))
    {
        --beforeEnd;
        --afterEnd;
    }

    removed = beforeEnd - start + 1;
    if (removed < 0)
    {
        removed = 0;
    }

    if (afterEnd >= start)
    {
        inserted = after.mid(start, afterEnd - start + 1);
    }
}

QVariantMap toVariantMap(const zametki::core::Document &doc)
{
    QVariantMap map;
    map.insert(QStringLiteral("id"), doc.id);
    map.insert(QStringLiteral("title"), doc.title);
    map.insert(QStringLiteral("tags"), doc.tags);
    map.insert(QStringLiteral("blocksCount"), doc.blocks.size());
    return map;
}

QVariantList toVariantList(const QVector<zametki::core::Document> &docs)
{
    QVariantList list;
    list.reserve(docs.size());
    for (const auto &doc : docs)
    {
        list.append(toVariantMap(doc));
    }
    return list;
}
}

DocumentBridge::DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent)
    : QObject(parent)
    , m_manager(manager)
{
    QSettings settings;
    m_blockEditorEnabled = settings.value(QStringLiteral("features/blockEditorEnabled"), true).toBool();
    loadSaveDirectory();
    rebuildNoteTitles();

    if (m_manager)
    {
        rebuildBlocks(m_manager->getSnapshot());
        emit blocksChanged();
        connect(m_manager, &zametki::core::DocumentManager::snapshotChanged, this, [this]()
        {
            if (m_ignoreSnapshotCount > 0)
            {
                --m_ignoreSnapshotCount;
                return;
            }
            rebuildBlocks(m_manager->getSnapshot());
            emit blocksChanged();
            emit snapshotChanged();
        });
    }
}

QVariantList DocumentBridge::getAllDocuments() const
{
    if (!m_manager)
    {
        return {};
    }
    return toVariantList(m_manager->listAllDocuments());
}

QVariantList DocumentBridge::searchDocuments(const QString &query) const
{
    if (!m_manager)
    {
        return {};
    }
    return toVariantList(m_manager->searchDocuments(query));
}

QVariantList DocumentBridge::getBacklinks(const QString &noteId) const
{
    if (!m_manager)
    {
        return {};
    }
    return toVariantList(m_manager->getBacklinks(noteId));
}

bool DocumentBridge::openDocument(const QString &id)
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }

    const bool ok = m_manager->load(id);
    if (!ok)
    {
        m_lastError = m_manager->lastError();
    }
    return ok;
}

bool DocumentBridge::openDocumentByTitle(const QString &title)
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }

    const QString trimmed = title.trimmed();
    const auto docs = m_manager->listAllDocuments();
    for (const auto &doc : docs)
    {
        if (doc.title == trimmed || doc.id == trimmed)
        {
            return openDocument(doc.id);
        }
    }

    m_lastError = QStringLiteral("document_not_found");
    return false;
}

bool DocumentBridge::saveDocument()
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }

    const bool ok = m_manager->save();
    if (!ok)
    {
        m_lastError = m_manager->lastError();
    }
    return ok;
}

bool DocumentBridge::createEmptyDocument()
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }
    if (!databaseConfigured())
    {
        m_lastError = QStringLiteral("database_not_configured");
        return false;
    }

    if (!m_manager->createEmptyDocument())
    {
        m_lastError = m_manager->lastError();
        return false;
    }

    if (!m_manager->save())
    {
        m_lastError = m_manager->lastError();
        return false;
    }

    rebuildNoteTitles();
    refreshFolderTitles();
    emit directoryContentChanged();
    return true;
}

bool DocumentBridge::renameCurrentDocument(const QString &title)
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return false;
    }

    const QString normalizedTitle = title.trimmed().isEmpty() ? QStringLiteral("Новая заметка") : title.trimmed();
    if (!m_manager->renameDocument(normalizedTitle))
    {
        m_lastError = m_manager->lastError();
        return false;
    }

    if (!m_manager->save())
    {
        m_lastError = m_manager->lastError();
        return false;
    }

    rebuildNoteTitles();
    emit snapshotChanged();
    return true;
}

QString DocumentBridge::exportCurrentToMarkdown()
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return QString();
    }

    const zametki::core::Document snapshot = m_manager->getSnapshot();
    zametki::exporter::MarkdownExporter exporter;
    const QString path = exporter.exportToFile(snapshot);
    if (path.isEmpty())
    {
        m_lastError = exporter.lastError();
    }
    return path;
}

QString DocumentBridge::lastError() const
{
    return m_lastError;
}

bool DocumentBridge::createDatabase(const QString &databaseName, const QString &parentDirectoryPath)
{
    const QString trimmedName = databaseName.trimmed();
    if (!isValidDatabaseName(trimmedName))
    {
        m_lastError = QStringLiteral("invalid_database_name");
        return false;
    }

    const QString normalizedParent = normalizeLocalPath(parentDirectoryPath);
    if (normalizedParent.isEmpty())
    {
        m_lastError = QStringLiteral("database_parent_missing");
        return false;
    }

    QDir parentDir(normalizedParent);
    if (!parentDir.exists())
    {
        m_lastError = QStringLiteral("database_parent_missing");
        return false;
    }

    const QString databasePath = parentDir.absoluteFilePath(trimmedName);
    QFileInfo targetInfo(databasePath);
    if (targetInfo.exists() && !targetInfo.isDir())
    {
        m_lastError = QStringLiteral("database_path_not_directory");
        return false;
    }

    if (!targetInfo.exists())
    {
        if (!parentDir.mkpath(trimmedName))
        {
            m_lastError = QStringLiteral("database_create_failed");
            return false;
        }
    }

    setSaveDirectory(QFileInfo(databasePath).absoluteFilePath());
    m_lastError.clear();
    return true;
}

void DocumentBridge::refreshNoteTitles()
{
    rebuildNoteTitles();
}

void DocumentBridge::refreshFolderTitles()
{
    if (m_saveDirectory.isEmpty())
    {
        if (!m_folderTitles.isEmpty())
        {
            m_folderTitles.clear();
            emit folderTitlesChanged();
        }
        return;
    }

    QDir rootDir(m_saveDirectory);
    const QStringList folders = rootDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    if (folders != m_folderTitles)
    {
        m_folderTitles = folders;
        emit folderTitlesChanged();
    }
}

QStringList DocumentBridge::noteTitlesForFolder(const QString &folderTitle) const
{
    const QVariantList entries = entriesForFolder(folderTitle);
    QStringList titles;
    for (const auto &entry : entries)
    {
        const QVariantMap map = entry.toMap();
        if (!map.value(QStringLiteral("isFolder")).toBool())
        {
            titles.push_back(map.value(QStringLiteral("name")).toString());
        }
    }
    return titles;
}

QVariantList DocumentBridge::entriesForFolder(const QString &folderPath) const
{
    if (m_saveDirectory.isEmpty())
    {
        return {};
    }

    return toFolderEntries(m_saveDirectory, m_manager, folderPath);
}

bool DocumentBridge::blockEditorEnabled() const
{
    return m_blockEditorEnabled;
}

void DocumentBridge::setBlockEditorEnabled(bool enabled)
{
    if (m_blockEditorEnabled == enabled)
    {
        return;
    }

    m_blockEditorEnabled = enabled;
    QSettings settings;
    settings.setValue(QStringLiteral("features/blockEditorEnabled"), m_blockEditorEnabled);
    emit blockEditorEnabledChanged();
}

QString DocumentBridge::saveDirectory() const
{
    return m_saveDirectory;
}

void DocumentBridge::setSaveDirectory(const QString &path)
{
    const QString normalized = normalizeLocalPath(path);
    if (normalized == m_saveDirectory)
    {
        return;
    }

    m_saveDirectory = normalized;
    storeSaveDirectory(normalized);

    if (m_manager && !m_saveDirectory.isEmpty())
    {
        if (!m_manager->setStorageRoot(m_saveDirectory))
        {
            m_lastError = m_manager->lastError();
        }
    }

    emit saveDirectoryChanged();
    emit databaseConfiguredChanged();
    rebuildNoteTitles();
    refreshFolderTitles();
    emit directoryContentChanged();
}

bool DocumentBridge::databaseConfigured() const
{
    return !m_saveDirectory.isEmpty();
}

QString DocumentBridge::currentDocumentTitle() const
{
    if (!m_manager)
    {
        return {};
    }

    return m_manager->getSnapshot().title;
}

QStringList DocumentBridge::noteTitles() const
{
    return m_noteTitles;
}

QStringList DocumentBridge::folderTitles() const
{
    return m_folderTitles;
}

bool DocumentBridge::createFolder(const QString &folderName, const QString &parentFolderPath)
{
    if (m_saveDirectory.isEmpty())
    {
        m_lastError = QStringLiteral("database_not_configured");
        return false;
    }

    QString relativeFolderPath = combineRelativeFolderPath(parentFolderPath, folderName);
    if (relativeFolderPath.isEmpty())
    {
        relativeFolderPath = normalizeRelativeFolderPath(folderName);
    }

    if (relativeFolderPath.isEmpty())
    {
        m_lastError = QStringLiteral("invalid_folder_path");
        return false;
    }

    const QDir rootDir(m_saveDirectory);
    const QStringList pathParts = relativeFolderPath.split(QLatin1Char('/'), Qt::SkipEmptyParts);
    QDir currentDir(rootDir.absolutePath());
    for (const QString &pathPart : pathParts)
    {
        const QString uniqueFolderName = makeUniqueFolderName(currentDir, pathPart);
        if (!currentDir.mkpath(uniqueFolderName))
        {
            m_lastError = QStringLiteral("folder_create_failed");
            return false;
        }
        currentDir.cd(uniqueFolderName);
    }

    refreshFolderTitles();
    emit directoryContentChanged();
    m_lastError.clear();
    return true;
}

bool DocumentBridge::moveItem(const QString &itemKey, const QString &targetFolderPath)
{
    if (m_saveDirectory.isEmpty())
    {
        m_lastError = QStringLiteral("database_not_configured");
        return false;
    }

    const QString normalizedTargetFolder = normalizeRelativeFolderPath(targetFolderPath);
    if (!targetFolderPath.isEmpty() && normalizedTargetFolder.isEmpty())
    {
        m_lastError = QStringLiteral("invalid_folder_path");
        return false;
    }

    const QDir rootDir(m_saveDirectory);
    const QString absoluteTargetFolder = normalizedTargetFolder.isEmpty() ? rootDir.absolutePath() : rootDir.absoluteFilePath(normalizedTargetFolder);
    if (!QDir(absoluteTargetFolder).exists() && !rootDir.mkpath(rootDir.relativeFilePath(absoluteTargetFolder)))
    {
        m_lastError = QStringLiteral("folder_create_failed");
        return false;
    }

    const QString trimmedKey = itemKey.trimmed();
    if (trimmedKey.startsWith(QStringLiteral("folder:")))
    {
        const QString sourceFolder = normalizeRelativeFolderPath(trimmedKey.mid(QStringLiteral("folder:").size()));
        if (sourceFolder.isEmpty())
        {
            m_lastError = QStringLiteral("invalid_folder_path");
            return false;
        }

        const QString absoluteSourcePath = rootDir.absoluteFilePath(sourceFolder);
        if (!QDir(absoluteSourcePath).exists())
        {
            m_lastError = QStringLiteral("folder_not_found");
            return false;
        }

        const QString sourceName = QFileInfo(absoluteSourcePath).fileName();
        QString destinationFolderName = makeUniqueFolderName(QDir(absoluteTargetFolder), sourceName);
        QString absoluteDestinationPath = QDir(absoluteTargetFolder).absoluteFilePath(destinationFolderName);
        if (absoluteDestinationPath == absoluteSourcePath)
        {
            return true;
        }

        if (absoluteDestinationPath.startsWith(absoluteSourcePath + QLatin1Char('/')))
        {
            m_lastError = QStringLiteral("folder_move_into_descendant");
            return false;
        }

        if (!QDir().rename(absoluteSourcePath, absoluteDestinationPath))
        {
            m_lastError = QStringLiteral("folder_move_failed");
            return false;
        }

        refreshFolderTitles();
        emit directoryContentChanged();
        m_lastError.clear();
        return true;
    }

    QString documentId = trimmedKey;
    if (trimmedKey.startsWith(QStringLiteral("note:")))
    {
        documentId = documentIdForTitle(m_manager, trimmedKey.mid(QStringLiteral("note:").size()));
    }
    else if (trimmedKey.startsWith(QStringLiteral("folder-note:")))
    {
        documentId = trimmedKey.mid(QStringLiteral("folder-note:").size());
    }
    else
    {
        const QString resolvedId = documentIdForTitle(m_manager, trimmedKey);
        if (!resolvedId.isEmpty())
        {
            documentId = resolvedId;
        }
    }

    if (documentId.isEmpty())
    {
        m_lastError = QStringLiteral("note_not_found");
        return false;
    }

    const QString sourcePath = documentFilePathForId(m_saveDirectory, documentId);
    if (!QFileInfo::exists(sourcePath))
    {
        m_lastError = QStringLiteral("note_not_found");
        return false;
    }

    const QString destinationPath = QDir(absoluteTargetFolder).absoluteFilePath(documentId + QStringLiteral(".json"));
    if (sourcePath == destinationPath)
    {
        return true;
    }

    if (QFileInfo::exists(destinationPath) && destinationPath != sourcePath)
    {
        QFile::remove(destinationPath);
    }

    if (!QFile::rename(sourcePath, destinationPath))
    {
        m_lastError = QStringLiteral("note_move_failed");
        return false;
    }

    rebuildNoteTitles();
    refreshFolderTitles();
    emit directoryContentChanged();
    m_lastError.clear();
    return true;
}

QString DocumentBridge::normalizeLocalPath(const QString &pathOrUrl)
{
    if (pathOrUrl.isEmpty())
    {
        return {};
    }

    QUrl url(pathOrUrl);
    QString localPath;
    if (url.isValid() && url.scheme() == QStringLiteral("file"))
    {
        localPath = url.toLocalFile();
    }
    else
    {
        localPath = pathOrUrl;
    }

    if (localPath.isEmpty())
    {
        return {};
    }

    return QDir::cleanPath(localPath);
}

bool DocumentBridge::isValidDatabaseName(const QString &databaseName)
{
    if (databaseName.isEmpty())
    {
        return false;
    }

    static const QRegularExpression invalidCharactersPattern(QStringLiteral(R"([<>:"/\\|?*])"));
    return !databaseName.contains(invalidCharactersPattern);
}

void DocumentBridge::storeSaveDirectory(const QString &path)
{
    QSettings settings;
    settings.setValue(kDatabaseDirectorySettingsKey, path);
    settings.sync();
}

void DocumentBridge::loadSaveDirectory()
{
    QSettings settings;
    const QString savedPath = normalizeLocalPath(settings.value(kDatabaseDirectorySettingsKey).toString());
    if (!savedPath.isEmpty())
    {
        m_saveDirectory = savedPath;
        if (m_manager)
        {
            if (!m_manager->setStorageRoot(m_saveDirectory))
            {
                m_lastError = m_manager->lastError();
            }
        }
        refreshFolderTitles();
    }
}

void DocumentBridge::rebuildNoteTitles()
{
    if (!m_manager)
    {
        return;
    }

    const QVector<zametki::core::Document> docs = m_manager->listAllDocuments();
    QStringList titles;
    titles.reserve(docs.size());
    for (const auto &doc : docs)
    {
        titles.push_back(doc.title.isEmpty() ? doc.id : doc.title);
    }

    if (titles != m_noteTitles)
    {
        m_noteTitles = titles;
        emit noteTitlesChanged();
    }
}

QVariantList DocumentBridge::blocks() const
{
    return m_blocks;
}

void DocumentBridge::replaceBlockText(const QString &blockId, const QString &text)
{
    if (!m_manager || blockId.isEmpty())
    {
        return;
    }

    const QString previous = m_lastTextById.value(blockId);
    if (previous == text)
    {
        return;
    }

    int start = 0;
    int removed = 0;
    QString inserted;
    computeTextDiff(previous, text, start, removed, inserted);

    const int pendingSnapshots = (removed > 0 ? 1 : 0) + (!inserted.isEmpty() ? 1 : 0);
    if (pendingSnapshots > 0)
    {
        m_ignoreSnapshotCount += pendingSnapshots;
    }

    if (removed > 0)
    {
        m_manager->applyTextDelete(blockId, start, removed);
    }
    if (!inserted.isEmpty())
    {
        m_manager->applyTextInsert(blockId, start, inserted);
    }

    for (int i = 0; i < m_blocks.size(); ++i)
    {
        QVariantMap map = m_blocks.at(i).toMap();
        if (map.value(QStringLiteral("id")).toString() == blockId)
        {
            map.insert(QStringLiteral("text"), text);
            m_blocks[i] = map;
            break;
        }
    }

    m_lastTextById.insert(blockId, text);
    emit blocksChanged();
}

void DocumentBridge::updateTodoBlock(const QString &blockId, const QString &text, bool done)
{
    if (!m_manager || blockId.isEmpty())
    {
        return;
    }

    m_ignoreSnapshotCount += 1;

    zametki::core::TodoBlock data;
    data.text = text;
    data.done = done;
    m_manager->updateTodoBlock(blockId, data);

    for (int i = 0; i < m_blocks.size(); ++i)
    {
        QVariantMap map = m_blocks.at(i).toMap();
        if (map.value(QStringLiteral("id")).toString() == blockId)
        {
            map.insert(QStringLiteral("text"), text);
            map.insert(QStringLiteral("done"), done);
            m_blocks[i] = map;
            break;
        }
    }

    m_lastTextById.insert(blockId, text);
    emit blocksChanged();
}

QString DocumentBridge::insertBlockAfter(const QString &afterBlockId, const QString &type)
{
    if (!m_manager)
    {
        m_lastError = QStringLiteral("manager_missing");
        return {};
    }

    zametki::core::BlockType blockType = zametki::core::BlockType::Paragraph;
    const QString normalized = type.trimmed().toLower();
    if (normalized == QStringLiteral("heading"))
    {
        blockType = zametki::core::BlockType::Heading;
    }
    else if (normalized == QStringLiteral("todo"))
    {
        blockType = zametki::core::BlockType::Todo;
    }
    else if (normalized != QStringLiteral("paragraph"))
    {
        m_lastError = QStringLiteral("unknown_block_type");
        return {};
    }

    return m_manager->insertBlock(afterBlockId, blockType);
}

QString DocumentBridge::appendBlock(const QString &type)
{
    QString afterId;
    if (!m_blocks.isEmpty())
    {
        const QVariantMap last = m_blocks.last().toMap();
        afterId = last.value(QStringLiteral("id")).toString();
    }
    return insertBlockAfter(afterId, type);
}

void DocumentBridge::deleteBlock(const QString &blockId)
{
    if (!m_manager || blockId.isEmpty())
    {
        return;
    }

    m_manager->deleteBlock(blockId);
}

void DocumentBridge::convertBlockType(const QString &blockId, const QString &type, int headingLevel, bool todoDone)
{
    if (!m_manager || blockId.isEmpty())
    {
        return;
    }

    zametki::core::BlockType blockType = zametki::core::BlockType::Paragraph;
    const QString normalized = type.trimmed().toLower();
    if (normalized == QStringLiteral("heading"))
    {
        blockType = zametki::core::BlockType::Heading;
    }
    else if (normalized == QStringLiteral("todo"))
    {
        blockType = zametki::core::BlockType::Todo;
    }
    else if (normalized != QStringLiteral("paragraph"))
    {
        m_lastError = QStringLiteral("unknown_block_type");
        return;
    }

    m_ignoreSnapshotCount += 1;
    m_manager->convertBlockType(blockId, blockType, headingLevel, todoDone);
}

void DocumentBridge::rebuildBlocks(const zametki::core::Document &snapshot)
{
    QVariantList blocks;
    blocks.reserve(snapshot.blocks.size());
    m_lastTextById.clear();

    for (const auto &block : snapshot.blocks)
    {
        QVariantMap map;
        map.insert(QStringLiteral("id"), block.id);

        const QString text = zametki::core::BlockTextAccessor::getText(block);

        if (block.type == zametki::core::BlockType::Paragraph)
        {
            map.insert(QStringLiteral("type"), QStringLiteral("paragraph"));
            map.insert(QStringLiteral("text"), text);
            m_lastTextById.insert(block.id, text);
        }
        else if (block.type == zametki::core::BlockType::Heading)
        {
            const zametki::core::HeadingBlock data = block.data.value<zametki::core::HeadingBlock>();
            map.insert(QStringLiteral("type"), QStringLiteral("heading"));
            map.insert(QStringLiteral("text"), text);
            map.insert(QStringLiteral("level"), data.level);
            m_lastTextById.insert(block.id, text);
        }
        else if (block.type == zametki::core::BlockType::Todo)
        {
            const zametki::core::TodoBlock data = block.data.value<zametki::core::TodoBlock>();
            map.insert(QStringLiteral("type"), QStringLiteral("todo"));
            map.insert(QStringLiteral("text"), text);
            map.insert(QStringLiteral("done"), data.done);
            m_lastTextById.insert(block.id, text);
        }
        else
        {
            continue;
        }

        blocks.append(map);
    }

    m_blocks = blocks;
}

} // namespace zametki::bridge
