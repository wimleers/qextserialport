PROJECT                 = qextserialport
TEMPLATE                = lib
#VERSION                 = 1.2.0
DESTDIR                 = build
CONFIG                  += qt warn_on debug_and_release
CONFIG                  += dll
DEFINES                 += QEXTSERIALPORT_LIB
#CONFIG                 += staticlib

# event driven device enumeration on windows requires the gui module
!win32:QT               -= gui

OBJECTS_DIR             = tmp
MOC_DIR                 = tmp
DEPENDDIR               = .
INCLUDEDIR              = .
HEADERS                 = qextserialport.h \
                          qextserialenumerator.h \
                          qextserialport_global.h
SOURCES                 = qextserialport.cpp

unix:SOURCES           += posix_qextserialport.cpp
unix:!macx:SOURCES     += qextserialenumerator_unix.cpp
macx {
  SOURCES          += qextserialenumerator_osx.cpp
  LIBS             += -framework IOKit -framework CoreFoundation
}

win32 {
  SOURCES          += win_qextserialport.cpp qextserialenumerator_win.cpp
  DEFINES          += WINVER=0x0501 # needed for mingw to pull in appropriate dbt business...probably a better way to do this
  LIBS             += -lsetupapi
}

CONFIG(debug, debug|release) {
    TARGET = qextserialportd
} else {
    TARGET = qextserialport
}


# Installation
libs.files              = build/*.so* \
                          build/*.dylib # For Mac OS X.
headers.files           = *.h
unix:!macx:libs.path    = /usr/local/lib
unix:!macx:headers.path = /usr/local/include
macx:libs.path          = /usr/lib
macx:headers.path       = /usr/include
win32:libs.path         = C:/QextSerialPort-$$VERSION-svn/lib
win32:headers.path      = C:/QextSerialPort-$$VERSION-svn/include
INSTALLS                += libs headers

# Mac OS X deployment notes: run `make install` on QextSerialPort before running
# `macdeployqt YourQtApp.app`, then it will find and bundle the QextSerialPort
# library automatically.
