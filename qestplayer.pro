# Add more folders to ship with the application, here
folder_01.source = qml/qestplayer
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

QT += network androidextras

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable


CONFIG(release, debug|release) {
    #This is a release build
    DEFINES += PLAYER_RELEASE
} else {
    #This is a debug build
}

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    polygonitem.cpp \
    questremotecreator.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    quest.js \
    quest.json \
    quest1.json

RESOURCES += \
    quest.qrc

HEADERS += \
    polygonitem.h \
    questremotecreator.h \
    defines.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/project.properties \
    android/src/org/qtproject/example/admobqt/AdMobQtActivity.java \
    old_activity


ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
