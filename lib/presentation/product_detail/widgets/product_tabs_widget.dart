import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Product Tabs Widget
/// Displays tabbed content for Overview, Technical Data, Reviews, and Authentication Guide
/// Uses TabController for smooth tab switching
class ProductTabsWidget extends StatelessWidget {
  final TabController tabController;
  final Map<String, dynamic> productData;

  const ProductTabsWidget({
    super.key,
    required this.tabController,
    required this.productData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          color: theme.colorScheme.surface,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Descripción'),
              Tab(text: 'Datos Técnicos'),
              Tab(text: 'Reseñas'),
              Tab(text: 'Autenticación'),
            ],
          ),
        ),
        SizedBox(
          height: 80.h,
          child: TabBarView(
            controller: tabController,
            children: [
              _OverviewTab(productData: productData),
              _TechnicalDataTab(productData: productData),
              _ReviewsTab(productData: productData),
              _AuthenticationTab(productData: productData),
            ],
          ),
        ),
      ],
    );
  }
}

/// Overview Tab
/// Displays product features and applications
class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> productData;

  const _OverviewTab({required this.productData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Características principales',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          ...(productData["features"] as List).map((feature) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      feature as String,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 3.h),
          Text(
            'Aplicaciones',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          ...(productData["applications"] as List).map((application) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: CustomIconWidget(
                      iconName: 'arrow_right',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      application as String,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// Technical Data Tab
/// Displays specifications and technical documents
class _TechnicalDataTab extends StatelessWidget {
  final Map<String, dynamic> productData;

  const _TechnicalDataTab({required this.productData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final specifications =
        productData["specifications"] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Especificaciones técnicas',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: specifications.entries.map((entry) {
                final isLast = entry == specifications.entries.last;
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.value as String,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Documentos técnicos',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          ...(productData["technicalDocs"] as List).map((doc) {
            final docMap = doc as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'picture_as_pdf',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  docMap["name"] as String,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${docMap["type"]} • ${docMap["size"]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: CustomIconWidget(
                  iconName: 'download',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Descargando ${docMap["name"]}...',
                        style: theme.snackBarTheme.contentTextStyle,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// Reviews Tab
/// Displays customer reviews and ratings
class _ReviewsTab extends StatelessWidget {
  final Map<String, dynamic> productData;

  const _ReviewsTab({required this.productData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      productData["rating"].toString(),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return CustomIconWidget(
                          iconName: index < productData["rating"].floor()
                              ? 'star'
                              : 'star_border',
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${productData["reviewCount"]} reseñas',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Reseñas de clientes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          ...(productData["reviews"] as List).map((review) {
            final reviewMap = review as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.only(bottom: 3.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: CustomImageWidget(
                          imageUrl: reviewMap["userAvatar"] as String,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          semanticLabel: reviewMap["semanticLabel"] as String,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  reviewMap["userName"] as String,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (reviewMap["verified"] == true) ...[
                                  SizedBox(width: 1.w),
                                  CustomIconWidget(
                                    iconName: 'verified',
                                    color: theme.colorScheme.tertiary,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                ...List.generate(5, (index) {
                                  return CustomIconWidget(
                                    iconName: index <
                                            (reviewMap["rating"] as double)
                                                .floor()
                                        ? 'star'
                                        : 'star_border',
                                    color: Colors.amber,
                                    size: 14,
                                  );
                                }),
                                SizedBox(width: 2.w),
                                Text(
                                  reviewMap["date"] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    reviewMap["comment"] as String,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: CustomIconWidget(
                          iconName: 'thumb_up_outlined',
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                        label: Text('Útil (${reviewMap["helpful"]})'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// Authentication Tab
/// Displays authentication guide with visual comparisons
class _AuthenticationTab extends StatelessWidget {
  final Map<String, dynamic> productData;

  const _AuthenticationTab({required this.productData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authGuide =
        productData["authenticationGuide"] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            authGuide["title"] as String,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          ...(authGuide["comparisons"] as List).map((comparison) {
            final comparisonMap = comparison as Map<String, dynamic>;
            return Container(
              margin: EdgeInsets.only(bottom: 3.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    child: CustomImageWidget(
                      imageUrl: comparisonMap["image"] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                      semanticLabel: comparisonMap["semanticLabel"] as String,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comparisonMap["feature"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Original:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    comparisonMap["original"] as String,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIconWidget(
                              iconName: 'cancel',
                              color: theme.colorScheme.error,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Falsificación:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                  Text(
                                    comparisonMap["fake"] as String,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.tertiary,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Pasos de verificación',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ...(authGuide["verificationSteps"] as List)
                    .asMap()
                    .entries
                    .map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            entry.value as String,
                            style: theme.textTheme.bodyMedium,
                          ),
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
