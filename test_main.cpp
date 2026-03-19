#include <QtTest>
#include "mainwindow.h"

class MainWindowTest : public QObject
{
    Q_OBJECT

private slots:
    void testExample()
    {
        MainWindow w;
        QCOMPARE(w.windowTitle(), QString("Zametki"));
    }
};

QTEST_MAIN(MainWindowTest)
#include "test_main.moc"