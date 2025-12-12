import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({super.key});

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _selectedSort = 'Relevancia';
  List<String> _activeFilters = ['Estructural', 'Industrial'];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  // Mock product data
  final List<Map<String, dynamic>> _mockProducts = [
    {
      "id": "HAC-001",
      "name": "DISOLVENTE HACSA NF",
      "category": "Químicos",
      "brand": "Hacsa",
      "price": "\$38.00",
      "rating": 4.7,
      "reviews": 92,
      "specifications": "Disolvente de limpieza | Evaporación controlada",
      "image": "https://hacsa.com.pe/wp-content/uploads/2024/12/disol3.png",
      "semanticLabel": "Envase de disolvente industrial HACSA",
      "isAuthentic": true,
      "inStock": true,
      "application": "Limpieza, Preparación de superficies"
    },
    {
      "id": "HAC-002",
      "name": "GRASS SINTÉTICO",
      "category": "Construcción",
      "brand": "Hacsa",
      "price": "\$120.00",
      "rating": 4.8,
      "reviews": 110,
      "specifications": "Alta durabilidad | Uso interior y exterior",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/PEGAGRASS-1.png",
      "semanticLabel": "Rollo de grass sintético HACSA",
      "isAuthentic": true,
      "inStock": true,
      "application": "Decoración, Áreas verdes"
    },
    {
      "id": "HAC-003",
      "name": "UNITUB NARANJA",
      "category": "Estructural",
      "brand": "Hacsa",
      "price": "\$89.00",
      "rating": 4.6,
      "reviews": 76,
      "specifications": "Alta resistencia | Adhesión industrial",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/UNITUB-NARANJA.png",
      "semanticLabel": "Tubo de adhesivo UNITUB naranjado",
      "isAuthentic": true,
      "inStock": true,
      "application": "Construcción, Metal, Concreto"
    },
    {
      "id": "HAC-004",
      "name": "UNITUB REFORZADO",
      "category": "Estructural",
      "brand": "Hacsa",
      "price": "\$98.00",
      "rating": 4.9,
      "reviews": 150,
      "specifications": "Fórmula reforzada | Mayor flexibilidad",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/UNITUB-REFORZADO.png",
      "semanticLabel": "Tubo reforzado UNITUB",
      "isAuthentic": true,
      "inStock": true,
      "application": "Construcción, Sellado, Reparación"
    },
    {
      "id": "HAC-005",
      "name": "UNITUB",
      "category": "Estructural",
      "brand": "Hacsa",
      "price": "\$75.00",
      "rating": 4.5,
      "reviews": 60,
      "specifications": "Adhesivo estructural multiuso",
      "image": "https://hacsa.com.pe/wp-content/uploads/2024/08/UNITUB.png",
      "semanticLabel": "Tubo de UNITUB estándar",
      "isAuthentic": true,
      "inStock": true,
      "application": "Metal, Plástico, Construcción"
    },
    {
      "id": "HAC-006",
      "name": "SPRAY INDUSTRIAL",
      "category": "Industrial",
      "brand": "Hacsa",
      "price": "\$52.00",
      "rating": 4.7,
      "reviews": 134,
      "specifications": "Secado rápido | Alta fijación",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/SPRAY-INDUSTRIAL-2-1.png",
      "semanticLabel": "Spray adhesivo industrial",
      "isAuthentic": true,
      "inStock": true,
      "application": "Madera, Plástico, Tapicería"
    },
    {
      "id": "HAC-007",
      "name": "COLA PREMIUM",
      "category": "Carpintería",
      "brand": "Hacsa",
      "price": "\$44.00",
      "rating": 4.8,
      "reviews": 121,
      "specifications": "Alta viscosidad | Secado resistente",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/COLA-PREMIUM.png",
      "semanticLabel": "Botella de cola premium",
      "isAuthentic": true,
      "inStock": true,
      "application": "Madera, MDF, Carpintería"
    },
    {
      "id": "HAC-008",
      "name": "SPRAY TAPICERO",
      "category": "Tapicería",
      "brand": "Hacsa",
      "price": "\$49.00",
      "rating": 4.6,
      "reviews": 80,
      "specifications": "Pegado uniforme | No deja residuos",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/SPRAY-TAPICERO-1.png",
      "semanticLabel": "Spray especial para tapicería",
      "isAuthentic": true,
      "inStock": true,
      "application": "Espuma, Tejidos, Tapicería"
    },
    {
      "id": "HAC-009",
      "name": "HACSACHAP",
      "category": "Estructural",
      "brand": "Hacsa",
      "price": "\$58.00",
      "rating": 4.7,
      "reviews": 102,
      "specifications": "Adhesivo para chapas | Alta resistencia",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/HACSACHAP-1.png",
      "semanticLabel": "Envase de adhesivo HACSACHAP",
      "isAuthentic": true,
      "inStock": true,
      "application": "Madera, Chapa, Construcción"
    },
    {
      "id": "HAC-010",
      "name": "PREMIUM GOLD 69",
      "category": "Adhesivos",
      "brand": "Hacsa",
      "price": "\$66.00",
      "rating": 4.9,
      "reviews": 187,
      "specifications": "Fuerte agarre | Resistente al calor",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/PREMIUM-GOLD-1.png",
      "semanticLabel": "Adhesivo Premium Gold 69",
      "isAuthentic": true,
      "inStock": true,
      "application": "Tapicería, Espuma, Alta temperatura"
    },
    {
      "id": "HAC-011",
      "name": "REFORZADO",
      "category": "Estructural",
      "brand": "Hacsa",
      "price": "\$72.00",
      "rating": 4.8,
      "reviews": 140,
      "specifications": "Mayor dureza | Adhesión extrema",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/REFORZADO-2.png",
      "semanticLabel": "Adhesivo reforzado tipo industrial",
      "isAuthentic": true,
      "inStock": true,
      "application": "Construcción, Metal, Reparación"
    },
    {
      "id": "HAC-012",
      "name": "JEBE LÍQUIDO",
      "category": "Selladores",
      "brand": "Hacsa",
      "price": "\$88.00",
      "rating": 4.6,
      "reviews": 99,
      "specifications": "Impermeabilizante | Sellado flexible",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/JEBE-LIQUIDO-2.png",
      "semanticLabel": "Envase de jebe líquido HACSA",
      "isAuthentic": true,
      "inStock": true,
      "application": "Goteras, Sellado, Reparación"
    },
    {
      "id": "HAC-013",
      "name": "ACTIVADOR",
      "category": "Químicos",
      "brand": "Hacsa",
      "price": "\$33.00",
      "rating": 4.5,
      "reviews": 70,
      "specifications": "Acelera curado | Mejora adherencia",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/ACTIVADOR-HACSA-1.png",
      "semanticLabel": "Botella de activador químico",
      "isAuthentic": true,
      "inStock": true,
      "application": "Plástico, Metal, Goma"
    },
    {
      "id": "HAC-014",
      "name": "HALOGENANTE",
      "category": "Químicos",
      "brand": "Hacsa",
      "price": "\$37.00",
      "rating": 4.6,
      "reviews": 88,
      "specifications": "Preparación de superficies antes de pegar",
      "image":
          "https://hacsa.com.pe/wp-content/uploads/2024/08/HALOGENANTE-1.png",
      "semanticLabel": "Frasco de halogenante HACSA",
      "isAuthentic": true,
      "inStock": true,
      "application": "Caucho, PVC, Plástico"
    },
    {
      "id": "HAC-015",
      "name": "UV HAC 04",
      "category": "Automotriz",
      "brand": "Hacsa",
      "price": "\$115.00",
      "rating": 4.8,
      "reviews": 132,
      "specifications": "Curado UV | Transparente | Alta dureza",
      "image": "https://hacsa.com.pe/wp-content/uploads/2024/08/HAC-04-1.png",
      "semanticLabel": "Envase de adhesivo UV HACSA",
      "isAuthentic": true,
      "inStock": true,
      "application": "Vidrio, Plástico, Automotriz"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    setState(() {
      _products = List.from(_mockProducts);
      _applyFilters();
    });
  }

  void _applyFilters() {
    if (_activeFilters.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        return _activeFilters.contains(product['category'] as String);
      }).toList();
    }
    _applySorting();
  }

  void _applySorting() {
    switch (_selectedSort) {
      case 'Precio: Menor a Mayor':
        _filteredProducts.sort((a, b) {
          final priceA = double.parse(
              (a['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          final priceB = double.parse(
              (b['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          return priceA.compareTo(priceB);
        });
        break;
      case 'Precio: Mayor a Menor':
        _filteredProducts.sort((a, b) {
          final priceA = double.parse(
              (a['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          final priceB = double.parse(
              (b['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          return priceB.compareTo(priceA);
        });
        break;
      case 'Calificación Técnica':
        _filteredProducts.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'Más Recientes':
        // Keep original order for newest
        break;
      default:
        // Relevance - keep original order
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    setState(() => _isRefreshing = true);

    await Future.delayed(const Duration(seconds: 1));
    _loadProducts();

    setState(() => _isRefreshing = false);
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
      _applyFilters();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        activeFilters: _activeFilters,
        onApplyFilters: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        selectedSort: _selectedSort,
        onSortSelected: (sort) {
          setState(() {
            _selectedSort = sort;
            _applySorting();
          });
        },
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products.where((product) {
          final name = (product['name'] as String).toLowerCase();
          final category = (product['category'] as String).toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower) || category.contains(searchLower);
        }).toList();
      }
      _applySorting();
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _onProductLongPress(Map<String, dynamic> product) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickActionsSheet(product),
    );
  }

  Widget _buildQuickActionsSheet(Map<String, dynamic> product) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    product['name'] as String,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildQuickAction(
                    icon: 'favorite_border',
                    label: 'Agregar a Favoritos',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agregado a favoritos')),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: 'compare_arrows',
                    label: 'Comparar Producto',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agregado a comparación')),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: 'share',
                    label: 'Compartir Especificaciones',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Compartiendo especificaciones...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.search(
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'filter_list',
                  size: 24,
                  color: theme.appBarTheme.foregroundColor ??
                      theme.colorScheme.onPrimary,
                ),
                onPressed: _showFilterModal,
              ),
              if (_activeFilters.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        _activeFilters.length.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/product-authentication');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'verified',
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Cómo reconocer un producto auténtico vs. falso',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_activeFilters.isNotEmpty)
              Container(
                height: 56,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activeFilters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return FilterChipWidget(
                      label: _activeFilters[index],
                      onRemove: () => _removeFilter(_activeFilters[index]),
                    );
                  },
                ),
              ),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemCount:
                          _filteredProducts.length + (_isLoading ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredProducts.length) {
                          return _buildSkeletonCard();
                        }
                        return ProductCardWidget(
                          product: _filteredProducts[index],
                          onTap: () => _onProductTap(_filteredProducts[index]),
                          onLongPress: () =>
                              _onProductLongPress(_filteredProducts[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSortBottomSheet,
        icon: CustomIconWidget(
          iconName: 'sort',
          size: 24,
          color: theme.colorScheme.onPrimary,
        ),
        label: Text(
          'Ordenar',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBarWithBadge(
        currentIndex: _currentBottomNavIndex,
        badges: {2: 3},
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
          switch (index) {
            case 0:
              // Already on catalog
              break;
            case 1:
              Navigator.pushNamed(context, '/qr-scanner');
              break;
            case 2:
              Navigator.pushNamed(context, '/cart');
              break;
            case 3:
              Navigator.pushNamed(context, '/user-profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No se encontraron productos',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta ajustar los filtros o buscar con otros términos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeFilters.clear();
                  _searchController.clear();
                  _applyFilters();
                });
              },
              child: const Text('Limpiar Filtros'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
