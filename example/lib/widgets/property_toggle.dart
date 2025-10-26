import 'package:flutter/material.dart';

class PropertyToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PropertyToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: value,
      onSelected: onChanged,
      avatar: Icon(
        value ? Icons.check_circle : Icons.circle_outlined,
        size: 18,
      ),
    );
  }
}
