#ifndef ZAMETKI_DOCUMENT_BRIDGE_H
#define ZAMETKI_DOCUMENT_BRIDGE_H

#include <QObject>
#include <QString>
#include <QStringList>
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
public:
    explicit DocumentBridge(zametki::core::DocumentManager *manager, QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAllDocuments() const;
    Q_INVOKABLE QVariantList searchDocuments(const QString &query) const;
    Q_INVOKABLE QVariantList getBacklinks(const QString &noteId) const;
    Q_INVOKABLE bool openDocument(const QString &id);
    Q_INVOKABLE bool saveDocument();

private:
    zametki::core::DocumentManager *m_manager;
};
}

#endif // ZAMETKI_DOCUMENT_BRIDGE_H

