cmake_minimum_required(VERSION 3.16)

# Improve Windows defaults: if no generator is set and MSVC tools are unavailable,
# prefer MinGW Makefiles so users can still configure with MSYS2 g++.
if(WIN32 AND NOT DEFINED CMAKE_GENERATOR)
    find_program(NMAKE_EXE NAMES nmake)
    find_program(MINGW_MAKE_EXE NAMES mingw32-make)
    if(NOT NMAKE_EXE AND MINGW_MAKE_EXE)
        set(CMAKE_GENERATOR "MinGW Makefiles" CACHE INTERNAL "Default generator" FORCE)
    endif()
endif()

project(zametki VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ⚡ Здесь ключевое: правильные имена компонентов
find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickLayouts)

# Set Qt policies
qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_standard_project_setup(REQUIRES 6.5)

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
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/AuthPage.qml
        qml/Search.qml
        qml/Settings.qml
        qml/Share.qml
        qml/Profile.qml
        qml/scripts/Handlers.mjs
        qml/scripts/Theme.js
        qml/components/FolderNoteList.qml
        qml/components/SidebarPanel.qml
        qml/components/MainHeaderBar.qml
        qml/components/AppSwitch.qml
        qml/components/AppButton.qml
        qml/components/AppPageTitleText.qml
        qml/components/AppSidebarLabelText.qml
        qml/components/AppSectionTitleText.qml
        qml/components/AppDescriptionText.qml
        qml/components/AppBodyText.qml
        qml/components/AppSectionCard.qml
        qml/components/AppDivider.qml
        qml/components/AppActionButton.qml
        qml/components/AppActionButtonCompact.qml
        qml/components/AppInputField.qml
        qml/components/AppDropdown.qml
        qml/components/AppInitialsAvatar.qml
        qml/components/AppIconSurfaceButton.qml
        qml/components/share/ShareParticipantRow.qml
        qml/components/main/MainModalOverlay.qml
        qml/components/settings/SettingsNavItem.qml
        qml/components/settings/SettingsControlRow.qml
        qml/components/settings/SettingsKeyValueRow.qml
        qml/components/settings/SettingsRowLabel.qml
        qml/components/auth/AuthInputField.qml
        qml/components/auth/AuthPrimaryButton.qml
        qml/components/auth/AuthSocialButton.qml
        qml/components/auth/AuthLinkButton.qml
        qml/components/auth/AuthDivider.qml
        qml/components/auth/AuthModeTabButton.qml
        qml/components/auth/LoginForm.qml
        qml/components/auth/RegisterForm.qml
        qml/components/search/SearchSectionHeader.qml
        qml/components/search/SearchResultRow.qml
        qml/components/search/SearchFooterHint.qml
        qml/components/search/SearchInputBar.qml
        qml/components/search/SearchHintsBar.qml
        qml/CreationBD.qml
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
        assets/icons/header/show-sidebar.svg
        assets/icons/list/note.svg
        assets/icons/list/note-selected.svg
        assets/icons/list/closed-bracket.svg
        assets/icons/list/closed-bracket-selected.svg
        assets/icons/list/folder.svg
        assets/icons/list/folder-selected.svg
        assets/icons/list/open-folder.svg
        assets/icons/list/open-folder-selected.svg
        assets/icons/share/close-btn.svg
        assets/icons/share/copy.svg
        assets/icons/share/link.svg
        assets/icons/share/people.svg
        assets/icons/unused/open-bracket.svg
        assets/icons/settings/account.svg
        assets/icons/settings/application.svg
        assets/icons/settings/search.svg
        assets/icons/settings/graph.svg
        assets/icons/settings/tasks.svg
        assets/icons/settings/security.svg
        assets/icons/settings/hot-keys.svg
        assets/icons/settings/about.svg
        assets/icons/settings/log-out.svg
        assets/icons/profile/profile.svg
        assets/icons/profile/settings.svg
        assets/icons/profile/sync.svg
        assets/icons/profile/help.svg
        assets/icons/profile/keyboard.svg
        assets/icons/profile/logout.svg
        assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf
)

set_target_properties(appzametki PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# ⚡ Линковка с правильными компонентами
target_link_libraries(appzametki
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::QuickLayouts
)

include(GNUInstallDirs)
install(TARGETS appzametki
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
