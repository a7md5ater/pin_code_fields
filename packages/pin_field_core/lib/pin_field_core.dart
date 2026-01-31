/// A headless PIN/OTP input engine for Flutter.
///
/// This package provides all the input handling logic without any visual
/// opinion. You build the UI, we handle the keyboard input, text management,
/// paste functionality, and state management.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:pin_field_core/pin_field_core.dart';
///
/// PinInput(
///   length: 6,
///   builder: (context, cells) {
///     return Row(
///       children: cells.map((cell) {
///         return Container(
///           width: 50,
///           height: 50,
///           decoration: BoxDecoration(
///             border: Border.all(
///               color: cell.isFocused ? Colors.blue : Colors.grey,
///             ),
///           ),
///           child: Center(
///             child: Text(cell.character ?? ''),
///           ),
///         );
///       }).toList(),
///     );
///   },
///   onCompleted: (pin) => print('Entered PIN: $pin'),
/// )
/// ```
///
/// ## Core Concepts
///
/// - [PinInput]: The headless widget that captures input
/// - [PinCellData]: Immutable data model for each cell's state
/// - [PinInputScope]: InheritedWidget for accessing PIN state
/// - [PinInputFormField]: FormField wrapper for form validation
library pin_field_core;

// Models
export 'src/pin_cell_data.dart';

// Core widget
export 'src/pin_input.dart';
export 'src/pin_input_scope.dart';

// Form integration
export 'src/form/pin_input_form_field.dart';

// Haptics
export 'src/haptics.dart';

// Gestures
export 'src/gestures/context_menu_builder.dart';
export 'src/gestures/selection_gesture_builder.dart';
