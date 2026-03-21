#pragma once

#include <QObject>
#include <QFileSystemWatcher>
#include <QString>
#include <QStringList>

class FileCreator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString saveDirectory READ saveDirectory WRITE setSaveDirectory NOTIFY saveDirectoryChanged)
    Q_PROPERTY(QStringList noteTitles READ noteTitles NOTIFY noteTitlesChanged)
    Q_PROPERTY(QStringList folderTitles READ folderTitles NOTIFY folderTitlesChanged)

public:
    explicit FileCreator(QObject *parent = nullptr);

    Q_INVOKABLE bool createDesktopMarkdown();
    Q_INVOKABLE QString lastError() const;
    Q_INVOKABLE void refreshNoteTitles();
    Q_INVOKABLE void refreshFolderTitles();

    QString saveDirectory() const;
    void setSaveDirectory(const QString &path);
    QStringList noteTitles() const;
    QStringList folderTitles() const;

signals:
    void saveDirectoryChanged();
    void noteTitlesChanged();
    void folderTitlesChanged();

private:
    void updateDirectoryWatcher();

    QFileSystemWatcher m_directoryWatcher;
    QString m_saveDirectory;
    QStringList m_noteTitles;
    QStringList m_folderTitles;
    QString m_lastError;
};
