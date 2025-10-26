import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import '../widgets/demo_section.dart';

class ValidationFeature extends StatefulWidget {
  const ValidationFeature({super.key});

  @override
  State<ValidationFeature> createState() => _ValidationFeatureState();
}

class _ValidationFeatureState extends State<ValidationFeature> {
  final _formKey = GlobalKey<FormState>();
  final _formController = TextEditingController();

  final _errorController = TextEditingController();
  final _errorAnimationController = StreamController<ErrorAnimationType>();

  @override
  void dispose() {
    _formController.dispose();
    _errorController.dispose();
    _errorAnimationController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFormValidation(),
        const SizedBox(height: 32),
        _buildErrorAnimation(),
      ],
    );
  }

  Widget _buildFormValidation() {
    return DemoSection(
      title: '1. Form Validation',
      description: 'Integrate with Flutter forms for validation',
      demo: Form(
        key: _formKey,
        child: Column(
          children: [
            PinCodeFormField(
              length: 6,
              controller: _formController,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'PIN is required';
                }
                if (value.length < 6) {
                  return 'Please enter all 6 digits';
                }
                if (value == '123456') {
                  return 'PIN is too weak';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                errorBorderColor: Theme.of(context).colorScheme.error,
                borderWidth: 2,
              ),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              errorTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('PIN validated: ${_formController.text}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Validate'),
            ),
          ],
        ),
      ),
      controls: const [],
      code: '''PinCodeFormField(
  length: 6,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length < 6) {
      return 'Please enter all 6 digits';
    }
    if (value == '123456') {
      return 'PIN is too weak';
    }
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
)''',
    );
  }

  Widget _buildErrorAnimation() {
    return DemoSection(
      title: '2. Error Animation',
      description: 'Trigger shake animation on errors',
      demo: Column(
        children: [
          PinCodeTextField(
            length: 6,
            controller: _errorController,
            onChanged: (value) {},
            errorAnimationController: _errorAnimationController,
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
              errorBorderColor: Theme.of(context).colorScheme.error,
              borderWidth: 2,
            ),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () {
              _errorAnimationController.add(ErrorAnimationType.shake);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error animation triggered!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.error_outline),
            label: const Text('Trigger Error Animation'),
          ),
        ],
      ),
      controls: const [],
      code: '''final errorController = StreamController<ErrorAnimationType>();

PinCodeTextField(
  errorAnimationController: errorController,
  // ... other properties
)

// Trigger error shake
errorController.add(ErrorAnimationType.shake);

// Clear error state
errorController.add(ErrorAnimationType.clear);''',
    );
  }
}
