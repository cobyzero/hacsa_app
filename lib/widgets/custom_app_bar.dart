import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with search functionality
  search,

  /// App bar with back button and title
  detail,

  /// App bar with logo for home/main screens
  branded,
}

/// Custom app bar for industrial adhesives mobile commerce
/// Implements professional minimalism with clear hierarchy
/// Optimized for outdoor visibility and one-handed operation
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomAppBarVariant variant;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onSearchTap;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.standard,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.onSearchTap,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.showBackButton = false,
    this.onBackPressed,
  });

  /// Standard app bar constructor
  const CustomAppBar.standard({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
  })  : variant = CustomAppBarVariant.standard,
        onSearchTap = null,
        searchController = null,
        onSearchChanged = null,
        onSearchSubmitted = null,
        showBackButton = false,
        onBackPressed = null;

  /// Search app bar constructor
  const CustomAppBar.search({
    super.key,
    this.title,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.actions,
  })  : variant = CustomAppBarVariant.search,
        leading = null,
        centerTitle = false,
        onSearchTap = null,
        showBackButton = false,
        onBackPressed = null;

  /// Detail app bar constructor (with back button)
  const CustomAppBar.detail({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
  })  : variant = CustomAppBarVariant.detail,
        leading = null,
        centerTitle = false,
        onSearchTap = null,
        searchController = null,
        onSearchChanged = null,
        onSearchSubmitted = null,
        showBackButton = true;

  /// Branded app bar constructor (with logo)
  const CustomAppBar.branded({
    super.key,
    this.actions,
  })  : variant = CustomAppBarVariant.branded,
        title = null,
        leading = null,
        centerTitle = false,
        onSearchTap = null,
        searchController = null,
        onSearchChanged = null,
        onSearchSubmitted = null,
        showBackButton = false,
        onBackPressed = null;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme);
      case CustomAppBarVariant.detail:
        return _buildDetailAppBar(context, theme);
      case CustomAppBarVariant.branded:
        return _buildBrandedAppBar(context, theme);
      case CustomAppBarVariant.standard:
      default:
        return _buildStandardAppBar(context, theme);
    }
  }

  /// Standard app bar with title and actions
  Widget _buildStandardAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      title: title != null
          ? Text(
              title!,
              style: theme.appBarTheme.titleTextStyle,
            )
          : null,
      centerTitle: centerTitle,
      actions: _buildActions(context),
      elevation: theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  /// Search app bar with integrated search field
  Widget _buildSearchAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          onSubmitted: (value) {
            if (onSearchSubmitted != null) {
              onSearchSubmitted!();
            }
          },
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
            suffixIcon: searchController?.text.isNotEmpty ?? false
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    onPressed: () {
                      searchController?.clear();
                      if (onSearchChanged != null) {
                        onSearchChanged!('');
                      }
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
      actions: _buildActions(context),
      elevation: theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
    );
  }

  /// Detail app bar with back button
  Widget _buildDetailAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      leading: _buildBackButton(context),
      title: title != null
          ? Text(
              title!,
              style: theme.appBarTheme.titleTextStyle,
            )
          : null,
      centerTitle: centerTitle,
      actions: _buildActions(context),
      elevation: theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
    );
  }

  /// Branded app bar with logo
  Widget _buildBrandedAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo placeholder - replace with actual logo asset
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.business,
              color: theme.colorScheme.onSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Industrial Adhesives',
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      centerTitle: centerTitle,
      actions: _buildActions(context),
      elevation: theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
    );
  }

  /// Build back button with haptic feedback
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      iconSize: 24,
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  /// Build action buttons with proper spacing
  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) {
      return null;
    }

    return [
      ...actions!,
      const SizedBox(width: 8), // Right padding for edge-to-edge content
    ];
  }
}

/// Pre-built action buttons for common app bar actions
class CustomAppBarActions {
  /// Search action button
  static Widget search(BuildContext context, VoidCallback onTap) {
    return IconButton(
      icon: const Icon(Icons.search),
      iconSize: 24,
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      tooltip: 'Search',
    );
  }

  /// Cart action button with optional badge
  static Widget cart(BuildContext context, VoidCallback onTap,
      {int? itemCount}) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          iconSize: 24,
          onPressed: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          tooltip: 'Cart',
        ),
        if (itemCount != null && itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Filter action button
  static Widget filter(BuildContext context, VoidCallback onTap) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      iconSize: 24,
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      tooltip: 'Filter',
    );
  }

  /// More options action button
  static Widget more(BuildContext context, VoidCallback onTap) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      iconSize: 24,
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      tooltip: 'More options',
    );
  }

  /// QR scanner action button
  static Widget qrScanner(BuildContext context, VoidCallback onTap) {
    return IconButton(
      icon: const Icon(Icons.qr_code_scanner),
      iconSize: 24,
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      tooltip: 'Scan QR Code',
    );
  }
}
