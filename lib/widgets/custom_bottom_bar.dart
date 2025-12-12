import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Navigation item configuration for the bottom bar
class CustomBottomBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const CustomBottomBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar for industrial adhesives mobile commerce
/// Implements bottom-heavy interaction design with 48dp touch targets
/// Optimized for one-handed operation and gloved-hand use
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final List<CustomBottomBarItem>? items;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.items,
  });

  /// Default navigation items based on Mobile Navigation Hierarchy
  static const List<CustomBottomBarItem> defaultItems = [
    CustomBottomBarItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
      label: 'Catalog',
      route: '/product-catalog',
    ),
    CustomBottomBarItem(
      icon: Icons.qr_code_scanner_outlined,
      activeIcon: Icons.qr_code_scanner,
      label: 'Scanner',
      route: '/qr-scanner',
    ),
    CustomBottomBarItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
      route: '/cart', // Cart functionality within catalog
    ),
    CustomBottomBarItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/user-profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationItems = items ?? defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64, // Generous height for easy thumb reach
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navigationItems.length,
              (index) => _buildNavigationItem(
                context: context,
                item: navigationItems[index],
                index: index,
                isSelected: currentIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required CustomBottomBarItem item,
    required int index,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Haptic feedback for tactile confirmation
            HapticFeedback.lightImpact();

            if (onTap != null) {
              onTap!(index);
            } else {
              // Default navigation behavior
              Navigator.pushNamed(context, item.route);
            }
          },
          // Minimum 48dp touch target with expanded area
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with 24dp size for clear visibility
                Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 24,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                const SizedBox(height: 4),
                // Label with professional typography
                Text(
                  item.label,
                  style: (isSelected
                          ? theme.bottomNavigationBarTheme.selectedLabelStyle
                          : theme.bottomNavigationBarTheme.unselectedLabelStyle)
                      ?.copyWith(
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Variant of CustomBottomBar with badge support for cart items
class CustomBottomBarWithBadge extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final List<CustomBottomBarItem>? items;
  final Map<int, int>? badges; // Index to badge count mapping

  const CustomBottomBarWithBadge({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.items,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationItems = items ?? CustomBottomBar.defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navigationItems.length,
              (index) => _buildNavigationItemWithBadge(
                context: context,
                item: navigationItems[index],
                index: index,
                isSelected: currentIndex == index,
                badgeCount: badges?[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItemWithBadge({
    required BuildContext context,
    required CustomBottomBarItem item,
    required int index,
    required bool isSelected,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();

            if (onTap != null) {
              onTap!(index);
            } else {
              Navigator.pushNamed(context, item.route);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with badge overlay
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      size: 24,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                    if (badgeCount != null && badgeCount > 0)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.bottomNavigationBarTheme
                                      .backgroundColor ??
                                  Colors.white,
                              width: 1.5,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              badgeCount > 99 ? '99+' : badgeCount.toString(),
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
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: (isSelected
                          ? theme.bottomNavigationBarTheme.selectedLabelStyle
                          : theme.bottomNavigationBarTheme.unselectedLabelStyle)
                      ?.copyWith(
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
