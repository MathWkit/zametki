#include <QApplication>
#include <QCoreApplication>
#include <QDir>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QStandardPaths>
#include <qqml.h>

#include "core/document_manager.h"
#include "core/autosave_manager.h"
#include "bridge/document_bridge.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle(QStringLiteral("Basic"));
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName("zametki");
    QCoreApplication::setApplicationName("zametki");

    QQmlApplicationEngine engine;

    zametki::core::DocumentManager documentManager;
    zametki::core::AutosaveManager autosaveManager(&documentManager);
    autosaveManager.setDebounceInterval(300);
    zametki::bridge::DocumentBridge documentBridge(&documentManager);

    qmlRegisterSingletonInstance("zametki", 1, 0, "AppState", &documentBridge);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("zametki", "Main");

    return app.exec();
}