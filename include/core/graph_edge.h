#ifndef ZAMETKI_GRAPH_EDGE_H
#define ZAMETKI_GRAPH_EDGE_H

#include <QString>

namespace zametki::core
{
struct GraphEdge
{
    QString fromId;
    QString toId;
};
}

#endif // ZAMETKI_GRAPH_EDGE_H

