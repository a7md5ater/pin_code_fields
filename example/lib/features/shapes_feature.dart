import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';

class ShapesFeature extends StatefulWidget {
  const ShapesFeature({super.key});

  @override
  State<ShapesFeature> createState() => _ShapesFeatureState();
}

class _ShapesFeatureState extends State<ShapesFeature> {
  final _boxController = TextEditingController();
  final _underlineController = TextEditingController();
  final _circleController = TextEditingController();

  @override
  void dispose() {
    _boxController.dispose();
    _underlineController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBoxShape(),
        const SizedBox(height: 32),
        _buildUnderlineShape(),
        const SizedBox(height: 32),
        _buildCircleShape(),
      ],
    );
  }

  Widget _buildBoxShape() {
    return DemoSection(
      title: '1. Box Shape',
      description: 'Classic rectangular PIN fields with rounded corners',
      demo: PinCodeTextField(
        length: 6,
        controller: _boxController,
        onChanged: (value) {},
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 55,
          fieldWidth: 50,
          activeFillColor: Theme.of(context).colorScheme.primaryContainer,
          selectedFillColor: Theme.of(context).colorScheme.secondaryContainer,
          inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.outline,
          borderWidth: 2,
        ),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
      ),
      controls: const [],
      code: '''PinCodeTextField(
  length: 6,
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(12),
    fieldHeight: 55,
    fieldWidth: 50,
    borderWidth: 2,
  ),
  enableActiveFill: true,
)''',
    );
  }

  Widget _buildUnderlineShape() {
    return DemoSection(
      title: '2. Underline Shape',
      description: 'Minimalist underline style, perfect for modern designs',
      demo: PinCodeTextField(
        length: 6,
        controller: _underlineController,
        onChanged: (value) {},
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 60,
          fieldWidth: 50,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          borderWidth: 3,
        ),
        keyboardType: TextInputType.number,
        animationType: AnimationType.slide,
      ),
      controls: const [],
      code: '''PinCodeTextField(
  length: 6,
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.underline,
    fieldHeight: 60,
    fieldWidth: 50,
    borderWidth: 3,
  ),
  animationType: AnimationType.slide,
)''',
    );
  }

  Widget _buildCircleShape() {
    return DemoSection(
      title: '3. Circle Shape',
      description: 'Circular PIN fields for a unique, playful look',
      demo: PinCodeTextField(
        length: 6,
        controller: _circleController,
        onChanged: (value) {},
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle,
          fieldHeight: 60,
          fieldWidth: 60,
          activeFillColor: Theme.of(context).colorScheme.primaryContainer,
          selectedFillColor: Theme.of(context).colorScheme.secondaryContainer,
          inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.outline,
          borderWidth: 2,
        ),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        animationType: AnimationType.scale,
      ),
      controls: const [],
      code: '''PinCodeTextField(
  length: 6,
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.circle,
    fieldHeight: 60,
    fieldWidth: 60,
  ),
  enableActiveFill: true,
  animationType: AnimationType.scale,
)''',
    );
  }
}
