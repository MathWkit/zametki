#include <QCoreApplication>
#include <QApplication>
#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <qqml.h>
#include <QStandardPaths>
#include <QDir>
#include <QObject>

#include "core/document_manager.h"
#include "core/autosave_manager.h"
#include "bridge/document_bridge.h"
#include "sync/sync_client.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle(QStringLiteral("Basic"));
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName("zametki");
    QCoreApplication::setApplicationName("zametki");

    QQmlApplicationEngine engine;

    const QString notesPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/notes");
    QDir().mkpath(notesPath);

    zametki::core::DocumentManager documentManager;
    zametki::core::AutosaveManager autosaveManager(&documentManager);
    autosaveManager.setDebounceInterval(300);
    zametki::bridge::DocumentBridge documentBridge(&documentManager);
    zametki::sync::SyncClient syncClient;
    syncClient.setNotesPath(documentBridge.saveDirectory().isEmpty() ? notesPath : documentBridge.saveDirectory());

    // Keep SyncClient's notes path in sync with DocumentBridge's save directory
    QObject::connect(
        &documentBridge,
        &zametki::bridge::DocumentBridge::saveDirectoryChanged,
        &syncClient,
        [&syncClient, &documentBridge, &notesPath]() {
            const QString dir = documentBridge.saveDirectory();
            syncClient.setNotesPath(dir.isEmpty() ? notesPath : dir);
        });

    // After a note is saved locally, upload it to the server
    QObject::connect(
        &documentManager,
        &zametki::core::DocumentManager::documentSaved,
        &syncClient,
        &zametki::sync::SyncClient::onDocumentSaved);

    // When new notes are downloaded from server, refresh the sidebar
    QObject::connect(
        &syncClient,
        &zametki::sync::SyncClient::notesDirectoryChanged,
        &documentBridge,
        [&documentBridge]() {
            documentBridge.refreshNoteTitles();
            documentBridge.refreshFolderTitles();
            emit documentBridge.directoryContentChanged();
        });

    qmlRegisterSingletonInstance("zametki", 1, 0, "AppState", &documentBridge);
    qmlRegisterSingletonInstance("zametki", 1, 0, "SyncState", &syncClient);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("zametki", "Main");

    return app.exec();
}
