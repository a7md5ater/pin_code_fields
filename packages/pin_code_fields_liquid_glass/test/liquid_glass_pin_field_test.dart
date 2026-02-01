import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields_liquid_glass/pin_code_fields_liquid_glass.dart';

void main() {
  group('LiquidGlassPinTheme', () {
    test('separate() creates SeparateGlassTheme', () {
      final theme = LiquidGlassPinTheme.separate();
      expect(theme, isA<SeparateGlassTheme>());
    });

    test('unified() creates UnifiedGlassTheme', () {
      final theme = LiquidGlassPinTheme.unified();
      expect(theme, isA<UnifiedGlassTheme>());
    });

    test('blended() creates BlendedGlassTheme', () {
      final theme = LiquidGlassPinTheme.blended();
      expect(theme, isA<BlendedGlassTheme>());
    });

    test('default values are set correctly', () {
      final theme = LiquidGlassPinTheme.separate();
      expect(theme.cellSize, const Size(56, 64));
      expect(theme.blur, 10);
      expect(theme.thickness, 20);
      expect(theme.visibility, 1.0);
      expect(theme.chromaticAberration, 0.01);
      expect(theme.lightIntensity, 0.5);
      expect(theme.ambientStrength, 0);
      expect(theme.refractiveIndex, 1.2);
      expect(theme.saturation, 1.5);
      expect(theme.glowRadius, 1.0);
      expect(theme.enableGlowOnFocus, true);
      expect(theme.enableStretchAnimation, true);
      expect(theme.stretchInteractionScale, 1.05);
      expect(theme.stretchAmount, 0.5);
      expect(theme.stretchResistance, 0.08);
      expect(theme.showCursor, true);
    });

    test('SeparateGlassTheme has correct defaults', () {
      final theme = LiquidGlassPinTheme.separate();
      expect(theme.spacing, 8);
      expect(theme.borderRadius, 12);
      expect(theme.glowPerCell, true);
    });

    test('UnifiedGlassTheme has correct defaults', () {
      final theme = LiquidGlassPinTheme.unified();
      expect(theme.dividerWidth, 1);
      expect(theme.containerBorderRadius, 16);
      expect(theme.containerPadding, const EdgeInsets.symmetric(horizontal: 4));
    });

    test('BlendedGlassTheme has correct defaults', () {
      final theme = LiquidGlassPinTheme.blended();
      expect(theme.blendAmount, 0.3);
      expect(theme.borderRadius, 12);
      expect(theme.overlapOffset, 0);
    });

    test('custom values are preserved', () {
      final theme = LiquidGlassPinTheme.separate(
        cellSize: const Size(48, 56),
        blur: 15,
        thickness: 25,
        visibility: 0.8,
        chromaticAberration: 0.05,
        lightIntensity: 0.7,
        ambientStrength: 0.2,
        refractiveIndex: 1.5,
        saturation: 2.0,
        glowRadius: 2.0,
        enableGlowOnFocus: false,
        enableStretchAnimation: false,
        stretchInteractionScale: 1.1,
        stretchAmount: 0.8,
        stretchResistance: 0.1,
        showCursor: false,
        spacing: 12,
        borderRadius: 16,
        glowPerCell: false,
      );

      expect(theme.cellSize, const Size(48, 56));
      expect(theme.blur, 15);
      expect(theme.thickness, 25);
      expect(theme.visibility, 0.8);
      expect(theme.chromaticAberration, 0.05);
      expect(theme.lightIntensity, 0.7);
      expect(theme.ambientStrength, 0.2);
      expect(theme.refractiveIndex, 1.5);
      expect(theme.saturation, 2.0);
      expect(theme.glowRadius, 2.0);
      expect(theme.enableGlowOnFocus, false);
      expect(theme.enableStretchAnimation, false);
      expect(theme.stretchInteractionScale, 1.1);
      expect(theme.stretchAmount, 0.8);
      expect(theme.stretchResistance, 0.1);
      expect(theme.showCursor, false);

      expect(theme.spacing, 12);
      expect(theme.borderRadius, 16);
      expect(theme.glowPerCell, false);
    });
  });

  group('LiquidGlassPinFormField', () {
    test('is exported and accessible', () {
      // Just verify the class is accessible (widget test would need full setup)
      expect(LiquidGlassPinFormField, isNotNull);
    });
  });

  group('PinInputController re-export', () {
    test('PinInputController is accessible', () {
      final controller = PinInputController();
      expect(controller, isNotNull);
      expect(controller.text, '');
      controller.dispose();
    });

    test('PinInputController text operations work', () {
      final controller = PinInputController();
      controller.setText('1234');
      expect(controller.text, '1234');
      controller.clear();
      expect(controller.text, '');
      controller.dispose();
    });
  });
}
