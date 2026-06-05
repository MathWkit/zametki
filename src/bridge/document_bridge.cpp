#include "bridge/document_bridge.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QSettings>
#include <QUrl>

#include "core/document_manager.h"

namespace zametki::bridge
{

DocumentBridge::DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent)
    : QObject(parent)
    , m_manager(manager)
{
    m_refreshDebounceTimer.setInterval(120);
    m_refreshDebounceTimer.setSingleShot(true);

    connect(&m_refreshDebounceTimer, &QTimer::timeout, this, [this]() {
        refreshNoteTitles();
        refreshFolderTitles();
        updateDirectoryWatcher();
        emit directoryContentChanged();
    });

    connect(&m_directoryWatcher, &QFileSystemWatcher::directoryChanged, this, [this](const QString &) {
        if (!m_refreshDebounceTimer.isActive())
            m_refreshDebounceTimer.start();
    });

    loadSaveDirectory();
}

QVariantList DocumentBridge::getAllDocuments() const
{
    return {};
}

QVariantList DocumentBridge::searchDocuments(const QString &query) const
{
    Q_UNUSED(query)
    return {};
}

QVariantList DocumentBridge::getBacklinks(const QString &noteId) const
{
    Q_UNUSED(noteId)
    return {};
}

bool DocumentBridge::openDocument(const QString &id)
{
    Q_UNUSED(id)
    return false;
}

bool DocumentBridge::saveDocument()
{
    return false;
}

bool DocumentBridge::createDatabase(const QString &databaseName, const QString &parentDirectoryPath)
{
    const QString trimmedName = databaseName.trimmed();
    if (!isValidDatabaseName(trimmedName))
    {
        m_lastError = QStringLiteral("Некорректное название базы данных");
        return false;
    }

    const QString normalizedParent = normalizeLocalPath(parentDirectoryPath);
    if (normalizedParent.isEmpty())
    {
        m_lastError = QStringLiteral("Не выбрана папка для базы данных");
        return false;
    }

    QDir parentDir(normalizedParent);
    if (!parentDir.exists())
    {
        m_lastError = QStringLiteral("Выбранная папка не существует");
        return false;
    }

    const QString dbPath = parentDir.absoluteFilePath(trimmedName);
    QFileInfo targetInfo(dbPath);
    if (targetInfo.exists() && !targetInfo.isDir())
    {
        m_lastError = QStringLiteral("Файл с таким именем уже существует");
        return false;
    }

    if (!targetInfo.exists())
    {
        if (!parentDir.mkpath(trimmedName))
        {
            m_lastError = QStringLiteral("Не удалось создать папку базы данных");
            return false;
        }
    }

    const QString absolutePath = QFileInfo(dbPath).absoluteFilePath();
    setSaveDirectory(absolutePath);
    storeSaveDirectory(absolutePath);
    m_lastError.clear();
    return true;
}

bool DocumentBridge::createDesktopMarkdown()
{
    if (!databaseConfigured())
    {
        m_lastError = QStringLiteral("Папка базы данных не настроена");
        return false;
    }

    QDir dir(m_saveDirectory);
    if (!dir.exists() && !dir.mkpath(QStringLiteral(".")))
    {
        m_lastError = QStringLiteral("Не удалось создать папку базы данных");
        return false;
    }

    const QString baseTitle = QStringLiteral("Новая заметка");
    QString fileName = baseTitle + QStringLiteral(".md");
    int suffix = 0;
    while (QFileInfo::exists(dir.filePath(fileName)))
    {
        ++suffix;
        fileName = QStringLiteral("%1 (%2).md").arg(baseTitle).arg(suffix);
    }

    QFile file(dir.filePath(fileName));
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text))
    {
        m_lastError = file.errorString();
        return false;
    }
    file.close();
    m_lastError.clear();
    refreshNoteTitles();
    emit directoryContentChanged();
    return true;
}

QVariantList DocumentBridge::entriesForFolder(const QString &folderPath) const
{
    if (folderPath.isEmpty() || QDir::isAbsolutePath(folderPath))
        return {};

    const QString cleanedPath = QDir::cleanPath(folderPath);
    if (cleanedPath == QLatin1String(".") || cleanedPath == QLatin1String("..")
        || cleanedPath.startsWith(QLatin1String("../"))
        || cleanedPath.contains(QLatin1String("/../")))
        return {};

    const QDir baseDir(m_saveDirectory);
    const QDir folderDir(baseDir.absoluteFilePath(cleanedPath));
    if (!folderDir.exists())
        return {};

    QVariantList entries;

    const QStringList childFolders = folderDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    for (const QString &childFolder : childFolders)
    {
        QVariantMap entry;
        entry.insert(QStringLiteral("name"), childFolder);
        entry.insert(QStringLiteral("path"), cleanedPath + QLatin1Char('/') + childFolder);
        entry.insert(QStringLiteral("isFolder"), true);
        entries.push_back(entry);
    }

    const QStringList files = folderDir.entryList(QStringList() << QStringLiteral("*.md"), QDir::Files, QDir::Name);
    for (const QString &fileName : files)
    {
        QVariantMap entry;
        const QString noteName = QFileInfo(fileName).completeBaseName();
        entry.insert(QStringLiteral("name"), noteName);
        entry.insert(QStringLiteral("path"), cleanedPath + QLatin1Char('/') + noteName);
        entry.insert(QStringLiteral("isFolder"), false);
        entries.push_back(entry);
    }

    return entries;
}

QString DocumentBridge::lastError() const
{
    return m_lastError;
}

QString DocumentBridge::saveDirectory() const
{
    return m_saveDirectory;
}

bool DocumentBridge::databaseConfigured() const
{
    return !m_saveDirectory.isEmpty();
}

QStringList DocumentBridge::noteTitles() const
{
    return m_noteTitles;
}

QStringList DocumentBridge::folderTitles() const
{
    return m_folderTitles;
}

QVariantList DocumentBridge::blocks() const
{
    return m_blocks;
}

void DocumentBridge::setSaveDirectory(const QString &path)
{
    const QString normalized = normalizeLocalPath(path);
    if (normalized == m_saveDirectory)
        return;

    const bool wasConfigured = databaseConfigured();
    m_saveDirectory = normalized;

    emit saveDirectoryChanged();
    if (wasConfigured != databaseConfigured())
        emit databaseConfiguredChanged();

    refreshNoteTitles();
    refreshFolderTitles();
    updateDirectoryWatcher();
    emit directoryContentChanged();
}

void DocumentBridge::refreshNoteTitles()
{
    const QDir dir(m_saveDirectory);
    const QStringList files = dir.entryList(QStringList() << QStringLiteral("*.md"), QDir::Files, QDir::Name);
    QStringList titles;
    titles.reserve(files.size());
    for (const QString &fileName : files)
        titles << QFileInfo(fileName).completeBaseName();

    if (titles != m_noteTitles)
    {
        m_noteTitles = titles;
        emit noteTitlesChanged();
    }
}

void DocumentBridge::refreshFolderTitles()
{
    const QDir dir(m_saveDirectory);
    const QStringList folders = dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    if (folders != m_folderTitles)
    {
        m_folderTitles = folders;
        emit folderTitlesChanged();
    }
}

void DocumentBridge::updateDirectoryWatcher()
{
    const QStringList watched = m_directoryWatcher.directories();
    if (!watched.isEmpty())
        m_directoryWatcher.removePaths(watched);

    const QDir dir(m_saveDirectory);
    if (dir.exists())
    {
        QStringList paths;
        paths.push_back(dir.absolutePath());
        QDirIterator it(dir.absolutePath(), QDir::Dirs | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
        while (it.hasNext())
            paths.push_back(it.next());
        m_directoryWatcher.addPaths(paths);
    }
}

void DocumentBridge::loadSaveDirectory()
{
    QSettings settings;
    const QString savedPath = normalizeLocalPath(settings.value(QStringLiteral("storage/databaseDirectory")).toString());
    if (!savedPath.isEmpty() && QFileInfo(savedPath).isDir())
        setSaveDirectory(savedPath);
}

void DocumentBridge::storeSaveDirectory(const QString &path)
{
    QSettings settings;
    settings.setValue(QStringLiteral("storage/databaseDirectory"), path);
    settings.sync();
}

void DocumentBridge::rebuildNoteTitles()
{
    refreshNoteTitles();
}

QString DocumentBridge::normalizeLocalPath(const QString &pathOrUrl)
{
    if (pathOrUrl.isEmpty())
        return {};

    const QUrl url(pathOrUrl);
    QString localPath;
    if (url.isValid() && url.scheme() == QStringLiteral("file"))
        localPath = url.toLocalFile();
    else
        localPath = pathOrUrl;

    if (localPath.isEmpty())
        return {};

    return QDir::cleanPath(localPath);
}

bool DocumentBridge::isValidDatabaseName(const QString &databaseName)
{
    if (databaseName.isEmpty())
        return false;

    static const QRegularExpression invalidChars(QStringLiteral(R"([<>:"/\\|?*])"));
    return !databaseName.contains(invalidChars);
}

} // namespace zametki::bridge