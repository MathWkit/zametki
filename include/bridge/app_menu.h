#ifndef ZAMETKI_APP_MENU_H
#define ZAMETKI_APP_MENU_H

class QQmlApplicationEngine;

namespace zametki::sync
{
class SyncClient;
}

namespace zametki::bridge
{

void setupNativeMenuBar(QQmlApplicationEngine *engine, zametki::sync::SyncClient *syncClient);

} // namespace zametki::bridge

#endif // ZAMETKI_APP_MENU_H
