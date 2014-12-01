TEMPLATE = app

QT += qml quick widgets

# Doesn't work with mingw
# QMAKE_LFLAGS += /MANIFESTUAC:\"level=\'requireAdministrator\' uiAccess=\'false\'\"

CONFIG(debug, debug|release) {
    DEBUG_OR_RELEASE = debug
}else {
    DEBUG_OR_RELEASE = release
}

QMAKE_POST_LINK = "$$PWD/post-link.bat $$PWD $$DEBUG_OR_RELEASE"

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    systemaccessor.h

QMAKE_CXXFLAGS += -std=c++11 -fpermissive

OTHER_FILES +=
