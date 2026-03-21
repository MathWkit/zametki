#include "filecreator.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>

namespace
{
    const QString kDefaultSaveDirectory = "/Users/renat/Desktop";
}

FileCreator::FileCreator(QObject *parent)
    : QObject(parent), m_saveDirectory(kDefaultSaveDirectory)
{
    refreshNoteTitles();
    refreshFolderTitles();
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
}

QStringList FileCreator::noteTitles() const
{
    return m_noteTitles;
}

QStringList FileCreator::folderTitles() const
{
    return m_folderTitles;
}
