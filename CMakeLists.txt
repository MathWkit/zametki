cmake_minimum_required(VERSION 3.16)

project(zametki VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appzametki
    src/main.cpp
    src/filecreator.cpp
    include/filecreator.h
)

target_include_directories(appzametki
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
)

qt_add_qml_module(appzametki
    URI zametki
    QML_FILES
        qml/Main.qml
        qml/scripts/Handlers.mjs
        qml/scripts/Theme.js
        qml/components/FolderNoteList.qml
        qml/components/SidebarPanel.qml
        qml/components/MainHeaderBar.qml
    RESOURCES
        assets/icons/sidebar/search.svg
        assets/icons/sidebar/new-note.svg
        assets/icons/sidebar/graph-view.svg
        assets/icons/sidebar/my-knowledge-base.svg
        assets/icons/sidebar/chosen.svg
        assets/icons/header/share.svg
        assets/icons/header/favorite.svg
        assets/icons/header/more.svg
        assets/icons/header/hide-sidebar.svg
        assets/icons/list/note.svg
        assets/icons/list/closed-bracket.svg
        assets/icons/list/folder.svg
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
