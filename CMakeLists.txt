cmake_minimum_required(VERSION 3.16)

project(zametki VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appzametki
    main.cpp
    filecreator.cpp
)

qt_add_qml_module(appzametki
    URI zametki
    QML_FILES
        Main.qml
        Handlers.mjs
    RESOURCES
        assets/search.svg
        assets/new-note.svg
        assets/graph-view.svg
        assets/my-knowledge-base.svg
        assets/chose.svg
        assets/share.svg
        assets/favorite.svg
        assets/more.svg
        assets/hide-sidebar.svg
        assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appzametki PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appzametki
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appzametki
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appzametki
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
