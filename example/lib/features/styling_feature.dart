import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';
import '../widgets/property_toggle.dart';

class StylingFeature extends StatefulWidget {
  const StylingFeature({super.key});

  @override
  State<StylingFeature> createState() => _StylingFeatureState();
}

class _StylingFeatureState extends State<StylingFeature> {
  final _fillController = TextEditingController();
  bool _enableFill = true;

  final _borderController = TextEditingController();
  double _borderWidth = 2.0;

  final _shadowController = TextEditingController();

  @override
  void dispose() {
    _fillController.dispose();
    _borderController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFillColors(),
        const SizedBox(height: 32),
        _buildBorderStyling(),
        const SizedBox(height: 32),
        _buildBoxShadows(),
      ],
    );
  }

  Widget _buildFillColors() {
    return DemoSection(
      title: '1. Fill Colors',
      description: 'Different fill colors for active, selected, and inactive states',
      demo: PinCodeTextField(
        key: ValueKey('fill-$_enableFill'),
        length: 6,
        controller: _fillController,
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
        enableActiveFill: _enableFill,
        keyboardType: TextInputType.number,
      ),
      controls: [
        PropertyToggle(
          label: 'Enable Fill',
          value: _enableFill,
          onChanged: (value) => setState(() {
            _enableFill = value;
            _fillController.clear();
          }),
        ),
      ],
      code: '''PinCodeTextField(
  enableActiveFill: $_enableFill,
  pinTheme: PinTheme(
    activeFillColor: Colors.blue.shade50,
    selectedFillColor: Colors.purple.shade50,
    inactiveFillColor: Colors.grey.shade100,
    activeColor: Colors.blue,
    selectedColor: Colors.purple,
    inactiveColor: Colors.grey,
  ),
)''',
    );
  }

  Widget _buildBorderStyling() {
    return DemoSection(
      title: '2. Border Styling',
      description: 'Customize border width and colors for different states',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('border-$_borderWidth'),
            length: 6,
            controller: _borderController,
            onChanged: (value) {},
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 55,
              fieldWidth: 50,
              activeColor: Colors.green,
              selectedColor: Colors.orange,
              inactiveColor: Colors.grey.shade400,
              errorBorderColor: Colors.red,
              activeBorderWidth: _borderWidth,
              selectedBorderWidth: _borderWidth,
              inactiveBorderWidth: _borderWidth / 2,
              errorBorderWidth: _borderWidth * 1.5,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Border Width: '),
              Expanded(
                child: Slider(
                  value: _borderWidth,
                  min: 1.0,
                  max: 5.0,
                  divisions: 8,
                  label: _borderWidth.toStringAsFixed(1),
                  onChanged: (value) => setState(() {
                    _borderWidth = value;
                    _borderController.clear();
                  }),
                ),
              ),
              Text(_borderWidth.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
      controls: const [],
      code: '''PinCodeTextField(
  pinTheme: PinTheme(
    // Border colors
    activeColor: Colors.green,
    selectedColor: Colors.orange,
    inactiveColor: Colors.grey,
    errorBorderColor: Colors.red,

    // Border widths
    activeBorderWidth: ${_borderWidth.toStringAsFixed(1)},
    selectedBorderWidth: ${_borderWidth.toStringAsFixed(1)},
    inactiveBorderWidth: ${(_borderWidth / 2).toStringAsFixed(1)},
    errorBorderWidth: ${(_borderWidth * 1.5).toStringAsFixed(1)},
  ),
)''',
    );
  }

  Widget _buildBoxShadows() {
    return DemoSection(
      title: '3. Box Shadows',
      description: 'Add depth with box shadows on active and inactive cells',
      demo: PinCodeTextField(
        length: 6,
        controller: _shadowController,
        onChanged: (value) {},
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 55,
          fieldWidth: 50,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.blue.shade50,
          inactiveFillColor: Colors.grey.shade50,
          activeColor: Colors.blue,
          selectedColor: Colors.blue.shade700,
          inactiveColor: Colors.grey.shade300,
          borderWidth: 1,
          activeBoxShadows: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          inActiveBoxShadows: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
      ),
      controls: const [],
      code: '''PinCodeTextField(
  pinTheme: PinTheme(
    activeBoxShadows: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.3),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
    inActiveBoxShadows: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  ),
)''',
    );
  }
}
