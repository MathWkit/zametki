#include <QCoreApplication>
#include <QGuiApplication>
#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <qqml.h>
#include <QStandardPaths>
#include <QDir>

#include "core/id_generator.h"
#include "core/document_manager.h"
#include "core/autosave_manager.h"
#include "storage/json/document_file_repository.h"
#include "storage/json/document_json_serializer.h"
#include "bridge/document_bridge.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle(QStringLiteral("Basic"));
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("zametki");
    QCoreApplication::setApplicationName("zametki");

    QQmlApplicationEngine engine;

    const QString notesPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/notes");
    QDir().mkpath(notesPath);

    zametki::storage::json::DocumentJsonSerializer serializer;
    zametki::storage::json::DocumentFileRepository repository(notesPath);
    zametki::core::UuidIdGenerator idGenerator;
    zametki::core::DocumentManager documentManager(&documentManager, &repository, &serializer, &idGenerator);
    zametki::core::AutosaveManager autosaveManager(&documentManager);
    autosaveManager.setDebounceInterval(300);
    zametki::bridge::DocumentBridge documentBridge(&documentManager);

    qmlRegisterSingletonInstance("zametki", 1, 0, "AppState", &documentBridge);
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
