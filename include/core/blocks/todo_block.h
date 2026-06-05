#ifndef ZAMETKI_TODO_BLOCK_H
#define ZAMETKI_TODO_BLOCK_H

#include <QDate>
#include <QString>

namespace zametki::core
{
struct TodoBlock
{
    QString text;
    bool done = false;
    QString priority;
    QDate deadline;
    QString color;
};
}

#endif // ZAMETKI_TODO_BLOCK_H

