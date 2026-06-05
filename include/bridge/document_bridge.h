#ifndef ZAMETKI_DOCUMENT_BRIDGE_H
#define ZAMETKI_DOCUMENT_BRIDGE_H

#include <QFileSystemWatcher>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QTimer>
#include <QVariantList>
#include "core/document.h"

namespace zametki::core
{
class DocumentManager;
}

namespace zametki::bridge
{
class DocumentBridge : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString saveDirectory READ saveDirectory NOTIFY saveDirectoryChanged)
    Q_PROPERTY(bool databaseConfigured READ databaseConfigured NOTIFY databaseConfiguredChanged)
    Q_PROPERTY(QStringList noteTitles READ noteTitles NOTIFY noteTitlesChanged)
    Q_PROPERTY(QStringList folderTitles READ folderTitles NOTIFY folderTitlesChanged)
    Q_PROPERTY(QVariantList blocks READ blocks NOTIFY blocksChanged)

public:
    explicit DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent = nullptr);

    // Документы
    Q_INVOKABLE QVariantList getAllDocuments() const;
    Q_INVOKABLE QVariantList searchDocuments(const QString &query) const;
    Q_INVOKABLE QVariantList getBacklinks(const QString &noteId) const;
    Q_INVOKABLE bool openDocument(const QString &id);
    Q_INVOKABLE bool saveDocument();

    // База данных / папки
    Q_INVOKABLE bool createDatabase(const QString &databaseName, const QString &parentDirectoryPath);
    Q_INVOKABLE bool createDesktopMarkdown();
    Q_INVOKABLE QVariantList entriesForFolder(const QString &folderPath) const;
    Q_INVOKABLE QString lastError() const;

    QString saveDirectory() const;
    void setSaveDirectory(const QString &path);
    bool databaseConfigured() const;
    QStringList noteTitles() const;
    QStringList folderTitles() const;
    QVariantList blocks() const;

signals:
    void saveDirectoryChanged();
    void databaseConfiguredChanged();
    void noteTitlesChanged();
    void folderTitlesChanged();
    void directoryContentChanged();
    void blocksChanged();
    void snapshotChanged();

private:
    void refreshNoteTitles();
    void refreshFolderTitles();
    void updateDirectoryWatcher();
    void loadSaveDirectory();
    void storeSaveDirectory(const QString &path);
    void rebuildNoteTitles();
    void rebuildBlocks(const class zametki::core::Document &snapshot);

    static QString normalizeLocalPath(const QString &pathOrUrl);
    static bool isValidDatabaseName(const QString &databaseName);

    zametki::core::DocumentManager *m_manager;
    QString m_saveDirectory;
    QString m_lastError;
    QStringList m_noteTitles;
    QStringList m_folderTitles;
    QVariantList m_blocks;
    QHash<QString, QString> m_lastTextById;
    int m_ignoreSnapshotCount = 0;
    bool m_blockEditorEnabled = true;
    QFileSystemWatcher m_directoryWatcher;
    QTimer m_refreshDebounceTimer;
};
} // namespace zametki::bridge

#endif // ZAMETKI_DOCUMENT_BRIDGE_H