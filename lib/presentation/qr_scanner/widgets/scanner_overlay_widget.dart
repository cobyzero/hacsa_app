import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ScannerOverlayWidget extends StatefulWidget {
  final bool isProcessing;
  final VoidCallback onTap;

  const ScannerOverlayWidget({
    super.key,
    required this.isProcessing,
    required this.onTap,
  });

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayWidgetState();
}

class _ScannerOverlayWidgetState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.isProcessing ? null : widget.onTap,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Stack(
          children: [
            // Center scanning area
            Center(
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Corner indicators
                    _buildCorner(
                      alignment: Alignment.topLeft,
                      borderSide: BorderSide(
                        color: widget.isProcessing
                            ? theme.colorScheme.secondary
                            : Colors.white,
                        width: 4,
                      ),
                    ),
                    _buildCorner(
                      alignment: Alignment.topRight,
                      borderSide: BorderSide(
                        color: widget.isProcessing
                            ? theme.colorScheme.secondary
                            : Colors.white,
                        width: 4,
                      ),
                    ),
                    _buildCorner(
                      alignment: Alignment.bottomLeft,
                      borderSide: BorderSide(
                        color: widget.isProcessing
                            ? theme.colorScheme.secondary
                            : Colors.white,
                        width: 4,
                      ),
                    ),
                    _buildCorner(
                      alignment: Alignment.bottomRight,
                      borderSide: BorderSide(
                        color: widget.isProcessing
                            ? theme.colorScheme.secondary
                            : Colors.white,
                        width: 4,
                      ),
                    ),

                    // Scanning line animation
                    if (!widget.isProcessing)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned(
                            top: _animation.value * 70.w,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    theme.colorScheme.secondary,
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Processing indicator
                    if (widget.isProcessing)
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: theme.colorScheme.secondary,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Procesando...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Instruction text
            Positioned(
              bottom: 25.h,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Posiciona el código QR dentro del marco',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'verified_user',
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Verifica la autenticidad del producto',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    required Alignment alignment,
    required BorderSide borderSide,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          border: Border(
            top: alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? borderSide
                : BorderSide.none,
            bottom: alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? borderSide
                : BorderSide.none,
            left: alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? borderSide
                : BorderSide.none,
            right: alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? borderSide
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
