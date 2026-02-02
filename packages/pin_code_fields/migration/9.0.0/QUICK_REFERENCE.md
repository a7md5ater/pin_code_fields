# Quick Reference Card: v8.x → v9.0.0

Print this page for quick reference during migration.

---

## Widget & Import

```dart
// v8.x                              // v9.0.0
PinCodeTextField(                    MaterialPinField(
  appContext: context,  // REMOVE      length: 6,
  length: 6,                           // ...
)                                    )
```

---

## Controller

```dart
// v8.x
final _textController = TextEditingController();
final _focusNode = FocusNode();
final _errorController = StreamController<ErrorAnimationType>();

// v9.0.0
final _controller = PinInputController();
```

| v8.x | v9.0.0 |
|------|--------|
| `_textController.text` | `_controller.text` |
| `_textController.text = '1234'` | `_controller.setText('1234')` |
| `_textController.clear()` | `_controller.clear()` |
| `_focusNode.requestFocus()` | `_controller.requestFocus()` |
| `_focusNode.unfocus()` | `_controller.unfocus()` |
| `_errorController.add(ErrorAnimationType.shake)` | `_controller.triggerError()` |

---

## Theme Class

```dart
// v8.x                              // v9.0.0
PinTheme(                            MaterialPinTheme(
  shape: PinCodeFieldShape.box,        shape: MaterialPinShape.outlined,
  fieldWidth: 48,                      cellSize: const Size(48, 56),
  fieldHeight: 56,                     // ...
)                                    )
```

---

## Shape Enum

| v8.x | v9.0.0 |
|------|--------|
| `PinCodeFieldShape.box` | `MaterialPinShape.outlined` |
| `PinCodeFieldShape.underline` | `MaterialPinShape.underlined` |
| `PinCodeFieldShape.circle` | `MaterialPinShape.circle` |
| — | `MaterialPinShape.filled` (NEW) |

---

## Color Properties

| v8.x | v9.0.0 | When |
|------|--------|------|
| `inactiveColor` | `borderColor` | Empty cell border |
| `selectedColor` | `focusedBorderColor` | Focused cell border |
| `activeColor` | `filledBorderColor` | Filled cell border |
| `inactiveFillColor` | `fillColor` | Empty cell background |
| `selectedFillColor` | `focusedFillColor` | Focused cell background |
| `activeFillColor` | `filledFillColor` | Filled cell background |
| `errorBorderColor` | `errorBorderColor` | Error border |
| — | `errorFillColor` | Error background (NEW) |
| `disabledColor` | `disabledBorderColor` | Disabled border |
| — | `disabledFillColor` | Disabled background (NEW) |
| — | `followingFillColor` | After focused (NEW) |
| — | `completeFillColor` | All filled (NEW) |

---

## Animation Enum

| v8.x | v9.0.0 |
|------|--------|
| `AnimationType.scale` | `MaterialPinAnimation.scale` |
| `AnimationType.fade` | `MaterialPinAnimation.fade` |
| `AnimationType.slide` | `MaterialPinAnimation.slide` |
| `AnimationType.none` | `MaterialPinAnimation.none` |
| — | `MaterialPinAnimation.custom` (NEW) |

---

## Haptic Feedback

| v8.x | v9.0.0 |
|------|--------|
| `useHapticFeedback: true` | `enableHapticFeedback: true` |
| `hapticFeedbackTypes: HapticFeedbackTypes.light` | `hapticFeedbackType: HapticFeedbackType.light` |

---

## Animation Location

```dart
// v8.x - on widget
PinCodeTextField(
  animationType: AnimationType.scale,
  animationDuration: Duration(milliseconds: 150),
  animationCurve: Curves.easeInOut,
)

// v9.0.0 - in theme
MaterialPinField(
  theme: MaterialPinTheme(
    entryAnimation: MaterialPinAnimation.scale,
    animationDuration: Duration(milliseconds: 150),
    animationCurve: Curves.easeOut,
  ),
)
```

---

## Error Handling

```dart
// v8.x
final _errorController = StreamController<ErrorAnimationType>();
_errorController.add(ErrorAnimationType.shake);

// v9.0.0
final _controller = PinInputController();
_controller.triggerError();
_controller.clearError();
```

---

## Form Validation

```dart
// v8.x - built into widget
PinCodeTextField(
  validator: (v) => v!.length < 6 ? 'Error' : null,
  onSaved: (v) => _pin = v,
)

// v9.0.0 - use wrapper
PinInputFormField(
  length: 6,
  validator: (v) => v!.length < 6 ? 'Error' : null,
  onSaved: (v) => _pin = v,
)
```

---

## Removed Parameters

| Removed | Alternative |
|---------|-------------|
| `appContext` | Not needed |
| `enableActiveFill` | Always enabled |
| `showPasteConfirmationDialog` | `onClipboardFound` |
| `dialogConfig` | Custom UI via callbacks |
| `beforeTextPaste` | `clipboardValidator` |
| `pastedTextStyle` | Use `textStyle` |
| `backgroundColor` | Container/Scaffold |
| `errorTextSpace` | `errorBuilder` |
| `autoDisposeControllers` | Controller handles |

---

## New Features

```dart
// Headless UI
PinInput(
  length: 6,
  builder: (context, cells) => Row(...),
)

// Clipboard detection
MaterialPinField(
  onClipboardFound: (code) => showPasteUI(),
)

// Custom cursor
MaterialPinTheme(
  cursorWidget: MyCustomCursor(),
  cursorAlignment: Alignment.bottomCenter,
)

// Complete state styling
MaterialPinTheme(
  completeFillColor: Colors.green.shade50,
  completeBorderColor: Colors.green,
)
```

---

## Find & Replace Patterns

Use these regex patterns in your IDE:

| Find | Replace |
|------|---------|
| `PinCodeTextField\(` | `MaterialPinField(` |
| `appContext:\s*context,?\s*` | (delete) |
| `pinTheme:` | `theme:` |
| `PinTheme\(` | `MaterialPinTheme(` |
| `PinCodeFieldShape\.box` | `MaterialPinShape.outlined` |
| `PinCodeFieldShape\.underline` | `MaterialPinShape.underlined` |
| `PinCodeFieldShape\.circle` | `MaterialPinShape.circle` |
| `AnimationType\.` | `MaterialPinAnimation.` |
| `fieldWidth:\s*(\d+),` | — (manual) |
| `fieldHeight:\s*(\d+),` | `cellSize: const Size($1, $2),` |
| `useHapticFeedback:` | `enableHapticFeedback:` |
| `hapticFeedbackTypes:` | `hapticFeedbackType:` |
| `HapticFeedbackTypes\.` | `HapticFeedbackType.` |
| `inactiveColor:` | `borderColor:` |
| `selectedColor:` | `focusedBorderColor:` |
| `activeColor:` | `filledBorderColor:` |
| `inactiveFillColor:` | `fillColor:` |
| `selectedFillColor:` | `focusedFillColor:` |
| `activeFillColor:` | `filledFillColor:` |
