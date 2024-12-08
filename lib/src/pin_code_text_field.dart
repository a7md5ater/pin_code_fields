import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinCodeTextField extends StatefulWidget {
  final int length;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  final TextEditingController? controller;
  final bool obscureText;
  final BoxDecoration? pinBoxDecoration;
  final TextStyle? textStyle;
  final Color? cursorColor;
  final double? cursorHeight;
  final double? cursorWidth;
  final EdgeInsets? padding;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool showContextMenu;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  const PinCodeTextField({
    Key? key,
    required this.length,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.obscureText = false,
    this.pinBoxDecoration,
    this.textStyle,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth,
    this.padding,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.showContextMenu = true,
    this.contextMenuBuilder,
  }) : super(key: key);

  @override
  State<PinCodeTextField> createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late List<String> _pin;
  final GlobalKey _editableTextKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _pin = List.filled(widget.length, '');
    
    _controller.addListener(_updatePinState);
  }

  void _updatePinState() {
    setState(() {
      final text = _controller.text;
      _pin = List.filled(widget.length, '');
      for (int i = 0; i < text.length && i < widget.length; i++) {
        _pin[i] = text[i];
      }
    });

    if (_controller.text.length == widget.length) {
      widget.onCompleted?.call(_controller.text);
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // Default context menu builder when no custom builder is provided
  Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.length,
              (index) => _buildPinBox(index),
            ),
          ),
          Positioned.fill(
            child: EditableText(
              key: _editableTextKey,
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.transparent, fontSize: 0),
              cursorColor: Colors.transparent,
              backgroundCursorColor: Colors.transparent,
              keyboardType: widget.keyboardType,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.length),
                ...?widget.inputFormatters,
              ],
              autofocus: widget.autofocus,
              readOnly: false,
              contextMenuBuilder: widget.showContextMenu
                  ? (widget.contextMenuBuilder ?? _defaultContextMenuBuilder)
                  : null,
              onChanged: (value) {
                // This is handled by the controller listener
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinBox(int index) {
    final isFocused = _focusNode.hasFocus && index == _controller.text.length;
    final hasValue = index < _controller.text.length;

    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: widget.pinBoxDecoration ??
          BoxDecoration(
            border: Border.all(
              color: isFocused ? Theme.of(context).primaryColor : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
      padding: widget.padding ?? const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.obscureText && hasValue ? '•' : _pin[index],
            style: widget.textStyle ??
                Theme.of(context).textTheme.headlineSmall,
          ),
          if (isFocused)
            Container(
              width: widget.cursorWidth ?? 2,
              height: widget.cursorHeight ?? 24,
              decoration: BoxDecoration(
                color: widget.cursorColor ?? Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
