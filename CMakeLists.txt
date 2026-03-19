cmake_minimum_required(VERSION 3.19)
project(zametki LANGUAGES CXX)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Widgets LinguistTools)

qt_standard_project_setup()

qt_add_executable(zametki
    WIN32 MACOSX_BUNDLE
    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui
)

qt_add_translations(
    TARGETS zametki
    TS_FILES zametki_ru_RU.ts
)

target_link_libraries(zametki
    PRIVATE
        Qt::Core
        Qt::Widgets
)

include(GNUInstallDirs)

install(TARGETS zametki
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_app_script(
    TARGET zametki
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})


# Подключаем Qt Test
find_package(Qt6 COMPONENTS Test REQUIRED)

# Создаём тестовый исполняемый файл
add_executable(zametki_tests
    test_main.cpp
    mainwindow.cpp   # включаем GUI-классы, если нужно тестировать их напрямую
    mainwindow.h
)

# Линкуем Qt Test и необходимые модули Qt
target_link_libraries(zametki_tests PRIVATE Qt6::Test Qt6::Core Qt6::Widgets)