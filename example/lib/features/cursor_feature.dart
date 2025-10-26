import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';
import '../widgets/property_toggle.dart';

class CursorFeature extends StatefulWidget {
  const CursorFeature({super.key});

  @override
  State<CursorFeature> createState() => _CursorFeatureState();
}

class _CursorFeatureState extends State<CursorFeature> {
  final _appearanceController = TextEditingController();
  bool _showCursor = true;
  double _cursorWidth = 2.0;
  double _cursorHeight = 24.0;

  final _animationController = TextEditingController();
  bool _animateCursor = true;

  @override
  void dispose() {
    _appearanceController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCursorAppearance(),
        const SizedBox(height: 32),
        _buildCursorAnimation(),
      ],
    );
  }

  Widget _buildCursorAppearance() {
    return DemoSection(
      title: '1. Cursor Appearance',
      description: 'Customize cursor visibility, color, width, and height',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('cursor-$_showCursor-$_cursorWidth-$_cursorHeight'),
            length: 6,
            controller: _appearanceController,
            onChanged: (value) {},
            showCursor: _showCursor,
            cursorColor: Colors.orange,
            cursorWidth: _cursorWidth,
            cursorHeight: _cursorHeight,
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
          Row(
            children: [
              const Text('Width: '),
              Expanded(
                child: Slider(
                  value: _cursorWidth,
                  min: 1.0,
                  max: 5.0,
                  divisions: 8,
                  label: _cursorWidth.toStringAsFixed(1),
                  onChanged: (value) => setState(() {
                    _cursorWidth = value;
                    _appearanceController.clear();
                  }),
                ),
              ),
              Text(_cursorWidth.toStringAsFixed(1)),
            ],
          ),
          Row(
            children: [
              const Text('Height: '),
              Expanded(
                child: Slider(
                  value: _cursorHeight,
                  min: 16.0,
                  max: 40.0,
                  divisions: 12,
                  label: _cursorHeight.toStringAsFixed(0),
                  onChanged: (value) => setState(() {
                    _cursorHeight = value;
                    _appearanceController.clear();
                  }),
                ),
              ),
              Text(_cursorHeight.toStringAsFixed(0)),
            ],
          ),
        ],
      ),
      controls: [
        PropertyToggle(
          label: 'Show Cursor',
          value: _showCursor,
          onChanged: (value) => setState(() {
            _showCursor = value;
            _appearanceController.clear();
          }),
        ),
      ],
      code: '''PinCodeTextField(
  showCursor: $_showCursor,
  cursorColor: Colors.orange,
  cursorWidth: ${_cursorWidth.toStringAsFixed(1)},
  cursorHeight: ${_cursorHeight.toStringAsFixed(0)},
)''',
    );
  }

  Widget _buildCursorAnimation() {
    return DemoSection(
      title: '2. Cursor Animation',
      description: 'Enable blinking cursor animation for better UX',
      demo: PinCodeTextField(
        key: ValueKey('anim-cursor-$_animateCursor'),
        length: 6,
        controller: _animationController,
        onChanged: (value) {},
        showCursor: true,
        cursorColor: Theme.of(context).colorScheme.primary,
        cursorWidth: 2,
        cursorHeight: 24,
        animateCursor: _animateCursor,
        cursorBlinkDuration: const Duration(milliseconds: 800),
        cursorBlinkCurve: Curves.easeInOut,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: 60,
          fieldWidth: 50,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.outline,
          borderWidth: 2,
        ),
        keyboardType: TextInputType.number,
      ),
      controls: [
        PropertyToggle(
          label: 'Animate Cursor',
          value: _animateCursor,
          onChanged: (value) => setState(() {
            _animateCursor = value;
            _animationController.clear();
          }),
        ),
      ],
      code: '''PinCodeTextField(
  showCursor: true,
  animateCursor: $_animateCursor,
  cursorBlinkDuration: Duration(milliseconds: 800),
  cursorBlinkCurve: Curves.easeInOut,
)''',
    );
  }
}
