import 'package:flutter/material.dart';
import '../features/feature_category.dart';
import '../features/keyboard_feature.dart';
import '../features/shapes_feature.dart';
import '../features/styling_feature.dart';
import '../features/animations_feature.dart';
import '../features/validation_feature.dart';
import '../features/visual_feature.dart';
import '../features/cursor_feature.dart';
import '../features/advanced_feature.dart';

class FeatureShowcase extends StatelessWidget {
  final FeatureCategory category;

  const FeatureShowcase({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final widget = switch (category) {
      FeatureCategory.keyboard => const KeyboardFeature(),
      FeatureCategory.shapes => const ShapesFeature(),
      FeatureCategory.styling => const StylingFeature(),
      FeatureCategory.animations => const AnimationsFeature(),
      FeatureCategory.validation => const ValidationFeature(),
      FeatureCategory.visual => const VisualFeature(),
      FeatureCategory.cursor => const CursorFeature(),
      FeatureCategory.advanced => const AdvancedFeature(),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryHeader(category: category),
          const SizedBox(height: 24),
          widget,
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final FeatureCategory category;

  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              category.icon,
              size: 32,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.label,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
