.pragma library

// ============================================================================
// TYPOGRAPHY
// ============================================================================
var fontFamily = "Inter";
var fontSizeXs = 10;
var fontSizeSm = 12;
var fontSizeBase = 13;
var fontSizeMd = 14;
var fontSizeLg = 16;
var fontSizeXl = 18;
var fontSizeXxl = 20;

// ============================================================================
// COLORS - TEXT
// ============================================================================
var textPrimary = "#0F1724";
var textSecondary = "#6B7280";

// ============================================================================
// COLORS - BACKGROUND
// ============================================================================
var headerBackground = "#FFFFFF";
var backgroundWhite = "#FFFFFF";
var backgroundLight = "#fafbfc";
var surfaceColor = "#F1F5F9";

// ============================================================================
// COLORS - ACCENT
// ============================================================================
var accentPrimary = "#0B74DE";
var accentSidebar = "#e6f0ff";

// ============================================================================
// COLORS - BORDER & SEMANTIC
// ============================================================================
var border = Qt.rgba(0, 0, 0, 0.08);
var borderSoft = Qt.rgba(0, 0, 0, 0.08);
var hover = "#f0f0f0";
var selected = "#e8eefc";
var dividerColor = "#f3f4f6";
var errorColor = "#B91C1C";
var overlayScrim = Qt.rgba(0, 0, 0, 0.4);

// Auth screen specific colors
var authAccentHover = "#0A67C7";
var authAccentPressed = "#08539F";
var authInputBorder = "#D1D5DB";
var authInputBorderHover = "#9CA3AF";
var authSocialButtonHover = "#F8FAFC";

// ============================================================================
// SPACING
// ============================================================================
var gridUnit = 8;
var space1 = gridUnit;      // 8
var space2 = gridUnit * 2;  // 16
var space3 = gridUnit * 3;  // 24
var space4 = gridUnit * 4;  // 32

var spacingXs = 2;
var spacingSm = 4;
var spacingMd = 6;
var spacingLg = space1;
var spacingXl = 12;
var spacingXxl = space2;
var spacingXxxl = 18;
var spacingHuge = 20;
var spacingMassive = space3;

// ============================================================================
// BORDER RADIUS
// ============================================================================
var radiusNone = 0;
var radiusSm = 4;
var radiusMd = 6;
var radiusLg = 8;
var radiusXl = 10;
var cornerRadius = 4;  // Legacy

// Shared radius for auth card, profile/share/search modals, and similar surfaces
var modalSurfaceRadius = 10;
// Legacy name — keep in sync with modal surfaces
var authCardRadius = modalSurfaceRadius;

// ============================================================================
// COMPONENT SIZES
// ============================================================================
var buttonHeightSmall = 32;
var buttonHeightBase = 36;
var buttonHeightLarge = 40;
var inputHeightBase = 40;
var dropdownHeightBase = 40;
var controlHeightBase = 40;

var avatarSmall = 32;
var avatarMedium = 36;
var avatarBase = 64;
var iconTiny = 14;
var iconSmall = 16;
var iconMedium = 18;
var iconLarge = 24;

var headerHeight = 56;

// Auth component sizes
var authTitleSize = 22;
var authSocialButtonHeight = 38;
var authFieldVerticalPadding = 10;
var authCardMinWidth = 320;
var authCardMaxWidth = 400;

// ============================================================================
// LAYOUT
// ============================================================================
var sidebarMinWidth = 200;
var sidebarWidthRatio = 0.2;
var dialogMaxWidth = 540;
var dialogMaxHeight = 680;
var dialogPadding = space3;
var contentInset = space2;
var sectionSpacing = space3;
var rowPadding = space2;
var rowPaddingCompact = space1;
var settingsNumericFieldWidth = 80;
var settingsPathFieldWidth = 220;
var actionButtonMediumWidth = 120;
var actionButtonCompactPadding = 10;

// Creation BD overlay card
var creationBdCardHorizontalMargin = 40;
var creationBdMaxCardWidth = 480;
var creationBdContentPadding = spacingHuge;
var creationBdColumnSpacing = spacingXl;
var creationBdFolderRowSpacing = spacingLg;

var searchDialogHeight = 432;
var searchDialogMinWidth = 360;
var searchInset = space2;
var searchSectionInset = space3;
var searchCompactGap = spacingLg;
var searchHintBarHeight = 40;
var searchResultRowHeight = 36;
var searchResultRowHeightWithSubtitle = 44;

var sidebarTreeIndentStep = 20;
var sidebarTreeRowHeightFolder = 28;
var sidebarTreeRowHeightNote = 32;
var sidebarListInset = 12;
var sidebarProfileTinyGap = spacingSm;

var dropdownTextPaddingLeft = spacingXl;
var dropdownTextPaddingRight = 28;
var dropdownIndicatorSize = 12;
var dropdownIndicatorRightInset = 10;
var dropdownPopupOffset = 6;

// Switch (custom indicator) — keep magic numbers in one place
var switchTrackWidth = 45;
var switchTrackHeight = 25;
var switchHandleMargin = 3;

var inputBorderWidth = 1;
var inputFocusBorderWidth = 1;

// ============================================================================
// ANIMATION
// ============================================================================
var animationFast = 150;
var animationNormal = 200;
var animationSlow = 300;

// ============================================================================
// Z-INDEX
// ============================================================================
var zBase = 0;
var zElevated = 10;
var zOverlay = 999;
var zPopup = 1000;
var zModal = 9999;
