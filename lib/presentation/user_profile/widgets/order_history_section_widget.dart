import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class OrderHistorySectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentOrders;
  final Function(String) onOrderTap;
  final Function(String) onReorder;
  final Function(String) onDownloadInvoice;

  const OrderHistorySectionWidget({
    super.key,
    required this.recentOrders,
    required this.onOrderTap,
    required this.onReorder,
    required this.onDownloadInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historial de Pedidos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ver todos los pedidos próximamente')),
                  );
                },
                child: Text(
                  'Ver Todos',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          ...recentOrders.map((order) => _buildOrderCard(context, order)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final String status = order["status"] as String;
    final Color statusColor = _getStatusColor(status, theme);

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onOrderTap(order["orderId"] as String);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order["orderId"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          order["date"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.5.h),

              // Order details
              Row(
                children: [
                  Expanded(
                    child: _buildOrderDetail(
                      context,
                      'shopping_bag',
                      '${order["items"]} artículos',
                    ),
                  ),
                  Expanded(
                    child: _buildOrderDetail(
                      context,
                      'payments',
                      order["total"] as String,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.5.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onReorder(order["orderId"] as String);
                      },
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                      label: Text(
                        'Reordenar',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onDownloadInvoice(order["orderId"] as String);
                      },
                      icon: CustomIconWidget(
                        iconName: 'download',
                        color: theme.colorScheme.secondary,
                        size: 18,
                      ),
                      label: Text(
                        'Factura',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        side: BorderSide(color: theme.colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetail(BuildContext context, String iconName, String text) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 18,
        ),
        SizedBox(width: 2.w),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Entregado':
        return const Color(0xFF27AE60); // Success green
      case 'En tránsito':
        return const Color(0xFFF39C12); // Warning orange
      case 'Procesando':
        return theme.colorScheme.primary;
      case 'Cancelado':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
