import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sizer/sizer.dart';

/// Social login options widget
/// Provides Google and Apple sign-in buttons
class SocialLoginWidget extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.dividerColor,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'O continuar con',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.dividerColor,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social login buttons
        Row(
          children: [
            // Google sign-in button
            Expanded(
              child: SizedBox(
                height: 6.h,
                child: SignInButton(
                  Buttons.google,
                  text: 'Google',
                  onPressed: isLoading
                      ? () {}
                      : () {
                          HapticFeedback.lightImpact();
                          onGoogleSignIn();
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Apple sign-in button
            Expanded(
              child: SizedBox(
                height: 6.h,
                child: SignInButton(
                  Buttons.apple,
                  text: 'Apple',
                  onPressed: isLoading
                      ? () {}
                      : () {
                          HapticFeedback.lightImpact();
                          onAppleSignIn();
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
