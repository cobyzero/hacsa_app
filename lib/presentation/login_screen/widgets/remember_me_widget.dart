import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

/// Remember me checkbox widget for frequent access
class RememberMeWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isLoading;

  const RememberMeWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          height: 6.h,
          width: 6.h,
          child: Checkbox(
            value: value,
            onChanged: isLoading
                ? null
                : (newValue) {
                    HapticFeedback.lightImpact();
                    onChanged(newValue);
                  },
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            'Recordarme en este dispositivo',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
