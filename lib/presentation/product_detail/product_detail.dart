import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/product_bottom_bar_widget.dart';
import './widgets/product_image_gallery_widget.dart';
import './widgets/product_info_header_widget.dart';
import './widgets/product_tabs_widget.dart';

/// Product Detail Screen
/// Provides comprehensive technical information for industrial adhesive products
/// Implements professional minimalism with clear hierarchy for industrial users
class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _quantity = 1;
  bool _isWishlisted = false;
  int _currentImageIndex = 0;

  // Mock product data
  final Map<String, dynamic> _productData = {
    "id": "HAC-001",
    "name": "DISOLVENTE HACSA NF",
    "brand": "HACSA",
    "category": "Disolventes",
    "price": 35.50,
    "currency": "S/.",
    "unit": "por unidad",
    "isAuthentic": true,
    "inStock": true,
    "stockCount": 210,
    "rating": 4.8,
    "reviewCount": 156,
    "images": [
      {
        "url": "https://hacsa.com.pe/wp-content/uploads/2024/12/disol1.png",
        "semanticLabel": "Imagen principal del producto"
      },
      {
        "url": "https://hacsa.com.pe/wp-content/uploads/2024/12/disol2.png",
        "semanticLabel": "Vista secundaria del producto"
      },
      {
        "url": "https://hacsa.com.pe/wp-content/uploads/2024/12/disol3.png",
        "semanticLabel": "Aplicación del disolvente HACSA NF"
      },
      {
        "url": "https://hacsa.com.pe/wp-content/uploads/2024/12/disol4.png",
        "semanticLabel": "Detalles del empaque y seguridad"
      }
    ],
    "shortDescription":
        "Disolvente profesional HACSA NF ideal para limpieza, desengrase y preparación de superficies industriales.",
    "bulkPricing": [
      {"quantity": "1-9 unidades", "price": "S/ 35.50", "discount": ""},
      {
        "quantity": "10-49 unidades",
        "price": "S/ 31.90",
        "discount": "10% descuento"
      },
      {
        "quantity": "50+ unidades",
        "price": "S/ 28.40",
        "discount": "20% descuento"
      },
    ],
    "specifications": {
      "Tipo": "Disolvente industrial",
      "Base": "Solvente orgánico refinado",
      "Evaporación": "Media",
      "Aroma": "Bajo olor",
      "Uso recomendado": "Limpieza y preparación de superficies",
      "Temperatura de almacenamiento": "5°C - 35°C",
      "Contenido": "1 litro",
      "Color": "Transparente",
      "Vida útil": "36 meses"
    },
    "applications": [
      "Limpieza de herramientas",
      "Remoción de residuos de adhesivo",
      "Preparación de superficies antes de pintar",
      "Desengrase industrial",
      "Dilución de ciertos recubrimientos"
    ],
    "features": [
      "Evaporación controlada",
      "Bajo olor para ambientes cerrados",
      "Compatibilidad con múltiples materiales",
      "No deja residuos",
      "Mayor rendimiento gracias a su pureza"
    ],
    "technicalDocs": [
      {"name": "Ficha Técnica", "size": "1.9 MB", "type": "PDF"},
      {"name": "Hoja de Seguridad", "size": "1.3 MB", "type": "PDF"},
    ],
    "reviews": [
      {
        "id": 1,
        "userName": "Luis Fernandez",
        "userAvatar": "",
        "semanticLabel": "Foto de usuario",
        "rating": 5.0,
        "date": "2025-11-10",
        "comment":
            "Excelente disolvente, rinde muchísimo y no deja residuos. Lo usamos en el taller a diario.",
        "verified": true,
        "helpful": 38
      },
      {
        "id": 2,
        "userName": "Ana Torres",
        "userAvatar": "",
        "semanticLabel": "Foto de usuario",
        "rating": 4.5,
        "date": "2025-11-02",
        "comment":
            "Muy buen producto. El olor es mínimo comparado con otros disolventes.",
        "verified": true,
        "helpful": 21
      }
    ],
    "authenticationGuide": {
      "title": "Cómo reconocer producto original HACSA",
      "comparisons": [
        {
          "feature": "Etiqueta y color",
          "original":
              "Etiqueta nítida con logo HACSA y detalles bien impresos.",
          "fake": "Colores lavados o impresión borrosa sin definición.",
          "image": "",
          "semanticLabel": "Comparación etiqueta original vs falsificada"
        },
        {
          "feature": "Tapa de seguridad",
          "original": "Tapa hermética con sellado de fábrica.",
          "fake": "Tapa suelta o sin sello de seguridad.",
          "image": "",
          "semanticLabel": "Comparación de tapa original vs imitación"
        },
        {
          "feature": "Código de lote",
          "original": "Código impreso en tinta indeleble con fecha visible.",
          "fake": "Código borroso o sin fecha de fabricación.",
          "image": "",
          "semanticLabel": "Comparación de códigos de lote"
        }
      ],
      "verificationSteps": [
        "Revisa el estado de la tapa y sello de seguridad.",
        "Verifica que la etiqueta tenga colores firmes y sin borrones.",
        "Confirma el código de lote y fecha de fabricación.",
        "Compara el envase con la referencia oficial HACSA.",
      ]
    },
    "relatedProducts": [
      {
        "id": "HAC-002",
        "name": "GRASS SINTÉTICO",
        "price": 42.00,
        "image": "",
        "semanticLabel": "Producto relacionado GRASS SINTÉTICO",
        "rating": 4.7
      },
      {
        "id": "HAC-003",
        "name": "UNITUB NARANJA",
        "price": 55.00,
        "image": "",
        "semanticLabel": "Producto relacionado UNITUB NARANJA",
        "rating": 4.8
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _toggleWishlist() {
    HapticFeedback.lightImpact();
    setState(() {
      _isWishlisted = !_isWishlisted;
    });

    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isWishlisted ? 'Agregado a favoritos' : 'Eliminado de favoritos',
          style: theme.snackBarTheme.contentTextStyle,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToCart() {
    HapticFeedback.mediumImpact();
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_quantity ${_quantity == 1 ? 'unidad agregada' : 'unidades agregadas'} al carrito',
          style: theme.snackBarTheme.contentTextStyle,
        ),
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () {
            Navigator.pushNamed(context, '/product-catalog');
          },
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareProduct() {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);

    // Show share options
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Compartir producto',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Compartir especificaciones técnicas',
                  style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Especificaciones técnicas compartidas',
                      style: theme.snackBarTheme.contentTextStyle,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _verifyAuthenticity() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/qr-scanner');
  }

  void _onImageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.detail(
        title: _productData["category"] as String,
        actions: [
          CustomAppBarActions.cart(
            context,
            () => Navigator.pushNamed(context, '/product-catalog'),
            itemCount: 3,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: _shareProduct,
            tooltip: 'Compartir',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery
                ProductImageGalleryWidget(
                  images: (_productData["images"] as List)
                      .cast<Map<String, dynamic>>(),
                  onImageChanged: _onImageChanged,
                ),

                // Product Info Header
                ProductInfoHeaderWidget(
                  productData: _productData,
                  isWishlisted: _isWishlisted,
                  onWishlistToggle: _toggleWishlist,
                ),

                // Verify Authenticity Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _verifyAuthenticity,
                      icon: CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text('Verificar Autenticidad'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                    ),
                  ),
                ),

                // Product Tabs
                ProductTabsWidget(
                  tabController: _tabController,
                  productData: _productData,
                ),

                // Bottom spacing for fixed bottom bar
                SizedBox(height: 10.h),
              ],
            ),
          ),

          // Fixed Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProductBottomBarWidget(
              quantity: _quantity,
              onIncrement: _incrementQuantity,
              onDecrement: _decrementQuantity,
              onAddToCart: _addToCart,
              isWishlisted: _isWishlisted,
              onWishlistToggle: _toggleWishlist,
            ),
          ),
        ],
      ),
    );
  }
}
