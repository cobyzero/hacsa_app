import 'package:adhesivepro/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductAuthentication extends StatelessWidget {
  const ProductAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.standard(title: "Verificación de Producto"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cómo reconocer un producto original",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Sigue esta guía para verificar que tu producto sea auténtico "
                "y no una imitación (bamba).",
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 3.h),
              _buildCard(
                context,
                title: "1. Revisa el Código QR",
                originalPoints: [
                  "El QR redirige a la web oficial al escanearlo.",
                  "Muestra información del lote y fecha de fabricación.",
                ],
                fakePoints: [
                  "El QR no abre nada o lleva a una web desconocida.",
                  "La información del lote no coincide o está incompleta.",
                ],
                icon: Icons.qr_code_scanner,
              ),
              SizedBox(height: 3.h),
              _buildCard(
                context,
                title: "2. Verifica el empaque",
                originalPoints: [
                  "Impresión nítida y colores consistentes.",
                  "El logo está correctamente alineado y centrado.",
                ],
                fakePoints: [
                  "Impresión borrosa o tonos distintos.",
                  "Logo movido o con bordes extraños.",
                ],
                icon: Icons.inventory_2_rounded,
              ),
              SizedBox(height: 3.h),
              _buildCard(
                context,
                title: "3. Textura y materiales",
                originalPoints: [
                  "Material firme y de buena calidad.",
                  "Sellos de seguridad intactos.",
                ],
                fakePoints: [
                  "Material delgado o frágil.",
                  "Sellos de seguridad inexistentes o mal pegados.",
                ],
                icon: Icons.shield_outlined,
              ),
              SizedBox(height: 5.h),
              Center(
                child: Text(
                  "Si tienes dudas, escanea el QR desde la app.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<String> originalPoints,
    required List<String> fakePoints,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: 100.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: theme.primaryColor),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "Producto Original",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 1.h),
          ...originalPoints
              .map((e) => _buildPoint(e, Icons.check_circle, Colors.green)),
          SizedBox(height: 2.h),
          Text(
            "Producto Bamba",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          SizedBox(height: 1.h),
          ...fakePoints.map((e) => _buildPoint(e, Icons.cancel, Colors.red)),
        ],
      ),
    );
  }

  Widget _buildPoint(String text, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}
