import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ScannerBottomSheetWidget extends StatelessWidget {
  final VoidCallback onManualEntry;
  final VoidCallback onShowRecentScans;

  const ScannerBottomSheetWidget({
    super.key,
    required this.onManualEntry,
    required this.onShowRecentScans,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 2.h),

            // Instructions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consejos para escanear',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildTip(
                    context,
                    icon: 'light_mode',
                    text: 'Asegúrate de tener buena iluminación',
                  ),
                  SizedBox(height: 0.5.h),
                  _buildTip(
                    context,
                    icon: 'center_focus_strong',
                    text: 'Mantén el código QR dentro del marco',
                  ),
                  SizedBox(height: 0.5.h),
                  _buildTip(
                    context,
                    icon: 'straighten',
                    text: 'Mantén una distancia de 15-20 cm',
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onManualEntry,
                      icon: CustomIconWidget(
                        iconName: 'keyboard',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: const Text('Entrada Manual'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShowRecentScans,
                      icon: CustomIconWidget(
                        iconName: 'history',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: const Text('Historial'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
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

  Widget _buildTip(BuildContext context,
      {required String icon, required String text}) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
