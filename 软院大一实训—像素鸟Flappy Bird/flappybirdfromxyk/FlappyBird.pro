#-------------------------------------------------
#
# Project created by QtCreator 2014-03-11T16:19:41
#
#-------------------------------------------------

QT       += core gui
QT      += multimedia
QT +=multimediawidgets
VERSION = 1.1.1

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = FlappyBird
TEMPLATE = app
#        RC_ICONS = bird.ico
#	这句在windows下编译时解除注释，让exe文件带上图标

SOURCES += main.cpp\
    Module/fbnumLCD/number.cpp \
    Module/rankboard.cpp \
        mainwindow.cpp \
    Module/bird/bird.cpp \
    Module/ground/ground.cpp \
    Module/pipe/pipe.cpp \
    Module/scoreboard/scoreboard.cpp \
    Module/redyboard/redyboard.cpp

HEADERS  += mainwindow.h \
    Module/bird/bird.h \
    Module/fbnumLCD/number.h \
    Module/ground/ground.h \
    Module/pipe/pipe.h \
    Module/rankboard.h \
    Module/scoreboard/scoreboard.h \
    Module/redyboard/redyboard.h

FORMS    +=

RESOURCES += \
    flappy.qrc
