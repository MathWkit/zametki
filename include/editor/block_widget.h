#ifndef ZAMETKI_BLOCK_WIDGET_H
#define ZAMETKI_BLOCK_WIDGET_H

#include <QWidget>
#include <QString>

namespace zametki::editor
{
class BlockWidget : public QWidget
{
    Q_OBJECT
public:
    explicit BlockWidget(QWidget *parent = nullptr);

    QString blockId() const;
    void setBlockId(const QString &blockId);

signals:
    void requestSplit();
    void requestMerge();
    void requestCreateBelow();

private:
    QString m_blockId;
};
}

#endif // ZAMETKI_BLOCK_WIDGET_H

