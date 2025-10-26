import 'package:flutter/material.dart';
import '../features/feature_category.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/feature_showcase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FeatureCategory _selectedCategory = FeatureCategory.keyboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin Code Fields'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'View on GitHub',
            onPressed: () {
              // TODO: Open GitHub link
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildCategoryTabs(),
        Expanded(
          child: FeatureShowcase(category: _selectedCategory),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        _buildCategorySidebar(),
        Expanded(
          child: FeatureShowcase(category: _selectedCategory),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildCategorySidebar(),
        Expanded(
          child: FeatureShowcase(category: _selectedCategory),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: FeatureCategory.values.map((category) {
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(category.label),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategorySidebar() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Features',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...FeatureCategory.values.map((category) {
            final isSelected = category == _selectedCategory;
            return ListTile(
              leading: Icon(
                category.icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              title: Text(
                category.label,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
            );
          }),
        ],
      ),
    );
  }
}
