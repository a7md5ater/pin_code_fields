import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/demo_section.dart';

class AnimationsFeature extends StatefulWidget {
  const AnimationsFeature({super.key});

  @override
  State<AnimationsFeature> createState() => _AnimationsFeatureState();
}

class _AnimationsFeatureState extends State<AnimationsFeature> {
  AnimationType _selectedAnimation = AnimationType.fade;
  final _controllers = {
    AnimationType.fade: TextEditingController(),
    AnimationType.scale: TextEditingController(),
    AnimationType.slide: TextEditingController(),
    AnimationType.none: TextEditingController(),
  };

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAnimationComparison(),
        const SizedBox(height: 32),
        _buildInteractiveDemo(),
      ],
    );
  }

  Widget _buildAnimationComparison() {
    return DemoSection(
      title: 'Animation Types Comparison',
      description: 'See how different animation types look when entering text',
      demo: Column(
        children: [
          _buildAnimationRow('Fade', AnimationType.fade),
          const SizedBox(height: 24),
          _buildAnimationRow('Scale', AnimationType.scale),
          const SizedBox(height: 24),
          _buildAnimationRow('Slide', AnimationType.slide),
          const SizedBox(height: 24),
          _buildAnimationRow('None', AnimationType.none),
        ],
      ),
      controls: const [],
      code: '''// Fade Animation
PinCodeTextField(
  animationType: AnimationType.fade,
  animationDuration: Duration(milliseconds: 300),
)

// Scale Animation
PinCodeTextField(
  animationType: AnimationType.scale,
  animationDuration: Duration(milliseconds: 300),
)

// Slide Animation
PinCodeTextField(
  animationType: AnimationType.slide,
  animationDuration: Duration(milliseconds: 300),
)

// No Animation
PinCodeTextField(
  animationType: AnimationType.none,
)''',
    );
  }

  Widget _buildAnimationRow(String label, AnimationType animationType) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: PinCodeTextField(
            length: 4,
            controller: _controllers[animationType],
            onChanged: (value) {},
            animationType: animationType,
            animationDuration: const Duration(milliseconds: 300),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 45,
              fieldWidth: 40,
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
        ),
      ],
    );
  }

  Widget _buildInteractiveDemo() {
    return DemoSection(
      title: 'Interactive Animation Demo',
      description: 'Choose an animation type and see it in action',
      demo: Column(
        children: [
          SegmentedButton<AnimationType>(
            segments: const [
              ButtonSegment(
                value: AnimationType.fade,
                label: Text('Fade'),
                icon: Icon(Icons.blur_on),
              ),
              ButtonSegment(
                value: AnimationType.scale,
                label: Text('Scale'),
                icon: Icon(Icons.zoom_in),
              ),
              ButtonSegment(
                value: AnimationType.slide,
                label: Text('Slide'),
                icon: Icon(Icons.swipe),
              ),
              ButtonSegment(
                value: AnimationType.none,
                label: Text('None'),
                icon: Icon(Icons.block),
              ),
            ],
            selected: {_selectedAnimation},
            onSelectionChanged: (Set<AnimationType> newSelection) {
              setState(() {
                _selectedAnimation = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 24),
          PinCodeTextField(
            key: ValueKey('anim-${_selectedAnimation.toString()}'),
            length: 6,
            onChanged: (value) {},
            animationType: _selectedAnimation,
            animationDuration: const Duration(milliseconds: 300),
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
        ],
      ),
      controls: const [],
      code: '''PinCodeTextField(
  animationType: AnimationType.${_selectedAnimation.toString().split('.').last},
  animationDuration: Duration(milliseconds: 300),
  animationCurve: Curves.easeInOut,
)''',
    );
  }
}
