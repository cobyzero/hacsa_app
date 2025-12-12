import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PreferencesSectionWidget extends StatefulWidget {
  final VoidCallback onNotificationSettings;
  final VoidCallback onLanguageSettings;
  final VoidCallback onBiometricSettings;

  const PreferencesSectionWidget({
    super.key,
    required this.onNotificationSettings,
    required this.onLanguageSettings,
    required this.onBiometricSettings,
  });

  @override
  State<PreferencesSectionWidget> createState() =>
      _PreferencesSectionWidgetState();
}

class _PreferencesSectionWidgetState extends State<PreferencesSectionWidget> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _promotionalEmails = false;
  bool _biometricAuth = true;
  bool _autoQRScan = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferencias',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 1.5.h),

          // Notifications Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Notificaciones',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  _buildSwitchTile(
                    context,
                    'Notificaciones Push',
                    'Recibir alertas de pedidos y promociones',
                    _pushNotifications,
                    (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _pushNotifications = value);
                      widget.onNotificationSettings();
                    },
                  ),
                  Divider(height: 2.h),
                  _buildSwitchTile(
                    context,
                    'Notificaciones por Email',
                    'Recibir actualizaciones por correo',
                    _emailNotifications,
                    (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _emailNotifications = value);
                      widget.onNotificationSettings();
                    },
                  ),
                  Divider(height: 2.h),
                  _buildSwitchTile(
                    context,
                    'Emails Promocionales',
                    'Ofertas especiales y descuentos',
                    _promotionalEmails,
                    (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _promotionalEmails = value);
                      widget.onNotificationSettings();
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Language & Region Card
          Card(
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onLanguageSettings();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'language',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Idioma',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            'Español (México)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Security & Authentication Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Seguridad',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  _buildSwitchTile(
                    context,
                    'Autenticación Biométrica',
                    'Usar huella digital o Face ID',
                    _biometricAuth,
                    (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _biometricAuth = value);
                      widget.onBiometricSettings();
                    },
                  ),
                  Divider(height: 2.h),
                  _buildSwitchTile(
                    context,
                    'Escaneo QR Automático',
                    'Activar cámara al abrir escáner',
                    _autoQRScan,
                    (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _autoQRScan = value);
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Wishlist Card
          Card(
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lista de deseos próximamente')),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'favorite',
                      color: theme.colorScheme.error,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lista de Deseos',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            '12 productos guardados',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.3.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
