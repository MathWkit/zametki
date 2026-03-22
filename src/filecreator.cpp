#include "filecreator.h"

#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QFileInfo>
#include <QVariantMap>

namespace
{
    const QString kDefaultSaveDirectory = "/Users/renat/Desktop";

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
    : QObject(parent), m_saveDirectory(kDefaultSaveDirectory)
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

    refreshNoteTitles();
    refreshFolderTitles();
    updateDirectoryWatcher();
}

bool FileCreator::createDesktopMarkdown()
{
    const QString filePath = m_saveDirectory + "/text.md";
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
    if (path == m_saveDirectory)
    {
        return;
    }
    m_saveDirectory = path;
    emit saveDirectoryChanged();
    refreshNoteTitles();
    refreshFolderTitles();
    updateDirectoryWatcher();
    emit directoryContentChanged();
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
