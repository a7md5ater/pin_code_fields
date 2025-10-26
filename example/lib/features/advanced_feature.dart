import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';
import '../widgets/property_toggle.dart';

class AdvancedFeature extends StatefulWidget {
  const AdvancedFeature({super.key});

  @override
  State<AdvancedFeature> createState() => _AdvancedFeatureState();
}

class _AdvancedFeatureState extends State<AdvancedFeature> {
  final _contextMenuController = TextEditingController();
  bool _enableContextMenu = true;

  final _hapticController = TextEditingController();
  HapticFeedbackTypes _hapticType = HapticFeedbackTypes.light;

  final _separatorController = TextEditingController();

  @override
  void dispose() {
    _contextMenuController.dispose();
    _hapticController.dispose();
    _separatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildContextMenu(),
        const SizedBox(height: 32),
        _buildHapticFeedback(),
        const SizedBox(height: 32),
        _buildSeparator(),
      ],
    );
  }

  Widget _buildContextMenu() {
    return DemoSection(
      title: '1. Context Menu (Paste)',
      description: 'Long press to access paste functionality',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('context-$_enableContextMenu'),
            length: 6,
            controller: _contextMenuController,
            onChanged: (value) {},
            enableContextMenu: _enableContextMenu,
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
            _enableContextMenu
                ? '✓ Long press the field to see paste option'
                : '✗ Context menu disabled',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      controls: [
        PropertyToggle(
          label: 'Enable Context Menu',
          value: _enableContextMenu,
          onChanged: (value) => setState(() {
            _enableContextMenu = value;
            _contextMenuController.clear();
          }),
        ),
      ],
      code: '''PinCodeTextField(
  enableContextMenu: $_enableContextMenu,
  // Long press to show paste option
)''',
    );
  }

  Widget _buildHapticFeedback() {
    final hapticTypes = {
      HapticFeedbackTypes.light: 'Light',
      HapticFeedbackTypes.medium: 'Medium',
      HapticFeedbackTypes.heavy: 'Heavy',
      HapticFeedbackTypes.selection: 'Selection',
      HapticFeedbackTypes.vibrate: 'Vibrate',
    };

    return DemoSection(
      title: '2. Haptic Feedback',
      description: 'Tactile feedback on each character entry',
      demo: Column(
        children: [
          PinCodeTextField(
            key: ValueKey('haptic-${_hapticType.toString()}'),
            length: 6,
            controller: _hapticController,
            onChanged: (value) {},
            useHapticFeedback: true,
            hapticFeedbackTypes: _hapticType,
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
          SegmentedButton<HapticFeedbackTypes>(
            segments: hapticTypes.entries.map((entry) {
              return ButtonSegment<HapticFeedbackTypes>(
                value: entry.key,
                label: Text(entry.value),
              );
            }).toList(),
            selected: {_hapticType},
            onSelectionChanged: (Set<HapticFeedbackTypes> newSelection) {
              setState(() {
                _hapticType = newSelection.first;
                _hapticController.clear();
              });
            },
            showSelectedIcon: false,
          ),
        ],
      ),
      controls: const [],
      code: '''PinCodeTextField(
  useHapticFeedback: true,
  hapticFeedbackTypes: HapticFeedbackTypes.${_hapticType.toString().split('.').last},
  // Feel the vibration on each keystroke
)''',
    );
  }

  Widget _buildSeparator() {
    return DemoSection(
      title: '3. Custom Separator',
      description: 'Add custom widgets between PIN cells',
      demo: PinCodeTextField(
        length: 6,
        controller: _separatorController,
        onChanged: (value) {},
        separatorBuilder: (context, index) {
          if (index == 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 4,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          return const SizedBox(width: 8);
        },
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
  separatorBuilder: (context, index) {
    if (index == 2) {
      // Add a divider after 3rd cell
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 4,
          height: 30,
          color: Colors.blue,
        ),
      );
    }
    return SizedBox(width: 8);
  },
)''',
    );
  }
}
