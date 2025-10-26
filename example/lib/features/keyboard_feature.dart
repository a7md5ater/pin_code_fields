import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';
import '../widgets/property_toggle.dart';

class KeyboardFeature extends StatefulWidget {
  const KeyboardFeature({super.key});

  @override
  State<KeyboardFeature> createState() => _KeyboardFeatureState();
}

class _KeyboardFeatureState extends State<KeyboardFeature> {
  // Demo 1: Tap to Focus
  final _tapToFocusController = TextEditingController();
  bool _tapToFocusAutoFocus = false;
  bool _tapToFocusReadOnly = false;

  // Demo 2: Auto Dismiss
  final _autoDismissController = TextEditingController();
  bool _autoDismiss = true;
  bool _autoDismissAutoFocus = false;

  // Demo 3: Keyboard Types
  final _keyboardTypeController = TextEditingController();
  TextInputType _selectedKeyboardType = TextInputType.number;

  // Demo 4: Read Only
  final _readOnlyController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _tapToFocusController.dispose();
    _autoDismissController.dispose();
    _keyboardTypeController.dispose();
    _readOnlyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTapToFocusDemo(),
        const SizedBox(height: 32),
        _buildAutoDismissDemo(),
        const SizedBox(height: 32),
        _buildKeyboardTypesDemo(),
        const SizedBox(height: 32),
        _buildReadOnlyDemo(),
      ],
    );
  }

  Widget _buildTapToFocusDemo() {
    return DemoSection(
      title: '1. Tap to Focus (NEW!)',
      description: 'Tap anywhere on the PIN field to open the keyboard. This is a newly fixed feature!',
      badge: 'FIXED',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('tap-to-focus-$_tapToFocusAutoFocus-$_tapToFocusReadOnly'),
            length: 6,
            controller: _tapToFocusController,
            autoFocus: _tapToFocusAutoFocus,
            readOnly: _tapToFocusReadOnly,
            onChanged: (value) {},
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('onTap callback triggered!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50,
              fieldWidth: 45,
              activeFillColor: Theme.of(context).colorScheme.primaryContainer,
              selectedFillColor: Theme.of(context).colorScheme.secondaryContainer,
              inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              activeColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.outline,
            ),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Text(
            _tapToFocusReadOnly
                ? '🔒 Read-only mode: Keyboard won\'t open'
                : '✅ Tap the field above to open the keyboard',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      controls: [
        PropertyToggle(
          label: 'Auto Focus',
          value: _tapToFocusAutoFocus,
          onChanged: (value) => setState(() {
            _tapToFocusAutoFocus = value;
            _tapToFocusController.clear();
          }),
        ),
        PropertyToggle(
          label: 'Read Only',
          value: _tapToFocusReadOnly,
          onChanged: (value) => setState(() => _tapToFocusReadOnly = value),
        ),
      ],
      code: '''PinCodeTextField(
  length: 6,
  autoFocus: $_tapToFocusAutoFocus,
  readOnly: $_tapToFocusReadOnly,
  onTap: () {
    print('Field tapped!');
  },
  // Tap anywhere to focus and open keyboard
  onChanged: (value) {},
)''',
    );
  }

  Widget _buildAutoDismissDemo() {
    return DemoSection(
      title: '2. Auto Dismiss Keyboard',
      description: 'Control whether the keyboard dismisses automatically when the PIN is complete',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('auto-dismiss-$_autoDismiss-$_autoDismissAutoFocus'),
            length: 6,
            controller: _autoDismissController,
            autoFocus: _autoDismissAutoFocus,
            autoDismissKeyboard: _autoDismiss,
            onChanged: (value) {},
            onCompleted: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _autoDismiss
                        ? 'PIN complete! Keyboard auto-dismissed ✓'
                        : 'PIN complete! Keyboard stays open',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: 50,
              fieldWidth: 45,
              activeColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.outline,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Text(
            _autoDismiss
                ? '✅ Keyboard will dismiss when all 6 digits are entered'
                : '⚠️ Keyboard will stay open after completion',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      controls: [
        PropertyToggle(
          label: 'Auto Dismiss on Complete',
          value: _autoDismiss,
          onChanged: (value) => setState(() {
            _autoDismiss = value;
            _autoDismissController.clear();
          }),
        ),
        PropertyToggle(
          label: 'Auto Focus',
          value: _autoDismissAutoFocus,
          onChanged: (value) => setState(() {
            _autoDismissAutoFocus = value;
            _autoDismissController.clear();
          }),
        ),
      ],
      code: '''PinCodeTextField(
  length: 6,
  autoFocus: $_autoDismissAutoFocus,
  autoDismissKeyboard: $_autoDismiss,
  onCompleted: (value) {
    print('PIN complete: \$value');
    ${_autoDismiss ? '// Keyboard auto-dismisses' : '// Keyboard stays open'}
  },
)''',
    );
  }

  Widget _buildKeyboardTypesDemo() {
    final keyboardTypes = {
      TextInputType.number: 'Number',
      TextInputType.text: 'Text',
      TextInputType.visiblePassword: 'Visible Password',
      TextInputType.phone: 'Phone',
    };

    return DemoSection(
      title: '3. Keyboard Types',
      description: 'Choose the appropriate keyboard type for your PIN input',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('keyboard-type-${_selectedKeyboardType.toString()}'),
            length: 6,
            controller: _keyboardTypeController,
            keyboardType: _selectedKeyboardType,
            onChanged: (value) {},
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              fieldHeight: 50,
              fieldWidth: 50,
              activeFillColor: Theme.of(context).colorScheme.primaryContainer,
              selectedFillColor: Theme.of(context).colorScheme.secondaryContainer,
              inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              activeColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.outline,
            ),
            enableActiveFill: true,
          ),
          const SizedBox(height: 16),
          SegmentedButton<TextInputType>(
            segments: keyboardTypes.entries.map((entry) {
              return ButtonSegment<TextInputType>(
                value: entry.key,
                label: Text(entry.value),
              );
            }).toList(),
            selected: {_selectedKeyboardType},
            onSelectionChanged: (Set<TextInputType> newSelection) {
              setState(() {
                _selectedKeyboardType = newSelection.first;
                _keyboardTypeController.clear();
              });
            },
          ),
        ],
      ),
      controls: [],
      code: '''PinCodeTextField(
  length: 6,
  keyboardType: TextInputType.${_selectedKeyboardType.toString().split('.').last},
  // Opens ${keyboardTypes[_selectedKeyboardType]} keyboard
)''',
    );
  }

  Widget _buildReadOnlyDemo() {
    return DemoSection(
      title: '4. Read-Only Mode',
      description: 'Display PIN without allowing edits. Keyboard won\'t open.',
      demo: Column(
        children: [
          PinCodeTextField(
            length: 6,
            controller: _readOnlyController,
            readOnly: true,
            onChanged: (value) {},
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50,
              fieldWidth: 45,
              activeFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              selectedFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              inactiveFillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              activeColor: Theme.of(context).colorScheme.outline,
              selectedColor: Theme.of(context).colorScheme.outline,
              inactiveColor: Theme.of(context).colorScheme.outline,
            ),
            enableActiveFill: true,
            showCursor: false,
          ),
          const SizedBox(height: 16),
          Text(
            '🔒 This field is read-only and cannot be edited',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      controls: [],
      code: '''PinCodeTextField(
  length: 6,
  readOnly: true,
  controller: TextEditingController(text: '123456'),
  showCursor: false,
  // Tapping won't open keyboard
)''',
    );
  }
}
