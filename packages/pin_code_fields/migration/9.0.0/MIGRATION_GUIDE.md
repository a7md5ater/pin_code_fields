# Migration Guide: v8.x → v9.0.0

This guide helps you migrate from `pin_code_fields` v8.x to v9.0.0, which introduces a **headless architecture** with improved APIs and better Material Design integration.

## Table of Contents

- [Quick Start](#quick-start)
- [Breaking Changes Summary](#breaking-changes-summary)
- [Step-by-Step Migration](#step-by-step-migration)
  - [1. Widget Rename](#1-widget-rename)
  - [2. Controller Migration](#2-controller-migration)
  - [3. Theme Migration](#3-theme-migration)
  - [4. Error Handling](#4-error-handling)
  - [5. Form Integration](#5-form-integration)
  - [6. Removed Parameters](#6-removed-parameters)
- [Property Mapping Reference](#property-mapping-reference)
- [New Features](#new-features)
- [Migration Checklist](#migration-checklist)

---

## Quick Start

### Minimal Migration (Before → After)

**v8.x:**
```dart
import 'package:pin_code_fields/pin_code_fields.dart';

PinCodeTextField(
  appContext: context,
  length: 6,
  onChanged: (value) => print(value),
  onCompleted: (value) => verify(value),
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(8),
    fieldHeight: 56,
    fieldWidth: 48,
    activeColor: Colors.blue,
    selectedColor: Colors.blue,
    inactiveColor: Colors.grey,
  ),
)
```

**v9.0.0:**
```dart
import 'package:pin_code_fields/pin_code_fields.dart';

MaterialPinField(
  length: 6,
  onChanged: (value) => print(value),
  onCompleted: (value) => verify(value),
  theme: MaterialPinTheme(
    shape: MaterialPinShape.outlined,
    borderRadius: BorderRadius.circular(8),
    cellSize: const Size(48, 56),
    focusedBorderColor: Colors.blue,
    filledBorderColor: Colors.blue,
    borderColor: Colors.grey,
  ),
)
```

---

## Breaking Changes Summary

| Change | v8.x | v9.0.0 |
|--------|------|--------|
| Widget name | `PinCodeTextField` | `MaterialPinField` |
| Context param | `appContext` (required) | Removed |
| Controller | `TextEditingController` + `FocusNode` | `PinInputController` |
| Theme | `PinTheme` | `MaterialPinTheme` |
| Cell size | `fieldWidth` + `fieldHeight` | `cellSize: Size(w, h)` |
| Shape enum | `PinCodeFieldShape` | `MaterialPinShape` |
| Animation enum | `AnimationType` | `MaterialPinAnimation` |
| Error trigger | `StreamController<ErrorAnimationType>` | `controller.triggerError()` |

---

## Step-by-Step Migration

### 1. Widget Rename

The main widget has been renamed from `PinCodeTextField` to `MaterialPinField`.

**v8.x:**
```dart
PinCodeTextField(
  appContext: context,  // Required in v8.x
  length: 6,
  // ...
)
```

**v9.0.0:**
```dart
MaterialPinField(
  length: 6,  // appContext removed!
  // ...
)
```

> **Note:** The `appContext` parameter has been removed entirely.

---

### 2. Controller Migration

v9.0.0 introduces a unified `PinInputController` that combines:
- `TextEditingController` (text management)
- `FocusNode` (focus management)
- Error state management

#### Creating a Controller

**v8.x:**
```dart
final _textController = TextEditingController();
final _focusNode = FocusNode();
final _errorController = StreamController<ErrorAnimationType>();

@override
void dispose() {
  _textController.dispose();
  _focusNode.dispose();
  _errorController.close();
  super.dispose();
}
```

**v9.0.0:**
```dart
final _controller = PinInputController();

@override
void dispose() {
  _controller.dispose();  // Handles all cleanup
  super.dispose();
}
```

#### Using the Controller

**v8.x:**
```dart
// Read text
String pin = _textController.text;

// Set text
_textController.text = '1234';

// Clear
_textController.clear();

// Focus
_focusNode.requestFocus();

// Trigger error
_errorController.add(ErrorAnimationType.shake);
```

**v9.0.0:**
```dart
// Read text
String pin = _controller.text;

// Set text
_controller.setText('1234');

// Clear (also clears error state)
_controller.clear();

// Focus
_controller.requestFocus();

// Trigger error (shake + visual error state)
_controller.triggerError();

// Clear error manually
_controller.clearError();

// Check error state
bool hasError = _controller.hasError;
```

#### Widget Parameter

**v8.x:**
```dart
PinCodeTextField(
  controller: _textController,
  focusNode: _focusNode,
  errorAnimationController: _errorController,
  // ...
)
```

**v9.0.0:**
```dart
MaterialPinField(
  pinController: _controller,  // Single unified controller
  // ...
)
```

---

### 3. Theme Migration

The theme system has been redesigned with more granular control and automatic ColorScheme resolution.

#### Shape Migration

**v8.x:**
```dart
PinCodeFieldShape.box       // Box with border
PinCodeFieldShape.underline // Only bottom border
PinCodeFieldShape.circle    // Circular cells
```

**v9.0.0:**
```dart
MaterialPinShape.outlined   // Box with border (was: box)
MaterialPinShape.filled     // Filled background, no border (NEW)
MaterialPinShape.underlined // Only bottom border
MaterialPinShape.circle     // Circular cells
```

#### Size Migration

**v8.x:**
```dart
PinTheme(
  fieldWidth: 48,
  fieldHeight: 56,
)
```

**v9.0.0:**
```dart
MaterialPinTheme(
  cellSize: const Size(48, 56),
)
```

#### Color Migration

The color naming has changed to be more descriptive:

| v8.x | v9.0.0 | Description |
|------|--------|-------------|
| `inactiveColor` | `borderColor` | Empty cell border |
| `selectedColor` | `focusedBorderColor` | Focused cell border |
| `activeColor` | `filledBorderColor` | Filled cell border |
| `inactiveFillColor` | `fillColor` | Empty cell fill |
| `selectedFillColor` | `focusedFillColor` | Focused cell fill |
| `activeFillColor` | `filledFillColor` | Filled cell fill |
| `errorBorderColor` | `errorBorderColor` | Error state border |
| — | `errorFillColor` | Error state fill (NEW) |
| `disabledColor` | `disabledBorderColor` | Disabled border |
| — | `disabledFillColor` | Disabled fill (NEW) |

**v8.x:**
```dart
PinTheme(
  inactiveColor: Colors.grey,
  selectedColor: Colors.blue,
  activeColor: Colors.blue.shade700,
  inactiveFillColor: Colors.grey.shade100,
  selectedFillColor: Colors.blue.shade50,
  activeFillColor: Colors.blue.shade100,
  errorBorderColor: Colors.red,
)
```

**v9.0.0:**
```dart
MaterialPinTheme(
  borderColor: Colors.grey,
  focusedBorderColor: Colors.blue,
  filledBorderColor: Colors.blue.shade700,
  fillColor: Colors.grey.shade100,
  focusedFillColor: Colors.blue.shade50,
  filledFillColor: Colors.blue.shade100,
  errorBorderColor: Colors.red,
  errorFillColor: Colors.red.shade50,  // NEW
)
```

#### New Color States in v9.0.0

v9.0.0 adds two new cell states:

**Following Cells** (cells after the focused position):
```dart
MaterialPinTheme(
  followingFillColor: Colors.grey.shade50,
  followingBorderColor: Colors.grey.shade200,
)
```

**Complete State** (all cells filled):
```dart
MaterialPinTheme(
  completeFillColor: Colors.green.shade50,
  completeBorderColor: Colors.green,
)
```

#### ColorScheme Resolution

In v9.0.0, colors are automatically resolved from `ColorScheme` if not specified:

```dart
// Colors auto-resolve from theme:
MaterialPinTheme(
  shape: MaterialPinShape.outlined,
  // borderColor: null → uses ColorScheme.outline
  // focusedBorderColor: null → uses ColorScheme.primary
  // errorColor: null → uses ColorScheme.error
)
```

#### Border Width Migration

**v8.x:**
```dart
PinTheme(
  activeBorderWidth: 2,
  selectedBorderWidth: 2,
  inactiveBorderWidth: 1,
)
```

**v9.0.0:**
```dart
MaterialPinTheme(
  borderWidth: 1.5,        // Default state
  focusedBorderWidth: 2.0, // Focused state
  // Filled uses borderWidth by default
)
```

#### Animation Migration

**v8.x:**
```dart
PinCodeTextField(
  animationType: AnimationType.scale,
  animationDuration: Duration(milliseconds: 150),
  animationCurve: Curves.easeInOut,
)
```

**v9.0.0:**
```dart
MaterialPinField(
  theme: MaterialPinTheme(
    entryAnimation: MaterialPinAnimation.scale,
    animationDuration: Duration(milliseconds: 150),
    animationCurve: Curves.easeOut,
  ),
)
```

**New: Custom Animations**

v9.0.0 adds support for fully custom entry animations:

```dart
MaterialPinTheme(
  entryAnimation: MaterialPinAnimation.custom,
  customEntryAnimationBuilder: (child, animation) {
    return RotationTransition(
      turns: animation,
      child: FadeTransition(opacity: animation, child: child),
    );
  },
)
```

---

### 4. Error Handling

Error handling has been significantly simplified in v9.0.0.

#### Triggering Errors

**v8.x:**
```dart
final _errorController = StreamController<ErrorAnimationType>();

// Trigger shake
_errorController.add(ErrorAnimationType.shake);

// Clear with shake
_errorController.add(ErrorAnimationType.clear);
```

**v9.0.0:**
```dart
final _controller = PinInputController();

// Trigger error (shows shake animation + error styling)
_controller.triggerError();

// Clear error state
_controller.clearError();

// Check state
if (_controller.hasError) { ... }
```

#### Displaying Error Text

**v8.x:**
```dart
PinCodeTextField(
  // Limited built-in error display
  errorTextSpace: 16,
  errorTextMargin: EdgeInsets.zero,
)
```

**v9.0.0:**
```dart
MaterialPinField(
  errorText: 'Invalid PIN. Please try again.',
  errorTextStyle: TextStyle(color: Colors.red),
  // Or use custom builder:
  errorBuilder: (errorText) => Container(
    padding: EdgeInsets.all(8),
    child: Row(
      children: [
        Icon(Icons.error, color: Colors.red, size: 16),
        SizedBox(width: 8),
        Text(errorText ?? ''),
      ],
    ),
  ),
)
```

#### Auto-Clear Error on Input

v9.0.0 automatically clears error state when user starts typing:

```dart
MaterialPinField(
  clearErrorOnInput: true,  // Default: true
)
```

---

### 5. Form Integration

Form integration has been moved to a dedicated wrapper widget.

**v8.x:**
```dart
PinCodeTextField(
  appContext: context,
  length: 6,
  validator: (value) {
    if (value == null || value.length < 6) {
      return 'Please enter complete PIN';
    }
    return null;
  },
  onSaved: (value) => _savedPin = value,
  autovalidateMode: AutovalidateMode.onUserInteraction,
)
```

**v9.0.0:**
```dart
PinInputFormField(
  length: 6,
  validator: (value) {
    if (value == null || value.length < 6) {
      return 'Please enter complete PIN';
    }
    return null;
  },
  onSaved: (value) => _savedPin = value,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  // Use theme for styling
  theme: MaterialPinTheme(...),
)
```

---

### 6. Removed Parameters

The following parameters have been removed in v9.0.0:

| Removed Parameter | Migration Path |
|-------------------|----------------|
| `appContext` | No longer needed |
| `pastedTextStyle` | Use regular text style |
| `backgroundColor` | Use scaffold/container background |
| `enableActiveFill` | Always enabled; use fill colors |
| `autoDisposeControllers` | `PinInputController` handles disposal |
| `showPasteConfirmationDialog` | Use `onClipboardFound` callback |
| `dialogConfig` | Use `onClipboardFound` for custom UI |
| `beforeTextPaste` | Use `clipboardValidator` |
| `errorTextSpace` | Use `errorBuilder` |
| `errorTextMargin` | Use `errorBuilder` |
| `errorTextDirection` | Use `errorBuilder` |
| `boxShadows` (on widget) | Use `theme.boxShadows` |
| `autoUnfocus` | Use `autoDismissKeyboard` |

---

## Property Mapping Reference

### Complete Parameter Mapping

| v8.x Parameter | v9.0.0 Parameter | Notes |
|----------------|------------------|-------|
| `appContext` | — | Removed |
| `length` | `length` | Same |
| `controller` | `pinController` | Use `PinInputController` |
| `focusNode` | `pinController.focusNode` | Part of controller |
| `keyboardType` | `keyboardType` | Same |
| `textInputAction` | `textInputAction` | Same |
| `inputFormatters` | `inputFormatters` | Same |
| `textCapitalization` | `textCapitalization` | Same |
| `enabled` | `enabled` | Same |
| `autoFocus` | `autoFocus` | Same |
| `readOnly` | `readOnly` | Same |
| `obscureText` | `obscureText` | Same |
| `obscuringCharacter` | `theme.obscuringCharacter` | Moved to theme |
| `obscuringWidget` | `obscuringWidget` | Same |
| `blinkWhenObscuring` | `blinkWhenObscuring` | Same |
| `blinkDuration` | `blinkDuration` | Same |
| `useHapticFeedback` | `enableHapticFeedback` | Renamed |
| `hapticFeedbackTypes` | `hapticFeedbackType` | Renamed, singular |
| `onChanged` | `onChanged` | Same |
| `onCompleted` | `onCompleted` | Same |
| `onSubmitted` | `onSubmitted` | Same |
| `onEditingComplete` | `onEditingComplete` | Same |
| `onTap` | `onTap` | Same |
| `textStyle` | `theme.textStyle` | Moved to theme |
| `textGradient` | `theme.textGradient` | Moved to theme |
| `hintCharacter` | `hintCharacter` | Same |
| `hintStyle` | `hintStyle` | Same |
| `showCursor` | `theme.showCursor` | Moved to theme |
| `cursorColor` | `theme.cursorColor` | Moved to theme |
| `cursorWidth` | `theme.cursorWidth` | Moved to theme |
| `cursorHeight` | `theme.cursorHeight` | Moved to theme |
| `mainAxisAlignment` | `mainAxisAlignment` | Same |
| `separatorBuilder` | `separatorBuilder` | Same |
| `keyboardAppearance` | `keyboardAppearance` | Same |
| `scrollPadding` | `scrollPadding` | Same |
| `enablePinAutofill` | `enableAutofill` | Renamed |
| `autoDismissKeyboard` | `autoDismissKeyboard` | Same |
| `pinTheme` | `theme` | Use `MaterialPinTheme` |
| `animationType` | `theme.entryAnimation` | Moved to theme |
| `animationDuration` | `theme.animationDuration` | Moved to theme |
| `animationCurve` | `theme.animationCurve` | Moved to theme |
| `errorAnimationController` | `pinController.triggerError()` | Method-based |
| `errorAnimationDuration` | `theme.errorAnimationDuration` | Moved, now Duration |
| `validator` | Use `PinInputFormField` | Separate widget |
| `onSaved` | Use `PinInputFormField` | Separate widget |
| `autovalidateMode` | Use `PinInputFormField` | Separate widget |

---

## New Features

### Headless UI with `PinInput`

v9.0.0 introduces a headless `PinInput` widget for complete UI customization:

```dart
PinInput(
  length: 6,
  builder: (context, cells) {
    return Row(
      children: cells.map((cell) => Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          color: cell.isFocused ? Colors.blue.shade50 : Colors.grey.shade100,
          border: Border.all(
            color: cell.isError
                ? Colors.red
                : cell.isFocused
                    ? Colors.blue
                    : Colors.grey,
          ),
        ),
        child: Center(
          child: cell.isFocused && cell.character == null
              ? _AnimatedCursor()
              : Text(cell.character ?? ''),
        ),
      )).toList(),
    );
  },
)
```

### PinCellData

Each cell receives a `PinCellData` object with rich state information:

```dart
cell.index         // 0-based position
cell.character     // The entered character (or null)
cell.isFocused     // Is this the input position?
cell.isFilled      // Has a character been entered?
cell.isError       // Is in error state?
cell.isDisabled    // Is disabled/readonly?
cell.isFollowing   // Is after the focused cell?
cell.isComplete    // Are all cells filled?
cell.wasJustEntered // Was character just typed? (for animations)
cell.wasJustRemoved // Was character just deleted?
cell.isBlinking    // Showing real char before obscuring?
```

### Clipboard Detection

```dart
MaterialPinField(
  onClipboardFound: (code) {
    // Called when valid PIN detected in clipboard
    // Show paste button or auto-paste
  },
  clipboardValidator: (text, length) {
    // Custom validation for clipboard content
    return text.length == length && RegExp(r'^\d+$').hasMatch(text);
  },
)
```

### Custom Cursor Widget

```dart
MaterialPinTheme(
  cursorWidget: Container(
    width: 20,
    height: 3,
    color: Colors.blue,
  ),
  cursorAlignment: Alignment.bottomCenter,
)
```

---

## Migration Checklist

Use this checklist to ensure complete migration:

### Dependencies
- [ ] Update `pubspec.yaml` to `pin_code_fields: ^9.0.0`
- [ ] Run `flutter pub get`

### Widget Changes
- [ ] Rename `PinCodeTextField` → `MaterialPinField`
- [ ] Remove `appContext` parameter
- [ ] Update `pinTheme` → `theme`

### Controller Changes
- [ ] Replace `TextEditingController` with `PinInputController`
- [ ] Replace `FocusNode` usage with `pinController.requestFocus()`
- [ ] Replace `StreamController<ErrorAnimationType>` with `pinController.triggerError()`
- [ ] Update parameter: `controller` → `pinController`

### Theme Changes
- [ ] Rename `PinTheme` → `MaterialPinTheme`
- [ ] Update shape: `PinCodeFieldShape.box` → `MaterialPinShape.outlined`
- [ ] Update size: `fieldWidth`/`fieldHeight` → `cellSize: Size(w, h)`
- [ ] Update colors using the [mapping table](#complete-parameter-mapping)
- [ ] Move animation properties to theme

### Error Handling
- [ ] Remove `errorAnimationController` parameter
- [ ] Use `pinController.triggerError()` method
- [ ] Add `errorText` or `errorBuilder` for error display
- [ ] Update `errorAnimationDuration` from `int` to `Duration`

### Form Integration
- [ ] If using form validation, wrap with `PinInputFormField`
- [ ] Move `validator`, `onSaved`, `autovalidateMode` to form field

### Removed Features
- [ ] Remove `enableActiveFill` (no longer needed)
- [ ] Remove `showPasteConfirmationDialog` (use `onClipboardFound`)
- [ ] Remove `dialogConfig` (use custom UI via callbacks)
- [ ] Remove `beforeTextPaste` (use `clipboardValidator`)
- [ ] Remove `pastedTextStyle`, `backgroundColor`, `boxShadows`

### Testing
- [ ] Test basic input functionality
- [ ] Test error state triggering
- [ ] Test paste functionality
- [ ] Test form validation (if applicable)
- [ ] Test on iOS and Android

---

## Need Help?

- [Full API Documentation](https://pub.dev/documentation/pin_code_fields/latest/)
- [GitHub Issues](https://github.com/adar2378/pin_code_fields/issues)
- [Example App](https://github.com/adar2378/pin_code_fields/tree/master/packages/pin_code_fields/example)
