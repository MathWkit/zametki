#ifndef ZAMETKI_AUTOSAVE_MANAGER_H
#define ZAMETKI_AUTOSAVE_MANAGER_H

#include <QObject>
#include <QTimer>

namespace zametki::core
{
class DocumentManager;

class AutosaveManager : public QObject
{
    Q_OBJECT
public:
    explicit AutosaveManager(QObject *parent = nullptr);

    void setDebounceInterval(int milliseconds);
    void markDirty();
    void scheduleSave();
    void flushNow();
    void setDocumentManager(DocumentManager *manager);

private:
    QTimer m_timer;
    DocumentManager *m_manager = nullptr;
};
}

#endif // ZAMETKI_AUTOSAVE_MANAGER_H

