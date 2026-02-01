import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'theme/liquid_glass_pin_theme.dart';
import 'cells/separate_glass_cells.dart';
import 'cells/unified_glass_cell.dart';
import 'cells/blended_glass_cells.dart';

/// A [FormField] wrapper for [LiquidGlassPinField] that enables form validation.
///
/// This widget provides all the standard form field functionality including
/// validation, onSaved callbacks, and auto-validation modes, with iOS 26
/// Liquid Glass styling.
///
/// **Note:** This widget requires Impeller rendering engine and only works on
/// iOS, Android, and macOS. Web, Windows, and Linux are not supported.
///
/// ## Example
///
/// ```dart
/// Form(
///   key: _formKey,
///   child: LiquidGlassPinFormField(
///     length: 6,
///     theme: LiquidGlassPinTheme.blended(),
///     validator: (value) {
///       if (value == null || value.length < 6) {
///         return 'Please enter all 6 digits';
///       }
///       return null;
///     },
///     onSaved: (value) => print('PIN saved: $value'),
///   ),
/// )
///
/// // Validate and save:
/// if (_formKey.currentState!.validate()) {
///   _formKey.currentState!.save();
/// }
/// ```
class LiquidGlassPinFormField extends FormField<String> {
  LiquidGlassPinFormField({
    super.key,
    required this.length,
    this.theme = const SeparateGlassTheme(),
    // Controller
    this.pinController,
    // Input behavior
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints = const [AutofillHints.oneTimeCode],
    // Behavior
    super.enabled,
    this.autoFocus = false,
    this.readOnly = false,
    this.autoDismissKeyboard = true,
    this.clearErrorOnInput = true,
    this.obscureText = false,
    this.obscuringCharacter = '●',
    this.obscuringWidget,
    this.blinkWhenObscuring = true,
    this.blinkDuration = const Duration(milliseconds: 500),
    // Haptics
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = HapticFeedbackType.light,
    // Gestures
    this.enablePaste = true,
    this.selectionControls,
    this.contextMenuBuilder,
    // Clipboard
    this.onClipboardFound,
    this.clipboardValidator,
    // Callbacks
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    // Cursor
    this.mouseCursor,
    // Keyboard
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    // Autofill
    this.enableAutofill = true,
    this.autofillContextAction = AutofillContextAction.commit,
    // Form field
    super.validator,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.restorationId,
    // Error display
    this.errorTextSpace = 8.0,
    this.errorTextStyle,
  }) : super(
          builder: (FormFieldState<String> field) {
            final state = field as _LiquidGlassPinFormFieldState;
            final widget = state.widget;
            final resolvedTheme = widget.theme.resolve(field.context);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The PIN field wrapped in LiquidGlassLayer
                LiquidGlassLayer(
                  settings: LiquidGlassSettings(
                    thickness: widget.theme.thickness,
                    blur: widget.theme.blur,
                    glassColor: resolvedTheme.glassColor,
                    visibility: widget.theme.visibility,
                    chromaticAberration: widget.theme.chromaticAberration,
                    lightAngle: resolvedTheme.lightAngle,
                    lightIntensity: widget.theme.lightIntensity,
                    ambientStrength: widget.theme.ambientStrength,
                    refractiveIndex: widget.theme.refractiveIndex,
                    saturation: widget.theme.saturation,
                  ),
                  child: PinInput(
                    length: widget.length,
                    pinController: state._effectiveController,
                    initialValue: widget.initialValue,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    inputFormatters: widget.inputFormatters,
                    textCapitalization: widget.textCapitalization,
                    autofillHints: widget.autofillHints,
                    enabled: widget.enabled,
                    autoFocus: widget.autoFocus,
                    readOnly: widget.readOnly,
                    autoDismissKeyboard: widget.autoDismissKeyboard,
                    clearErrorOnInput: widget.clearErrorOnInput,
                    obscureText: widget.obscureText,
                    obscuringCharacter: widget.obscuringCharacter,
                    blinkWhenObscuring: widget.blinkWhenObscuring,
                    blinkDuration: widget.blinkDuration,
                    enableHapticFeedback: widget.enableHapticFeedback,
                    hapticFeedbackType: widget.hapticFeedbackType,
                    enablePaste: widget.enablePaste,
                    selectionControls: widget.selectionControls,
                    contextMenuBuilder: widget.contextMenuBuilder,
                    onClipboardFound: widget.onClipboardFound,
                    clipboardValidator: widget.clipboardValidator,
                    onChanged: (value) {
                      field.didChange(value);
                      widget.onChanged?.call(value);
                    },
                    onCompleted: widget.onCompleted,
                    onSubmitted: widget.onSubmitted,
                    onEditingComplete: widget.onEditingComplete,
                    onTap: widget.onTap,
                    onLongPress: widget.onLongPress,
                    onTapOutside: widget.onTapOutside,
                    mouseCursor: widget.mouseCursor,
                    keyboardAppearance: widget.keyboardAppearance,
                    scrollPadding: widget.scrollPadding,
                    enableAutofill: widget.enableAutofill,
                    autofillContextAction: widget.autofillContextAction,
                    builder: (context, cells) {
                      return _buildCells(
                        context,
                        cells,
                        widget.theme,
                        resolvedTheme,
                        widget.obscureText,
                        widget.obscuringCharacter,
                        widget.obscuringWidget,
                      );
                    },
                  ),
                ),

                // Error text
                if (field.hasError) ...[
                  SizedBox(height: widget.errorTextSpace),
                  Text(
                    field.errorText!,
                    style: widget.errorTextStyle ??
                        TextStyle(
                          color: resolvedTheme.errorGlowColor,
                          fontSize: 12,
                        ),
                  ),
                ],
              ],
            );
          },
        );

  /// Number of PIN digits.
  final int length;

  /// Theme configuration for the liquid glass style.
  final LiquidGlassPinTheme theme;

  /// Controller for programmatic control of the PIN field.
  final PinInputController? pinController;

  /// The type of keyboard to display.
  final TextInputType keyboardType;

  /// The action button to display on the keyboard.
  final TextInputAction textInputAction;

  /// Additional input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// How to capitalize text input.
  final TextCapitalization textCapitalization;

  /// Autofill hints for the text field.
  final Iterable<String> autofillHints;

  /// Whether to auto-focus on mount.
  final bool autoFocus;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to dismiss the keyboard when PIN is complete.
  final bool autoDismissKeyboard;

  /// Whether to automatically clear error state when user types.
  final bool clearErrorOnInput;

  /// Whether to obscure the entered text.
  final bool obscureText;

  /// Character used to obscure text.
  final String obscuringCharacter;

  /// Widget to use when obscuring (overrides [obscuringCharacter]).
  final Widget? obscuringWidget;

  /// Whether to briefly show the character before obscuring.
  final bool blinkWhenObscuring;

  /// Duration to show the character before obscuring.
  final Duration blinkDuration;

  /// Whether to trigger haptic feedback on input.
  final bool enableHapticFeedback;

  /// Type of haptic feedback to trigger.
  final HapticFeedbackType hapticFeedbackType;

  /// Whether to enable paste functionality.
  final bool enablePaste;

  /// Custom text selection controls.
  final TextSelectionControls? selectionControls;

  /// Builder for the context menu (paste functionality).
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Called when the clipboard contains valid PIN-like content on focus.
  final ValueChanged<String>? onClipboardFound;

  /// Custom validator for clipboard content.
  final bool Function(String text, int length)? clipboardValidator;

  /// Called when the PIN value changes.
  final ValueChanged<String>? onChanged;

  /// Called when all digits are entered.
  final ValueChanged<String>? onCompleted;

  /// Called when the user submits (presses done on keyboard).
  final ValueChanged<String>? onSubmitted;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Called when the field is long-pressed.
  final VoidCallback? onLongPress;

  /// Called when user taps outside the field.
  final void Function(PointerDownEvent event)? onTapOutside;

  /// The mouse cursor to show when hovering over the widget.
  final MouseCursor? mouseCursor;

  /// The brightness of the keyboard.
  final Brightness? keyboardAppearance;

  /// Padding when scrolling the field into view.
  final EdgeInsets scrollPadding;

  /// Whether autofill is enabled (e.g., SMS OTP autofill).
  final bool enableAutofill;

  /// Action to perform when the autofill context is disposed.
  final AutofillContextAction autofillContextAction;

  /// Space between PIN input and error text.
  final double errorTextSpace;

  /// Style for error text.
  final TextStyle? errorTextStyle;

  @override
  FormFieldState<String> createState() => _LiquidGlassPinFormFieldState();

  static Widget _buildCells(
    BuildContext context,
    List<PinCellData> cells,
    LiquidGlassPinTheme theme,
    ResolvedLiquidGlassTheme resolvedTheme,
    bool obscureText,
    String obscuringCharacter,
    Widget? obscuringWidget,
  ) {
    return switch (theme) {
      SeparateGlassTheme() => SeparateGlassCells(
          cells: cells,
          theme: theme,
          resolvedTheme: resolvedTheme,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          obscuringWidget: obscuringWidget,
        ),
      UnifiedGlassTheme() => UnifiedGlassCell(
          cells: cells,
          theme: theme,
          resolvedTheme: resolvedTheme,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          obscuringWidget: obscuringWidget,
        ),
      BlendedGlassTheme() => BlendedGlassCells(
          cells: cells,
          theme: theme,
          resolvedTheme: resolvedTheme,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          obscuringWidget: obscuringWidget,
        ),
    };
  }
}

class _LiquidGlassPinFormFieldState extends FormFieldState<String> {
  PinInputController? _internalController;

  @override
  LiquidGlassPinFormField get widget => super.widget as LiquidGlassPinFormField;

  PinInputController get _effectiveController =>
      widget.pinController ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.pinController == null) {
      _internalController = PinInputController(text: widget.initialValue ?? '');
    } else if (widget.initialValue != null) {
      widget.pinController!.setText(widget.initialValue!);
    }
  }

  @override
  void didUpdateWidget(LiquidGlassPinFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller change
    if (widget.pinController != oldWidget.pinController) {
      if (oldWidget.pinController == null && widget.pinController != null) {
        // External controller provided, dispose internal
        _internalController?.dispose();
        _internalController = null;
        if (widget.initialValue != null) {
          widget.pinController!.setText(widget.initialValue!);
        }
      } else if (oldWidget.pinController != null &&
          widget.pinController == null) {
        // External controller removed, create internal
        _internalController =
            PinInputController(text: widget.initialValue ?? '');
      }
    }

    // Handle initial value change
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null) {
      _effectiveController.setText(widget.initialValue!);
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  void reset() {
    _effectiveController.setText(widget.initialValue ?? '');
    super.reset();
  }
}
