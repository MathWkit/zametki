#ifndef ZAMETKI_CRDT_SNAPSHOT_CONVERTER_H
#define ZAMETKI_CRDT_SNAPSHOT_CONVERTER_H

#include <QHash>
#include <QString>

#include "core/document.h"
#include "crdt/crdt_document.h"

namespace zametki::storage::json
{
class DocumentFileRepository;
class DocumentJsonSerializer;
}

namespace zametki::core
{
class CRDTSnapshotConverter
{
public:
    explicit CRDTSnapshotConverter(quint32 siteId = 0);

    quint32 siteId() const;
    void setSiteId(quint32 siteId);

    crdt::CRDTDocument toCrdt(const Document &snapshot) const;
    Document toSnapshot(const crdt::CRDTDocument &document) const;

    bool loadFromRepository(const QString &id,
                            const storage::json::DocumentFileRepository &repository,
                            const storage::json::DocumentJsonSerializer &serializer,
                            crdt::CRDTDocument &outDocument);

    bool saveToRepository(const QString &id,
                          const crdt::CRDTDocument &document,
                          const storage::json::DocumentFileRepository &repository,
                          const storage::json::DocumentJsonSerializer &serializer);

    void storeSnapshot(const Document &snapshot);
    bool hasSnapshot(const QString &id) const;
    Document cachedSnapshot(const QString &id) const;
    void clearCache();

private:
    QString toStringId(const crdt::CRDTId &id) const;
    bool parseId(const QString &text, crdt::CRDTId &id) const;

    QHash<QString, Document> m_snapshotCache;
    quint32 m_siteId = 0;
};
}

#endif // ZAMETKI_CRDT_SNAPSHOT_CONVERTER_H

