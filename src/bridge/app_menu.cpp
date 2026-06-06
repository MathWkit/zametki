#include "bridge/app_menu.h"

#include <QAction>
#include <QMenu>
#include <QMenuBar>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QVariant>

namespace zametki::bridge
{

static void invokeRoot(QQmlApplicationEngine *engine, const char *method, const QVariant &arg = {})
{
    if (!engine || engine->rootObjects().isEmpty()) {
        return;
    }

    QObject *root = engine->rootObjects().first();
    if (arg.isValid()) {
        QMetaObject::invokeMethod(root, method, Q_ARG(QVariant, arg));
    } else {
        QMetaObject::invokeMethod(root, method);
    }
}

void setupNativeMenuBar(QQmlApplicationEngine *engine)
{
    auto *menuBar = new QMenuBar();

    auto *fileMenu = menuBar->addMenu(QStringLiteral("Файл"));
    QObject::connect(fileMenu->addAction(QStringLiteral("Новая заметка")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuNewNote");
    });
    fileMenu->addSeparator();
    QObject::connect(fileMenu->addAction(QStringLiteral("Синхронизация")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuSyncNow");
    });
    QObject::connect(fileMenu->addAction(QStringLiteral("Выгрузить заметки на сервер")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuSyncAction", QStringLiteral("upload-all"));
    });
    QObject::connect(fileMenu->addAction(QStringLiteral("Мягкая выгрузка с сервера")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuSyncAction", QStringLiteral("unload-soft-all"));
    });
    QObject::connect(fileMenu->addAction(QStringLiteral("Жёсткая выгрузка с сервера")), &QAction::triggered, engine, [engine]() {
        invokeRoot(engine, "menuSyncAction", QStringLiteral("unload-hard-all"));
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
