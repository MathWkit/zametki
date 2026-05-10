#include <QCoreApplication>
#include <QApplication>
#include <QObject>
#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <qqml.h>
#include <QStandardPaths>
#include <QDir>
#include <QVBoxLayout>
#include <QWidget>

#include "core/document_manager.h"
#include "core/autosave_manager.h"
#include "bridge/document_bridge.h"
#include "editor/editor_canvas_widget.h"
#include "editor/heading_widget.h"
#include "editor/paragraph_widget.h"
#include "editor/todo_widget.h"

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

    qmlRegisterSingletonInstance("zametki", 1, 0, "AppState", &documentBridge);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("zametki", "Main");

    QWidget editorWindow;
    editorWindow.setWindowTitle(QStringLiteral("Editor Preview"));
    editorWindow.resize(480, 640);
    auto *editorLayout = new QVBoxLayout(&editorWindow);

    auto *canvas = new zametki::editor::EditorCanvasWidget(&editorWindow);
    editorLayout->addWidget(canvas, 1);

    if (auto *heading = qobject_cast<zametki::editor::HeadingWidget *>(canvas->addHeadingBlock()))
    {
        heading->setText(QStringLiteral("Заголовок"));
        heading->setLevel(1);
    }
    if (auto *paragraph = qobject_cast<zametki::editor::ParagraphWidget *>(canvas->addParagraphBlock()))
    {
        paragraph->setText(QStringLiteral("Это тестовый параграф для редактора."));
    }
    if (auto *todo = qobject_cast<zametki::editor::TodoWidget *>(canvas->addTodoBlock()))
    {
        todo->setText(QStringLiteral("Сделать черновик интерфейса"));
        todo->setDone(false);
    }

    editorWindow.show();

    return app.exec();
}
