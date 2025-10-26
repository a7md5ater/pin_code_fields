import 'package:flutter/material.dart';

enum FeatureCategory {
  keyboard,
  shapes,
  styling,
  animations,
  validation,
  visual,
  cursor,
  advanced;

  String get label {
    switch (this) {
      case FeatureCategory.keyboard:
        return 'Keyboard & Focus';
      case FeatureCategory.shapes:
        return 'Shapes';
      case FeatureCategory.styling:
        return 'Styling & Colors';
      case FeatureCategory.animations:
        return 'Animations';
      case FeatureCategory.validation:
        return 'Validation';
      case FeatureCategory.visual:
        return 'Visual Effects';
      case FeatureCategory.cursor:
        return 'Cursor';
      case FeatureCategory.advanced:
        return 'Advanced';
    }
  }

  IconData get icon {
    switch (this) {
      case FeatureCategory.keyboard:
        return Icons.keyboard;
      case FeatureCategory.shapes:
        return Icons.crop_square;
      case FeatureCategory.styling:
        return Icons.palette;
      case FeatureCategory.animations:
        return Icons.animation;
      case FeatureCategory.validation:
        return Icons.check_circle;
      case FeatureCategory.visual:
        return Icons.visibility;
      case FeatureCategory.cursor:
        return Icons.height;
      case FeatureCategory.advanced:
        return Icons.settings;
    }
  }

  String get description {
    switch (this) {
      case FeatureCategory.keyboard:
        return 'Keyboard behavior, auto-focus, auto-dismiss, and tap-to-focus functionality';
      case FeatureCategory.shapes:
        return 'Box, underline, and circle shapes with different configurations';
      case FeatureCategory.styling:
        return 'Colors, borders, fills, and shadows for all states';
      case FeatureCategory.animations:
        return 'Text entry animations: fade, scale, slide, and none';
      case FeatureCategory.validation:
        return 'Form validation, error handling, and input formatting';
      case FeatureCategory.visual:
        return 'Text gradients, obscuring, hints, and visual customizations';
      case FeatureCategory.cursor:
        return 'Cursor appearance, animation, and behavior';
      case FeatureCategory.advanced:
        return 'Context menu, haptic feedback, and advanced features';
    }
  }
}
