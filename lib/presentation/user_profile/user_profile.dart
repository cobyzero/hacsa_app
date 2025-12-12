import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_info_section_widget.dart';
import './widgets/order_history_section_widget.dart';
import './widgets/preferences_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/support_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _currentBottomNavIndex = 3; // Profile tab selected

  // Mock user data
  final Map<String, dynamic> _userData = {
    "userId": "USR-2025-001",
    "name": "Carlos Mendoza",
    "email": "carlos.mendoza@industriasacme.com",
    "phone": "+52 55 1234 5678",
    "accountType": "Profesional",
    "verified": true,
    "avatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_19f11425f-1763295319288.png",
    "semanticLabel":
        "Foto de perfil de un hombre hispano con cabello corto negro y barba, vistiendo camisa azul",
    "company": "Industrias ACME S.A. de C.V.",
    "taxId": "RFC: AME850101ABC",
    "creditLimit": "\$50,000.00",
    "creditUsed": "\$12,450.00",
    "memberSince": "Enero 2023",
    "totalOrders": 47,
    "loyaltyPoints": 2340
  };

  final List<Map<String, dynamic>> _recentOrders = [
    {
      "orderId": "ORD-2025-0234",
      "date": "08/12/2024",
      "total": "\$3,450.00",
      "status": "Entregado",
      "items": 5,
      "invoiceUrl": "https://example.com/invoice-234.pdf"
    },
    {
      "orderId": "ORD-2025-0198",
      "date": "25/11/2024",
      "total": "\$1,890.00",
      "status": "En tránsito",
      "items": 3,
      "invoiceUrl": "https://example.com/invoice-198.pdf"
    },
    {
      "orderId": "ORD-2025-0156",
      "date": "10/11/2024",
      "total": "\$5,670.00",
      "status": "Entregado",
      "items": 8,
      "invoiceUrl": "https://example.com/invoice-156.pdf"
    }
  ];

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      "id": "ADDR-001",
      "label": "Oficina Principal",
      "address": "Av. Insurgentes Sur 1234, Col. Del Valle, CDMX 03100",
      "isDefault": true
    },
    {
      "id": "ADDR-002",
      "label": "Almacén Norte",
      "address": "Calle Industrial 567, Parque Industrial, Monterrey 64000",
      "isDefault": false
    }
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "PAY-001",
      "type": "Tarjeta de Crédito",
      "last4": "4532",
      "brand": "Visa",
      "expiry": "12/26",
      "isDefault": true
    },
    {
      "id": "PAY-002",
      "type": "Cuenta Empresarial",
      "accountNumber": "****7890",
      "bank": "BBVA",
      "isDefault": false
    }
  ];

  void _handleBottomNavTap(int index) {
    HapticFeedback.lightImpact();

    if (index == _currentBottomNavIndex) return;

    setState(() => _currentBottomNavIndex = index);

    // Navigate to corresponding screens
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/product-catalog');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/qr-scanner');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        // Already on profile
        break;
    }
  }

  void _handleEditProfile() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de edición de perfil próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleOrderTap(String orderId) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/product-detail');
  }

  void _handleReorder(String orderId) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reordenando pedido $orderId...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleDownloadInvoice(String orderId) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando factura de $orderId...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleNotificationSettings() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración de notificaciones próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleLanguageSettings() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selección de idioma próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBiometricSettings() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración biométrica próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleContactSupport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo chat de soporte...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleFAQ() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo preguntas frecuentes...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTechnicalDocs() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo documentación técnica...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.standard(
        title: 'Mi Perfil',
        actions: [
          CustomAppBarActions.more(
            context,
            () {
              HapticFeedback.lightImpact();
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userData: _userData,
                onEditProfile: _handleEditProfile,
              ),

              SizedBox(height: 2.h),

              // Account Information Section
              AccountInfoSectionWidget(
                userData: _userData,
                savedAddresses: _savedAddresses,
                paymentMethods: _paymentMethods,
              ),

              SizedBox(height: 2.h),

              // Order History Section
              OrderHistorySectionWidget(
                recentOrders: _recentOrders,
                onOrderTap: _handleOrderTap,
                onReorder: _handleReorder,
                onDownloadInvoice: _handleDownloadInvoice,
              ),

              SizedBox(height: 2.h),

              // Preferences Section
              PreferencesSectionWidget(
                onNotificationSettings: _handleNotificationSettings,
                onLanguageSettings: _handleLanguageSettings,
                onBiometricSettings: _handleBiometricSettings,
              ),

              SizedBox(height: 2.h),

              // Support Section
              SupportSectionWidget(
                onContactSupport: _handleContactSupport,
                onFAQ: _handleFAQ,
                onTechnicalDocs: _handleTechnicalDocs,
              ),

              SizedBox(height: 2.h),

              // Logout Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: CustomIconWidget(
                      iconName: 'logout',
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    label: Text(
                      'Cerrar Sesión',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.error),
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // App Version
              Text(
                'Hacsa v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'privacy_tip',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Privacidad', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Configuración de privacidad próximamente')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Exportar Datos', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exportando datos...')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_forever',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Eliminar Cuenta',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
                _showDeleteAccountDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cuenta'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Solicitud de eliminación enviada')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
