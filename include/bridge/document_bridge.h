#ifndef ZAMETKI_DOCUMENT_BRIDGE_H
#define ZAMETKI_DOCUMENT_BRIDGE_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QHash>

namespace zametki::core
{
class DocumentManager;
struct Document;
}

namespace zametki::bridge
{
class DocumentBridge : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool blockEditorEnabled READ blockEditorEnabled WRITE setBlockEditorEnabled NOTIFY blockEditorEnabledChanged)
    Q_PROPERTY(QString saveDirectory READ saveDirectory WRITE setSaveDirectory NOTIFY saveDirectoryChanged)
    Q_PROPERTY(bool databaseConfigured READ databaseConfigured NOTIFY databaseConfiguredChanged)
    Q_PROPERTY(QString currentDocumentTitle READ currentDocumentTitle NOTIFY snapshotChanged)
    Q_PROPERTY(QStringList noteTitles READ noteTitles NOTIFY noteTitlesChanged)
    Q_PROPERTY(QStringList folderTitles READ folderTitles NOTIFY folderTitlesChanged)
    Q_PROPERTY(QVariantList blocks READ blocks NOTIFY blocksChanged)
public:
    explicit DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAllDocuments() const;
    Q_INVOKABLE QVariantList searchDocuments(const QString &query) const;
    Q_INVOKABLE QVariantList getBacklinks(const QString &noteId) const;
    Q_INVOKABLE bool openDocument(const QString &id);
    Q_INVOKABLE bool openDocumentByTitle(const QString &title);
    Q_INVOKABLE bool saveDocument();
    Q_INVOKABLE bool createEmptyDocument();
    Q_INVOKABLE bool renameCurrentDocument(const QString &title);
    Q_INVOKABLE QString exportCurrentToMarkdown();
    Q_INVOKABLE QString lastError() const;
    Q_INVOKABLE bool createDatabase(const QString &databaseName, const QString &parentDirectoryPath);
    Q_INVOKABLE void refreshNoteTitles();
    Q_INVOKABLE void refreshFolderTitles();
    Q_INVOKABLE QStringList noteTitlesForFolder(const QString &folderTitle) const;
    Q_INVOKABLE QVariantList entriesForFolder(const QString &folderPath) const;
    Q_INVOKABLE QVariantList blocks() const;
    Q_INVOKABLE bool createFolder(const QString &folderName, const QString &parentFolderPath = QString());
    Q_INVOKABLE bool moveItem(const QString &itemKey, const QString &targetFolderPath);
    Q_INVOKABLE void replaceBlockText(const QString &blockId, const QString &text);
    Q_INVOKABLE void updateTodoBlock(const QString &blockId, const QString &text, bool done);
    Q_INVOKABLE QString insertBlockAfter(const QString &afterBlockId, const QString &type);
    Q_INVOKABLE QString appendBlock(const QString &type);
    Q_INVOKABLE void deleteBlock(const QString &blockId);
    Q_INVOKABLE void convertBlockType(const QString &blockId, const QString &type, int headingLevel = 1, bool todoDone = false);

    bool blockEditorEnabled() const;
    void setBlockEditorEnabled(bool enabled);

    QString saveDirectory() const;
    void setSaveDirectory(const QString &path);
    bool databaseConfigured() const;
    QString currentDocumentTitle() const;
    QStringList noteTitles() const;
    QStringList folderTitles() const;

signals:
    void blockEditorEnabledChanged();
    void saveDirectoryChanged();
    void databaseConfiguredChanged();
    void noteTitlesChanged();
    void folderTitlesChanged();
    void directoryContentChanged();
    void blocksChanged();
    void snapshotChanged();

private:
    static QString normalizeLocalPath(const QString &pathOrUrl);
    static bool isValidDatabaseName(const QString &databaseName);
    void storeSaveDirectory(const QString &path);
    void loadSaveDirectory();
    void rebuildNoteTitles();
    void rebuildBlocks(const zametki::core::Document &snapshot);

    zametki::core::DocumentManager *m_manager;
    QString m_lastError;
    bool m_blockEditorEnabled = true;
    QString m_saveDirectory;
    QStringList m_noteTitles;
    QStringList m_folderTitles;
    QVariantList m_blocks;
    QHash<QString, QString> m_lastTextById;
    int m_ignoreSnapshotCount = 0;
};
}

#endif // ZAMETKI_DOCUMENT_BRIDGE_H
