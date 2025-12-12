import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentScansWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentScans;
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onScanTap;

  const RecentScansWidget({
    super.key,
    required this.recentScans,
    required this.onClose,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'history',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Escaneos Recientes',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: recentScans.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'qr_code_scanner',
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No hay escaneos recientes',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.all(4.w),
                          itemCount: recentScans.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 2.h),
                          itemBuilder: (context, index) {
                            final scan = recentScans[index];
                            return _buildScanItem(context, scan);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanItem(BuildContext context, Map<String, dynamic> scan) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final isGenuine = scan["status"] == "genuine";

    return InkWell(
      onTap: () => onScanTap(scan),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: scan["image"] as String,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                semanticLabel: scan["semanticLabel"] as String,
              ),
            ),

            SizedBox(width: 3.w),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan["productName"] as String,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    scan["id"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    dateFormat.format(scan["timestamp"] as DateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isGenuine
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: isGenuine ? 'verified' : 'warning',
                    color: isGenuine
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    isGenuine ? 'Genuino' : 'Sospechoso',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isGenuine
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
