#pragma once

#include <QObject>
#include <QString>
#include <QStringList>

class FileCreator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString saveDirectory READ saveDirectory WRITE setSaveDirectory NOTIFY saveDirectoryChanged)
    Q_PROPERTY(QStringList noteTitles READ noteTitles NOTIFY noteTitlesChanged)

public:
    explicit FileCreator(QObject *parent = nullptr);

    Q_INVOKABLE bool createDesktopMarkdown();
    Q_INVOKABLE QString lastError() const;
    Q_INVOKABLE void refreshNoteTitles();

    QString saveDirectory() const;
    void setSaveDirectory(const QString &path);
    QStringList noteTitles() const;

signals:
    void saveDirectoryChanged();
    void noteTitlesChanged();

private:
    QString m_saveDirectory;
    QStringList m_noteTitles;
    QString m_lastError;
};
