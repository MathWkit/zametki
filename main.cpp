#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqml.h>

#include "filecreator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    FileCreator fileCreator;
    qmlRegisterSingletonInstance("zametki", 1, 0, "AppState", &fileCreator);
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
