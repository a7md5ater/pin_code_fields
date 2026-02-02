# Migration Resources for pin_code_fields v9.0.0

This directory contains migration resources to help you upgrade from v8.x to v9.0.0.

## Contents

| File | Description |
|------|-------------|
| [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) | Complete migration guide with step-by-step instructions |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Printable quick reference card for common changes |
| [EXAMPLES.md](EXAMPLES.md) | Real-world before/after code examples |
| [migrate.dart](migrate.dart) | Automated migration helper script |

## Quick Start

### 1. Run the Migration Helper

**Option A: Download and run the script**

```bash
# Download the migration script
curl -O https://raw.githubusercontent.com/adar2378/pin_code_fields/master/packages/pin_code_fields/migration/9.0.0/migrate.dart

# Run on your lib/ directory (dry run - shows issues only)
dart run migrate.dart lib/

# Apply automatic fixes
dart run migrate.dart lib/ --apply

# Clean up
rm migrate.dart
```

**Option B: Clone the repository**

```bash
# Clone the repo
git clone https://github.com/adar2378/pin_code_fields.git --depth 1

# Run the migration script
dart run pin_code_fields/packages/pin_code_fields/migration/9.0.0/migrate.dart /path/to/your/project/lib/

# Clean up
rm -rf pin_code_fields
```

**Option C: Use IDE Find & Replace**

See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for regex patterns you can use in your IDE's find & replace.

### 2. Review the Changes

The script will:
- **Auto-fix** simple renames (widget names, enum values, property names)
- **Flag** changes requiring manual intervention (marked with ⚠️)

### 3. Handle Manual Changes

Some changes require manual updates:
- Converting `TextEditingController` + `FocusNode` to `PinInputController`
- Combining `fieldWidth`/`fieldHeight` into `cellSize: Size(w, h)`
- Moving form validation to `PinInputFormField` wrapper
- Replacing error stream with `controller.triggerError()`

## Key Changes Summary

```
Widget:    PinCodeTextField → MaterialPinField
Theme:     PinTheme → MaterialPinTheme
Controller: TextEditingController → PinInputController
Size:      fieldWidth + fieldHeight → cellSize: Size(w, h)
Shapes:    PinCodeFieldShape.box → MaterialPinShape.outlined
Colors:    activeColor → filledBorderColor
           selectedColor → focusedBorderColor
           inactiveColor → borderColor
Error:     StreamController → controller.triggerError()
Form:      Built-in validator → PinInputFormField wrapper
```

## Need Help?

- [Full Documentation](https://pub.dev/documentation/pin_code_fields/latest/)
- [GitHub Issues](https://github.com/adar2378/pin_code_fields/issues)
- [Example App](../example/)
