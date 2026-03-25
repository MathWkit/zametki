#include "filecreator.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QSettings>
#include <QUrl>
#include <QVariantMap>

namespace
{
    const QString kDatabaseDirectorySettingsKey = "storage/databaseDirectory";

    bool isValidRelativeFolderPath(const QString &folderPath)
    {
        if (folderPath.isEmpty() || QDir::isAbsolutePath(folderPath))
        {
            return false;
        }

        const QString cleanedPath = QDir::cleanPath(folderPath);
        if (cleanedPath == "." || cleanedPath == ".." || cleanedPath.startsWith("../") || cleanedPath.contains("/../"))
        {
            return false;
        }

        return true;
    }
}

FileCreator::FileCreator(QObject *parent)
    : QObject(parent)
{
    m_refreshDebounceTimer.setInterval(120);
    m_refreshDebounceTimer.setSingleShot(true);

    connect(
        &m_refreshDebounceTimer,
        &QTimer::timeout,
        this,
        [this]()
        {
            refreshNoteTitles();
            refreshFolderTitles();
            // Re-add watcher path if filesystem event invalidated it.
            updateDirectoryWatcher();
            emit directoryContentChanged();
        });

    connect(
        &m_directoryWatcher,
        &QFileSystemWatcher::directoryChanged,
        this,
        [this](const QString &)
        {
            if (!m_refreshDebounceTimer.isActive())
            {
                m_refreshDebounceTimer.start();
            }
        });

    loadDatabaseDirectoryFromSettings();
}

bool FileCreator::createDesktopMarkdown()
{
    if (!databaseConfigured())
    {
        m_lastError = QStringLiteral("Папка базы данных не настроена");
        return false;
    }

    QDir dir(m_saveDirectory);
    if (!dir.exists() && !dir.mkpath("."))
    {
        m_lastError = QStringLiteral("Не удалось создать папку базы данных");
        return false;
    }

    const QString filePath = dir.filePath("text.md");
    QFile file(filePath);
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

bool FileCreator::createDatabase(const QString &databaseName, const QString &parentDirectoryPath)
{
    const QString trimmedDatabaseName = databaseName.trimmed();
    if (!isValidDatabaseName(trimmedDatabaseName))
    {
        m_lastError = QStringLiteral("Некорректное название базы данных");
        return false;
    }

    const QString normalizedParentDirectory = normalizeLocalPath(parentDirectoryPath);
    if (normalizedParentDirectory.isEmpty())
    {
        m_lastError = QStringLiteral("Не выбрана папка для базы данных");
        return false;
    }

    QDir parentDir(normalizedParentDirectory);
    if (!parentDir.exists())
    {
        m_lastError = QStringLiteral("Выбранная папка не существует");
        return false;
    }

    const QString databaseDirectoryPath = parentDir.absoluteFilePath(trimmedDatabaseName);
    QFileInfo targetInfo(databaseDirectoryPath);
    if (targetInfo.exists() && !targetInfo.isDir())
    {
        m_lastError = QStringLiteral("Файл с таким именем уже существует");
        return false;
    }

    if (!targetInfo.exists())
    {
        if (!parentDir.mkpath(trimmedDatabaseName))
        {
            m_lastError = QStringLiteral("Не удалось создать папку базы данных");
            return false;
        }
    }

    const QString absoluteDatabasePath = QFileInfo(databaseDirectoryPath).absoluteFilePath();
    setSaveDirectory(absoluteDatabasePath);
    saveDatabaseDirectoryToSettings(absoluteDatabasePath);
    m_lastError.clear();
    return true;
}

QString FileCreator::lastError() const
{
    return m_lastError;
}

void FileCreator::refreshNoteTitles()
{
    const QDir dir(m_saveDirectory);
    const QStringList files = dir.entryList(QStringList() << "*.md", QDir::Files, QDir::Name);
    QStringList titles;
    titles.reserve(files.size());
    for (const QString &fileName : files)
    {
        titles << QFileInfo(fileName).completeBaseName();
    }
    if (titles != m_noteTitles)
    {
        m_noteTitles = titles;
        emit noteTitlesChanged();
    }
}

void FileCreator::refreshFolderTitles()
{
    const QDir dir(m_saveDirectory);
    const QStringList folders = dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    if (folders != m_folderTitles)
    {
        m_folderTitles = folders;
        emit folderTitlesChanged();
    }
}

QString FileCreator::saveDirectory() const
{
    return m_saveDirectory;
}

void FileCreator::setSaveDirectory(const QString &path)
{
    const QString normalizedPath = normalizeLocalPath(path);
    if (normalizedPath == m_saveDirectory)
    {
        return;
    }

    const bool wasConfigured = databaseConfigured();
    m_saveDirectory = normalizedPath;

    emit saveDirectoryChanged();
    if (wasConfigured != databaseConfigured())
    {
        emit databaseConfiguredChanged();
    }
    refreshNoteTitles();
    refreshFolderTitles();
    updateDirectoryWatcher();
    emit directoryContentChanged();
}

bool FileCreator::databaseConfigured() const
{
    return !m_saveDirectory.isEmpty();
}

QStringList FileCreator::noteTitles() const
{
    return m_noteTitles;
}

QStringList FileCreator::folderTitles() const
{
    return m_folderTitles;
}

QStringList FileCreator::noteTitlesForFolder(const QString &folderTitle) const
{
    if (folderTitle.isEmpty())
    {
        return {};
    }

    const QDir baseDir(m_saveDirectory);
    const QString folderPath = baseDir.absoluteFilePath(folderTitle);
    const QDir folderDir(folderPath);
    if (!folderDir.exists())
    {
        return {};
    }

    const QStringList files = folderDir.entryList(QStringList() << "*.md", QDir::Files, QDir::Name);
    QStringList titles;
    titles.reserve(files.size());
    for (const QString &fileName : files)
    {
        titles << QFileInfo(fileName).completeBaseName();
    }

    return titles;
}

QVariantList FileCreator::entriesForFolder(const QString &folderPath) const
{
    if (!isValidRelativeFolderPath(folderPath))
    {
        return {};
    }

    const QDir baseDir(m_saveDirectory);
    const QString cleanedFolderPath = QDir::cleanPath(folderPath);
    const QString absoluteFolderPath = baseDir.absoluteFilePath(cleanedFolderPath);
    const QDir folderDir(absoluteFolderPath);
    if (!folderDir.exists())
    {
        return {};
    }

    QVariantList entries;

    const QStringList childFolders = folderDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    for (const QString &childFolder : childFolders)
    {
        QVariantMap entry;
        entry.insert("name", childFolder);
        entry.insert("path", cleanedFolderPath + "/" + childFolder);
        entry.insert("isFolder", true);
        entries.push_back(entry);
    }

    const QStringList files = folderDir.entryList(QStringList() << "*.md", QDir::Files, QDir::Name);
    for (const QString &fileName : files)
    {
        QVariantMap entry;
        const QString noteName = QFileInfo(fileName).completeBaseName();
        entry.insert("name", noteName);
        entry.insert("path", cleanedFolderPath + "/" + noteName);
        entry.insert("isFolder", false);
        entries.push_back(entry);
    }

    return entries;
}

void FileCreator::updateDirectoryWatcher()
{
    const QStringList watchedDirectories = m_directoryWatcher.directories();
    if (!watchedDirectories.isEmpty())
    {
        m_directoryWatcher.removePaths(watchedDirectories);
    }

    const QDir dir(m_saveDirectory);
    if (dir.exists())
    {
        QStringList pathsToWatch;
        pathsToWatch.push_back(dir.absolutePath());

        QDirIterator it(dir.absolutePath(), QDir::Dirs | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
        while (it.hasNext())
        {
            pathsToWatch.push_back(it.next());
        }

        m_directoryWatcher.addPaths(pathsToWatch);
    }
}

QString FileCreator::normalizeLocalPath(const QString &pathOrUrl)
{
    if (pathOrUrl.isEmpty())
    {
        return {};
    }

    const QUrl url(pathOrUrl);
    QString localPath;
    if (url.isValid() && url.scheme() == "file")
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

bool FileCreator::isValidDatabaseName(const QString &databaseName)
{
    if (databaseName.isEmpty())
    {
        return false;
    }

    static const QRegularExpression invalidCharactersPattern(R"([<>:"/\\|?*])");
    return !databaseName.contains(invalidCharactersPattern);
}

void FileCreator::saveDatabaseDirectoryToSettings(const QString &absolutePath)
{
    QSettings settings;
    settings.setValue(kDatabaseDirectorySettingsKey, absolutePath);
    settings.sync();
}

void FileCreator::loadDatabaseDirectoryFromSettings()
{
    QSettings settings;
    const QString savedPath = normalizeLocalPath(settings.value(kDatabaseDirectorySettingsKey).toString());

    if (!savedPath.isEmpty() && QFileInfo(savedPath).isDir())
    {
        setSaveDirectory(savedPath);
        return;
    }

    setSaveDirectory(QString());
}
