#include "bridge/app_menu.h"

#include "sync/sync_client.h"

#include <QAction>
#include <QMenu>
#include <QMenuBar>
#include <QQmlApplicationEngine>
#include <QObject>

namespace zametki::bridge
{

static void flushEditor(QQmlApplicationEngine *engine)
{
    if (!engine || engine->rootObjects().isEmpty()) {
        return;
    }

    QMetaObject::invokeMethod(engine->rootObjects().first(), "flushAllDelegates", Qt::DirectConnection);
}

static void invokeRoot(QQmlApplicationEngine *engine, const char *method)
{
    if (!engine || engine->rootObjects().isEmpty()) {
        return;
    }

    QMetaObject::invokeMethod(engine->rootObjects().first(), method);
}

void setupNativeMenuBar(QQmlApplicationEngine *engine, zametki::sync::SyncClient *syncClient)
{
    auto *menuBar = new QMenuBar();

    auto *fileMenu = menuBar->addMenu(QStringLiteral("Файл"));
    QObject::connect(fileMenu->addAction(QStringLiteral("Новая заметка")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuNewNote");
    });
    fileMenu->addSeparator();
    QObject::connect(fileMenu->addAction(QStringLiteral("Синхронизация")), &QAction::triggered, engine, [engine, syncClient]() {
        flushEditor(engine);
        syncClient->syncNow();
    });
    QObject::connect(fileMenu->addAction(QStringLiteral("Выгрузить заметки на сервер")), &QAction::triggered, engine, [engine, syncClient]() {
        flushEditor(engine);
        syncClient->uploadAllNotesNow();
    });
    QObject::connect(fileMenu->addAction(QStringLiteral("Мягкая выгрузка с сервера")), &QAction::triggered, engine, [engine, syncClient]() {
        flushEditor(engine);
        syncClient->softPullAllNotesNow();
    });
    QObject::connect(fileMenu->addAction(QStringLiteral("Жёсткая выгрузка с сервера")), &QAction::triggered, engine, [engine, syncClient]() {
        flushEditor(engine);
        syncClient->hardPullAllNotesNow();
    });

    auto *editMenu = menuBar->addMenu(QStringLiteral("Правка"));
    QObject::connect(editMenu->addAction(QStringLiteral("Настройки")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuOpenSettings");
    });

    auto *viewMenu = menuBar->addMenu(QStringLiteral("Вид"));
    QObject::connect(viewMenu->addAction(QStringLiteral("Скрыть/показать боковую панель")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuToggleSidebar");
    });
    QObject::connect(viewMenu->addAction(QStringLiteral("Поиск")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuOpenSearch");
    });

    auto *helpMenu = menuBar->addMenu(QStringLiteral("Справка"));
    QObject::connect(helpMenu->addAction(QStringLiteral("Помощь")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuShowHelp");
    });
    QObject::connect(helpMenu->addAction(QStringLiteral("Горячие клавиши")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuShowHotkeys");
    });
}

} // namespace zametki::bridge
