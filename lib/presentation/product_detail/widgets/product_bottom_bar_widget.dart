import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Product Bottom Bar Widget
/// Fixed bottom bar with quantity selector, add to cart button, and wishlist
/// Optimized for thumb-reachable positions and one-handed operation
class ProductBottomBarWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;

  const ProductBottomBarWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
    required this.isWishlisted,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onDecrement();
                      },
                      icon: CustomIconWidget(
                        iconName: 'remove',
                        color: quantity > 1
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                        size: 20,
                      ),
                      tooltip: 'Disminuir cantidad',
                    ),
                    Container(
                      width: 12.w,
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onIncrement();
                      },
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      tooltip: 'Aumentar cantidad',
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.w),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onAddToCart();
                  },
                  icon: CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Agregar al carrito'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Wishlist Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isWishlisted
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onWishlistToggle();
                  },
                  icon: CustomIconWidget(
                    iconName: isWishlisted ? 'favorite' : 'favorite_border',
                    color: isWishlisted
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  tooltip: isWishlisted
                      ? 'Eliminar de favoritos'
                      : 'Agregar a favoritos',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
