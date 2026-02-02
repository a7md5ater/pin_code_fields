# Migration Examples: v8.x → v9.0.0

Real-world code examples showing before and after migration.

---

## Example 1: Basic OTP Input

### v8.x
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinCodeTextField(
        appContext: context,
        length: 6,
        controller: _textController,
        onChanged: (value) => setState(() {}),
        onCompleted: (value) => _verifyOtp(value),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 56,
          fieldWidth: 48,
          activeColor: Colors.blue,
          selectedColor: Colors.blue,
          inactiveColor: Colors.grey,
          activeFillColor: Colors.blue.shade50,
          selectedFillColor: Colors.blue.shade100,
          inactiveFillColor: Colors.grey.shade100,
        ),
        enableActiveFill: true,
        animationType: AnimationType.scale,
        keyboardType: TextInputType.number,
        autoFocus: true,
      ),
    );
  }

  void _verifyOtp(String otp) {
    // Verify OTP
  }
}
```

### v9.0.0
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controller = PinInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialPinField(
        length: 6,
        pinController: _controller,
        onChanged: (value) => setState(() {}),
        onCompleted: (value) => _verifyOtp(value),
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          borderRadius: BorderRadius.circular(8),
          cellSize: const Size(48, 56),
          focusedBorderColor: Colors.blue,
          filledBorderColor: Colors.blue,
          borderColor: Colors.grey,
          focusedFillColor: Colors.blue.shade100,
          filledFillColor: Colors.blue.shade50,
          fillColor: Colors.grey.shade100,
          entryAnimation: MaterialPinAnimation.scale,
        ),
        keyboardType: TextInputType.number,
        autoFocus: true,
      ),
    );
  }

  void _verifyOtp(String otp) {
    // Verify OTP
  }
}
```

---

## Example 2: With Error Handling

### v8.x
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinLoginScreen extends StatefulWidget {
  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final _textController = TextEditingController();
  final _errorController = StreamController<ErrorAnimationType>();
  String? _errorText;

  @override
  void dispose() {
    _textController.dispose();
    _errorController.close();
    super.dispose();
  }

  void _verifyPin(String pin) async {
    final isValid = await _checkPin(pin);
    if (!isValid) {
      _errorController.add(ErrorAnimationType.shake);
      setState(() => _errorText = 'Invalid PIN');
      _textController.clear();
    }
  }

  Future<bool> _checkPin(String pin) async {
    await Future.delayed(Duration(seconds: 1));
    return pin == '123456';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: _textController,
            errorAnimationController: _errorController,
            onCompleted: _verifyPin,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 60,
              fieldWidth: 50,
              activeColor: Colors.indigo,
              selectedColor: Colors.indigo,
              inactiveColor: Colors.grey.shade300,
              errorBorderColor: Colors.red,
            ),
            errorAnimationDuration: 500,
          ),
          if (_errorText != null)
            Text(_errorText!, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
```

### v9.0.0
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinLoginScreen extends StatefulWidget {
  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final _controller = PinInputController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verifyPin(String pin) async {
    final isValid = await _checkPin(pin);
    if (!isValid) {
      _controller.triggerError();  // Triggers shake + error state
      setState(() => _errorText = 'Invalid PIN');
      Future.delayed(Duration(milliseconds: 800), () {
        _controller.clear();  // Also clears error
      });
    }
  }

  Future<bool> _checkPin(String pin) async {
    await Future.delayed(Duration(seconds: 1));
    return pin == '123456';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialPinField(
        length: 6,
        pinController: _controller,
        onCompleted: _verifyPin,
        errorText: _errorText,  // Built-in error display
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          borderRadius: BorderRadius.circular(12),
          cellSize: const Size(50, 60),
          focusedBorderColor: Colors.indigo,
          filledBorderColor: Colors.indigo,
          borderColor: Colors.grey.shade300,
          errorBorderColor: Colors.red,
          errorFillColor: Colors.red.shade50,
          errorAnimationDuration: Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
```

---

## Example 3: Form Validation

### v8.x
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinFormScreen extends StatefulWidget {
  @override
  State<PinFormScreen> createState() => _PinFormScreenState();
}

class _PinFormScreenState extends State<PinFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            PinCodeTextField(
              appContext: context,
              length: 4,
              validator: (value) {
                if (value == null || value.length < 4) {
                  return 'Please enter complete PIN';
                }
                return null;
              },
              onSaved: (value) => _pin = value,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldHeight: 50,
                fieldWidth: 40,
              ),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('PIN: $_pin');
    }
  }
}
```

### v9.0.0
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinFormScreen extends StatefulWidget {
  @override
  State<PinFormScreen> createState() => _PinFormScreenState();
}

class _PinFormScreenState extends State<PinFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            PinInputFormField(
              length: 4,
              validator: (value) {
                if (value == null || value.length < 4) {
                  return 'Please enter complete PIN';
                }
                return null;
              },
              onSaved: (value) => _pin = value,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              theme: MaterialPinTheme(
                shape: MaterialPinShape.underlined,
                cellSize: const Size(40, 50),
              ),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('PIN: $_pin');
    }
  }
}
```

---

## Example 4: Clipboard/Paste Handling

### v8.x
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ClipboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinCodeTextField(
        appContext: context,
        length: 6,
        showPasteConfirmationDialog: true,
        dialogConfig: DialogConfig(
          dialogTitle: 'Paste Code',
          dialogContent: 'Do you want to paste this code?',
          affirmativeText: 'Paste',
          negativeText: 'Cancel',
        ),
        beforeTextPaste: (text) {
          // Return true to allow paste
          return text != null && text.length == 6;
        },
        pinTheme: PinTheme.defaults(),
      ),
    );
  }
}
```

### v9.0.0
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ClipboardScreen extends StatefulWidget {
  @override
  State<ClipboardScreen> createState() => _ClipboardScreenState();
}

class _ClipboardScreenState extends State<ClipboardScreen> {
  final _controller = PinInputController();
  String? _clipboardCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClipboardFound(String code) {
    setState(() => _clipboardCode = code);
  }

  void _pasteCode() {
    if (_clipboardCode != null) {
      _controller.setText(_clipboardCode!);
      setState(() => _clipboardCode = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MaterialPinField(
            length: 6,
            pinController: _controller,
            onClipboardFound: _handleClipboardFound,
            clipboardValidator: (text, length) {
              // Custom validation for clipboard content
              return text.length == length &&
                     RegExp(r'^\d+$').hasMatch(text);
            },
            theme: MaterialPinTheme(),
          ),
          if (_clipboardCode != null)
            FilledButton.icon(
              onPressed: _pasteCode,
              icon: Icon(Icons.content_paste),
              label: Text('Paste $_clipboardCode'),
            ),
        ],
      ),
    );
  }
}
```

---

## Example 5: Custom UI with Headless PinInput (v9.0.0 only)

### v9.0.0 (New Feature)
```dart
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinInput(
        length: 4,
        builder: (context, cells) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cells.map((cell) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: cell.isError
                      ? Colors.red.shade50
                      : cell.isFocused
                          ? Colors.blue.shade50
                          : cell.isFilled
                              ? Colors.green.shade50
                              : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: cell.isFocused ? 2 : 1,
                    color: cell.isError
                        ? Colors.red
                        : cell.isFocused
                            ? Colors.blue
                            : cell.isFilled
                                ? Colors.green
                                : Colors.grey.shade300,
                  ),
                  boxShadow: cell.isFocused
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: cell.isFocused && cell.character == null
                      ? _BlinkingCursor()
                      : AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          child: Text(
                            cell.character ?? '',
                            key: ValueKey(cell.character),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: cell.isError
                                  ? Colors.red
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                ),
              );
            }).toList(),
          );
        },
        onCompleted: (pin) => print('PIN: $pin'),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 24,
        color: Colors.blue,
      ),
    );
  }
}
```

---

## Summary

| Feature | v8.x | v9.0.0 |
|---------|------|--------|
| Basic PIN | `PinCodeTextField` | `MaterialPinField` |
| Error handling | Stream + manual text | `controller.triggerError()` |
| Form validation | Built-in | `PinInputFormField` wrapper |
| Paste dialog | Built-in dialog | `onClipboardFound` callback |
| Custom UI | Limited | Full control with `PinInput` |
| Theme | `PinTheme` | `MaterialPinTheme` + ColorScheme |
