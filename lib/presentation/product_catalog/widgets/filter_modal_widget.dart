import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterModalWidget extends StatefulWidget {
  final List<String> activeFilters;
  final Function(List<String>) onApplyFilters;

  const FilterModalWidget({
    super.key,
    required this.activeFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late List<String> _selectedFilters;
  String? _expandedSection;

  final Map<String, List<String>> _filterOptions = {
    'Tipo de Producto': ['Estructural', 'Industrial', 'Automotriz'],
    'Aplicación': ['Construcción', 'Manufactura', 'Automotriz', 'Electrónica'],
    'Marca': [
      'AdhesivePro',
      'AutoBond',
      'EpoxiTech',
      'QuickBond',
      'FlexiPro',
      'MetalBond'
    ],
    'Rango de Precio': [
      'Menos de \$200',
      '\$200 - \$300',
      '\$300 - \$400',
      'Más de \$400'
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.activeFilters);
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _selectedFilters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros',
                  style: theme.textTheme.titleLarge,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text('Limpiar Todo'),
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'close',
                        size: 24,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _filterOptions.entries.map((entry) {
                return _buildFilterSection(
                  title: entry.key,
                  options: entry.value,
                  theme: theme,
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApplyFilters(_selectedFilters);
                        Navigator.pop(context);
                      },
                      child: Text('Aplicar (${_selectedFilters.length})'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required ThemeData theme,
  }) {
    final isExpanded = _expandedSection == title;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSection = isExpanded ? null : title;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    size: 24,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: options.map((option) {
                  final isSelected = _selectedFilters.contains(option);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) => _toggleFilter(option),
                    title: Text(
                      option,
                      style: theme.textTheme.bodyMedium,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
