pragma Singleton

import QtQuick

QtObject {
    id: root

    // ========================================================================
    // TYPOGRAPHY / ТИПОГРАФИЯ
    // ========================================================================

    // Font Families
    readonly property string fontPrimary: "Inter"

    // Font Sizes (в pixelSize)
    readonly property int fontSizeXs: 10       // Метки, заголовки секций
    readonly property int fontSizeSm: 12       // Вспомогательный текст
    readonly property int fontSizeBase: 13     // Основной текст в диалогах
    readonly property int fontSizeMd: 14       // Заголовки подразделов
    readonly property int fontSizeLg: 16       // Иконки-текст
    readonly property int fontSizeXl: 18       // Заголовки
    readonly property int fontSizeXxl: 20      // Основные заголовки

    // ========================================================================
    // COLORS / ЦВЕТА
    // ========================================================================

    // Text Colors
    readonly property color textPrimary: "#0F1724"           // Основной текст
    readonly property color textSecondary: "#667085"         // Вспомогательный текст

    // Background Colors
    readonly property color backgroundWhite: "#FFFFFF"       // Белый фон
    readonly property color backgroundLight: "#fafbfc"       // Очень светло-серый
    readonly property color surfaceColor: "#F1F5F9"          // Серо-голубой фон

    // Primary & Accent Colors
    readonly property color accentPrimary: "#0B74DE"         // Основной синий
    readonly property color accentSidebar: "#e6f0ff"         // Активный пункт боковой панели

    // Border Colors
    readonly property color borderSoft: Qt.rgba(0, 0, 0, 0.08)    // Мягкая граница
    readonly property color borderDark: "#14000000"               // Альтернативная запись
    readonly property color borderInput: "#e0e0e0"                // Граница инпутов

    // Semantic Colors
    readonly property color dividerColor: "#f3f4f6"          // Делитель
    readonly property color hoverColor: "#f0f0f0"            // Наведение
    readonly property color selectedColor: "#e8eefc"         // Выделение
    readonly property color errorColor: "#B91C1C"            // Ошибки

    // ========================================================================
    // SPACING / ОТСТУПЫ
    // ========================================================================

    readonly property int spacingXs: 2        // Минимальный
    readonly property int spacingSm: 4        // Малый
    readonly property int spacingMd: 6        // Средний
    readonly property int spacingLg: 8        // Большой
    readonly property int spacingXl: 12       // Основной
    readonly property int spacingXxl: 16      // Крупные
    readonly property int spacingXxxl: 18     // Крупные +
    readonly property int spacingHuge: 20     // Очень большой
    readonly property int spacingMassive: 24  // Максимальный

    // ========================================================================
    // BORDER RADIUS / СКРУГЛЕНИЯ
    // ========================================================================

    readonly property int radiusNone: 0
    readonly property int radiusSm: 4         // Минимальное
    readonly property int radiusMd: 6         // Основное
    readonly property int radiusLg: 8         // Диалоги
    readonly property int radiusXl: 10        // Крупное

    // ========================================================================
    // COMPONENT SIZES / РАЗМЕРЫ
    // ========================================================================

    // Button Heights
    readonly property int buttonHeightSmall: 32      // Маленькие кнопки
    readonly property int buttonHeightBase: 36       // Стандартные
    readonly property int buttonHeightLarge: 40      // Большие

    // Header
    readonly property int headerHeight: 56           // Высота хедера

    // Avatar / Icons
    readonly property int avatarSmall: 32            // Маленький аватар
    readonly property int avatarBase: 64             // Стандартный
    readonly property int iconSmall: 16              // Маленькие иконки
    readonly property int iconMedium: 18             // Средние иконки
    readonly property int iconLarge: 24              // Большие иконки

    // ========================================================================
    // LAYOUT / МАКЕТ
    // ========================================================================

    readonly property int sidebarMinWidth: 200       // Минимальная ширина боковой панели
    readonly property real sidebarWidthRatio: 0.2    // Отношение ширины к общей
    readonly property int dialogMaxWidth: 540        // Максимальная ширина диалога
    readonly property int dialogPadding: 24          // Основной padding

    // ========================================================================
    // ANIMATION / АНИМАЦИЯ
    // ========================================================================

    readonly property int animationFast: 150         // Быстрая (hover)
    readonly property int animationNormal: 200       // Нормальная
    readonly property int animationSlow: 300         // Медленная

    // ========================================================================
    // Z-INDEX / УРОВНИ НАЛОЖЕНИЯ
    // ========================================================================

    readonly property int zBase: 0
    readonly property int zElevated: 10
    readonly property int zPopup: 1000
    readonly property int zOverlay: 999
    readonly property int zModal: 9999
}
