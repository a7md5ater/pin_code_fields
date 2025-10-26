import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';
import '../widgets/property_toggle.dart';

class VisualFeature extends StatefulWidget {
  const VisualFeature({super.key});

  @override
  State<VisualFeature> createState() => _VisualFeatureState();
}

class _VisualFeatureState extends State<VisualFeature> {
  final _gradientController = TextEditingController();
  final _obscureController = TextEditingController();
  bool _obscureText = true;
  bool _blinkWhenObscuring = true;
  final _hintController = TextEditingController();

  @override
  void dispose() {
    _gradientController.dispose();
    _obscureController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextGradient(),
        const SizedBox(height: 32),
        _buildObscuring(),
        const SizedBox(height: 32),
        _buildHintCharacter(),
      ],
    );
  }

  Widget _buildTextGradient() {
    return DemoSection(
      title: '1. Text Gradients',
      description: 'Apply beautiful gradients to your PIN text',
      demo: PinCodeTextField(
        length: 6,
        controller: _gradientController,
        onChanged: (value) {},
        textGradient: const LinearGradient(
          colors: [
            Colors.purple,
            Colors.blue,
            Colors.green,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 60,
          fieldWidth: 55,
          activeColor: Colors.purple,
          selectedColor: Colors.blue,
          inactiveColor: Colors.grey.shade400,
          borderWidth: 2,
        ),
        textStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.number,
      ),
      controls: const [],
      code: '''PinCodeTextField(
  textGradient: LinearGradient(
    colors: [
      Colors.purple,
      Colors.blue,
      Colors.green,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  textStyle: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
)''',
    );
  }

  Widget _buildObscuring() {
    return DemoSection(
      title: '2. Text Obscuring',
      description: 'Hide sensitive input with obscuring characters or widgets',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('obscure-$_obscureText-$_blinkWhenObscuring'),
            length: 6,
            controller: _obscureController,
            onChanged: (value) {},
            obscureText: _obscureText,
            obscuringCharacter: '●',
            blinkWhenObscuring: _blinkWhenObscuring,
            blinkDuration: const Duration(milliseconds: 500),
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
          const SizedBox(height: 16),
          Text(
            _blinkWhenObscuring
                ? 'Characters briefly visible before obscuring'
                : 'Characters immediately obscured',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      controls: [
        PropertyToggle(
          label: 'Obscure Text',
          value: _obscureText,
          onChanged: (value) => setState(() {
            _obscureText = value;
            _obscureController.clear();
          }),
        ),
        PropertyToggle(
          label: 'Blink When Obscuring',
          value: _blinkWhenObscuring,
          onChanged: (value) => setState(() {
            _blinkWhenObscuring = value;
            _obscureController.clear();
          }),
        ),
      ],
      code: '''PinCodeTextField(
  obscureText: $_obscureText,
  obscuringCharacter: '●',
  blinkWhenObscuring: $_blinkWhenObscuring,
  blinkDuration: Duration(milliseconds: 500),
)''',
    );
  }

  Widget _buildHintCharacter() {
    return DemoSection(
      title: '3. Hint Characters',
      description: 'Show placeholders in empty cells',
      demo: PinCodeTextField(
        length: 6,
        controller: _hintController,
        onChanged: (value) {},
        hintCharacter: '?',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 60,
          fieldWidth: 50,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          borderWidth: 2,
        ),
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        keyboardType: TextInputType.number,
      ),
      controls: const [],
      code: '''PinCodeTextField(
  hintCharacter: '?',
  hintStyle: TextStyle(
    color: Colors.grey.withOpacity(0.5),
    fontSize: 24,
    fontWeight: FontWeight.w300,
  ),
  textStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)''',
    );
  }
}
