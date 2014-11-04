#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include "systemaccessor.h"
#include <QtQml>
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<SystemAccessor>("com.sysgetter", 1, 0, "SystemAccessor");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
