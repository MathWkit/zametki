#ifndef ZAMETKI_DOCUMENT_BRIDGE_H
#define ZAMETKI_DOCUMENT_BRIDGE_H

#include <QObject>
#include <QString>
#include <QVariantList>

namespace zametki::core
{
class DocumentManager;
}

namespace zametki::bridge
{
class DocumentBridge : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool blockEditorEnabled READ blockEditorEnabled WRITE setBlockEditorEnabled NOTIFY blockEditorEnabledChanged)
public:
    explicit DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAllDocuments() const;
    Q_INVOKABLE QVariantList searchDocuments(const QString &query) const;
    Q_INVOKABLE QVariantList getBacklinks(const QString &noteId) const;
    Q_INVOKABLE bool openDocument(const QString &id);
    Q_INVOKABLE bool saveDocument();
    Q_INVOKABLE QString exportCurrentToMarkdown();
    Q_INVOKABLE QString lastError() const;

    bool blockEditorEnabled() const;
    void setBlockEditorEnabled(bool enabled);

signals:
    void blockEditorEnabledChanged();

private:
    zametki::core::DocumentManager *m_manager;
    QString m_lastError;
    bool m_blockEditorEnabled = true;
};
}

#endif // ZAMETKI_DOCUMENT_BRIDGE_H
