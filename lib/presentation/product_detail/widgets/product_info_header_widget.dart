import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Product Info Header Widget
/// Displays product name, price, rating, and authenticity badge
/// Includes wishlist functionality and bulk pricing information
class ProductInfoHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> productData;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;

  const ProductInfoHeaderWidget({
    super.key,
    required this.productData,
    required this.isWishlisted,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name and Wishlist
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productData["name"] as String,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      productData["shortDescription"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              IconButton(
                onPressed: onWishlistToggle,
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
            ],
          ),

          SizedBox(height: 2.h),

          // Authenticity Badge
          productData["isAuthentic"] == true
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'verified',
                        color: theme.colorScheme.tertiary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Producto Auténtico Verificado',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          SizedBox(height: 2.h),

          // Rating and Reviews
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 1.w),
              Text(
                productData["rating"].toString(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '(${productData["reviewCount"]} reseñas)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Price Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${productData["currency"]}${productData["price"]}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 2.w),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Text(
                  productData["unit"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Stock Status
          Row(
            children: [
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: productData["inStock"] == true
                      ? Colors.green
                      : theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                productData["inStock"] == true
                    ? 'En stock (${productData["stockCount"]} unidades)'
                    : 'Agotado',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: productData["inStock"] == true
                      ? Colors.green
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Bulk Pricing Section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_offer',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Precios por volumen',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                ...(productData["bulkPricing"] as List).map((pricing) {
                  final pricingMap = pricing as Map<String, dynamic>;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pricingMap["quantity"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              pricingMap["price"] as String,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            if ((pricingMap["discount"] as String)
                                .isNotEmpty) ...[
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  pricingMap["discount"] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onTertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
