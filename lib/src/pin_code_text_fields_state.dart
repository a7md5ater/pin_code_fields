part of pin_code_text_fields;

class _PinCodeTextFieldState extends State<PinCodeTextField>
    with
        TickerProviderStateMixin // Use TickerProviderStateMixin for animations
    implements
        TextSelectionGestureDetectorBuilderDelegate {
  // Implement delegate

  TextEditingController? _textEditingController;
  late FocusNode _focusNode;
  // REMOVED _inputList, _selectedIndex

  // --- Delegate Properties ---
  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  // Determines if selection-related gestures should be enabled.
  @override
  bool get selectionEnabled => widget.enableContextMenu && !widget.readOnly;

  @override
  bool get forcePressEnabled => false; // Keep false generally

  // The builder for handling selection gestures.
  late final TextSelectionGestureDetectorBuilder _gestureDetectorBuilder;

  // --- Animation Controllers ---
  late AnimationController
      _errorAnimationController; // Renamed from _controller
  late Animation<Offset> _offsetAnimation; // For shake animation
  // REMOVED _cursorController, _cursorAnimation (using simple cursor now)
  Timer? _blinkDebounce;
  bool _hasBlinked = true; // For blinkWhenObscuring

  // --- State ---
  bool isInErrorMode = false;
  // Text state is now directly from _textEditingController.text

  // --- Styles ---
  // Calculate styles based on PinTheme and textStyle in build or helpers
  TextStyle get _textStyle =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          .merge(widget.textStyle);
  TextStyle get _hintStyle => _textStyle
      .copyWith(
          color: widget.pinTheme.disabledColor) // Use disabled color for hint
      .merge(widget.hintStyle);
  bool get _hintAvailable => widget.hintCharacter != null;

  @override
  void initState() {
    super.initState();
    _assignController(); // Initialize controller & ADD LISTENER
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode!.addListener(_onFocusChanged);

    // Initialize the gesture detector builder
    _gestureDetectorBuilder =
        TextSelectionGestureDetectorBuilder(delegate: this);

    // Initialize error animation controller
    _errorAnimationController = AnimationController(
      duration: Duration(milliseconds: widget.errorAnimationDuration),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(.1, 0.0),
    ).animate(CurvedAnimation(
      parent: _errorAnimationController,
      curve: Curves.elasticIn,
    ));
    _errorAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _errorAnimationController.reverse();
      }
    });

    // Listen to external error controller if provided
    // No need to check mounted here as initState runs before dispose
    if (widget.errorAnimationController != null) {
      _errorAnimationSubscription =
          widget.errorAnimationController!.stream.listen(_handleErrorAnimation);
    }

    // Set initial selection directly
    // Ensure controller is initialized before accessing it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check mounted after frame callback
        _controller.selection =
            TextSelection.collapsed(offset: _controller.text.length);
      }
    });

    // Handle autofocus AFTER the first frame
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check mounted AND focus status before requesting
        if (mounted && _focusNode != null && !_focusNode!.hasFocus) {
          _requestFocusSafely(); // Use the safe request method
        }
      });
    }
    // --- REMOVED THIS LINE ---
    // _textEditingControllerListener(); // DO NOT CALL LISTENER HERE
    // -------------------------
  }

  // Add the safe focus request method (if not already present)
  void _requestFocusSafely() {
    // Ensure context is valid and widget is mounted before requesting focus
    // Check _focusNode isn't null either
    if (mounted && _focusNode != null && _focusNode!.context != null) {
      FocusScope.of(context).requestFocus(_focusNode);
    } else if (mounted && _focusNode != null) {
      // Fallback if context isn't immediately ready after frame callback
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted && _focusNode != null && _focusNode!.context != null) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
    }
  }

  // Helper to get the effective controller
  TextEditingController get _controller => _textEditingController!;

  StreamSubscription<ErrorAnimationType>? _errorAnimationSubscription;

  void _handleErrorAnimation(ErrorAnimationType errorAnimation) {
    if (errorAnimation == ErrorAnimationType.shake) {
      _errorAnimationController.forward();
      _setState(() => isInErrorMode = true);
    } else if (errorAnimation == ErrorAnimationType.clear) {
      _setState(() => isInErrorMode = false);
    }
  }

  void _assignController() {
    if (widget.controller == null) {
      _textEditingController = TextEditingController();
      // print("PinCodeTextField initialized with internal TextEditingController.");
    } else {
      _textEditingController = widget.controller;
      // print("PinCodeTextField initialized with provided TextEditingController.");
    }
    _textEditingController!.addListener(_textEditingControllerListener);
    // Ensure initial text doesn't exceed length
    final initialText = _getLimitedText(_textEditingController!.text);
    if (initialText != _textEditingController!.text) {
      // Use scheduler binding to avoid issues during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = initialText;
        }
      });
    }
  }

  void _onFocusChanged() {
    if (!_focusNode!.hasFocus) {
      editableTextKey.currentState?.hideToolbar();
      if (widget.autoDismissKeyboard) {
        // Consider if unfocus should happen here or on complete only
      }
    }
    _setState(() {}); // Rebuild for visual changes
  }

  // Central handler for text changes from the controller
  void _textEditingControllerListener() {
    if (!mounted) return; // Avoid calling if disposed

    // Apply haptic feedback if enabled
    if (widget.useHapticFeedback) _runHapticFeedback();

    // Clear error state on text change
    if (isInErrorMode) _setState(() => isInErrorMode = false);

    final currentText = _controller.text;
    final limitedText = _getLimitedText(currentText);

    // 1. Validate and correct the controller's value if needed
    if (currentText != limitedText) {
      // This correction will trigger the listener again.
      // Schedule the correction after the current frame to avoid conflicts.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.value = TextEditingValue(
            text: limitedText,
            selection: TextSelection.collapsed(offset: limitedText.length),
          );
        }
      });
      return; // Exit early, the correction will re-trigger the listener
    }

    // 2. Update internal state (_text is removed, rely on controller) and call callbacks
    // Check if the *valid* text length has changed meaningfully for completion check
    final previousLength = _controller
        .value.text.length; // Might need to track previous length more reliably
    final currentLength = limitedText.length;

    // Call onChanged regardless of completion
    widget.onChanged?.call(limitedText);

    // Check for completion
    if (currentLength == widget.length && previousLength < widget.length) {
      widget.onCompleted?.call(limitedText);
      if (widget.autoDismissKeyboard) {
        _focusNode?.unfocus();
      }
    }

    // Handle blink effect
    _debounceBlink();

    // Trigger rebuild if necessary (visual state depends on text length/focus)
    _setState(() {});
  }

  // Applies length and character filtering
  String _getLimitedText(String text) {
    // Apply filters first (e.g., digits only)
    String filteredText = widget.keyboardType == TextInputType.number
        ? text.replaceAll(RegExp(r'[^0-9]'), '') // Example filter
        : text;
    // Apply other formatters if needed (more complex)
    // widget.inputFormatters.forEach((formatter) { ... });

    // Apply length limit
    return filteredText.length > widget.length
        ? filteredText.substring(0, widget.length)
        : filteredText;
  }

  void _debounceBlink() {
    if (widget.blinkWhenObscuring && _controller.text.isNotEmpty) {
      // Check if text is not empty
      // Determine if the last character was just added
      // This requires comparing with a previous value, which is tricky without _inputList
      // Simplification: Blink whenever text length increases
      // A better approach might involve comparing selection or previous text length.
      // Let's assume for now blink happens if length increased (imperfect)
      // This part needs refinement if precise blink-on-new-char is essential.

      // Simple blink logic for now:
      _setState(() {
        _hasBlinked = false;
      });
      _blinkDebounce?.cancel();
      _blinkDebounce = Timer(widget.blinkDuration, () {
        if (mounted)
          _setState(() {
            _hasBlinked = true;
          });
      });
    } else if (!widget.blinkWhenObscuring && !_hasBlinked) {
      // Ensure hasBlinked is true if blinking is disabled
      _setState(() {
        _hasBlinked = true;
      });
    }
  }

  void _runHapticFeedback() {
    switch (widget.hapticFeedbackTypes) {
      case HapticFeedbackTypes.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackTypes.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackTypes.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackTypes.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticFeedbackTypes.vibrate:
        HapticFeedback.vibrate();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _errorAnimationSubscription?.cancel();
    _errorAnimationController.dispose();
    _blinkDebounce?.cancel();
    _textEditingController?.removeListener(_textEditingControllerListener);

    if (widget.autoDisposeControllers) {
      _textEditingController?.dispose();
      _focusNode?.dispose();
    } else {
      // Only remove listener if not disposing focus node provided externally
      _focusNode?.removeListener(_onFocusChanged);
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PinCodeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Simplified update logic, focusing on critical changes

    // Controller change
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_textEditingControllerListener);
      _assignController(); // Re-assign and add listener
    }

    // FocusNode change
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChanged);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode!.addListener(_onFocusChanged);
    }

    // Length change
    if (widget.length != oldWidget.length) {
      // Force re-evaluation and potential truncation of text
      _textEditingControllerListener();
      setState(() {}); // Ensure rebuild for new length
    }

    // Error stream change
    if (widget.errorAnimationController != oldWidget.errorAnimationController) {
      _errorAnimationSubscription?.cancel();
      if (widget.errorAnimationController != null) {
        _errorAnimationSubscription = widget.errorAnimationController!.stream
            .listen(_handleErrorAnimation);
      }
    }

    // Rebuild if readOnly or enableContextMenu changes as it affects behavior
    if (widget.readOnly != oldWidget.readOnly ||
        widget.enableContextMenu != oldWidget.enableContextMenu) {
      setState(() {});
    }
    // Note: PinTheme changes don't require explicit handling here,
    // the build method will use the new theme automatically.
  }

  // --- Visual Build Methods ---

  // Generates the row of pin code fields
  List<Widget> _generateFields() {
    var result = <Widget>[];
    final text = _controller.text;
    final textLength = text.length;
    final hasFocus = _focusNode?.hasFocus ?? false;

    for (int i = 0; i < widget.length; i++) {
      bool isSelected = hasFocus && (i == textLength); // Cursor position
      bool isFilled = i < textLength;
      bool isCurrent =
          i == textLength; // Is this the cell where the next char will go?
      bool isLast = i == widget.length - 1;
      bool isFocusedCell =
          hasFocus && (isCurrent || (textLength == widget.length && isLast));

      Color borderColor = widget.pinTheme.inactiveColor;
      Color fillColor = widget.pinTheme.inactiveFillColor;
      double borderWidth = widget.pinTheme.inactiveBorderWidth;
      List<BoxShadow>? boxShadow = widget.pinTheme.inActiveBoxShadows;

      if (!widget.enabled || widget.readOnly) {
        borderColor = widget.pinTheme.disabledColor;
        fillColor =
            widget.pinTheme.disabledColor; // Or a specific disabled fill color
        borderWidth = widget.pinTheme.disabledBorderWidth;
      } else if (isInErrorMode) {
        borderColor = widget.pinTheme.errorBorderColor;
        fillColor = widget.pinTheme.inactiveFillColor; // Or specific error fill
        borderWidth = widget.pinTheme.errorBorderWidth;
      } else if (hasFocus && isFocusedCell) {
        borderColor = widget.pinTheme.selectedColor;
        fillColor = widget.pinTheme.selectedFillColor;
        borderWidth = widget.pinTheme.selectedBorderWidth;
        boxShadow = widget.pinTheme
            .activeBoxShadows; // Use active shadows when selected? Or specific selected shadows?
      } else if (isFilled) {
        borderColor = widget.pinTheme.activeColor;
        fillColor = widget.pinTheme.activeFillColor;
        borderWidth = widget.pinTheme.activeBorderWidth;
        boxShadow = widget.pinTheme.activeBoxShadows;
      }

      final pinTheme = widget.pinTheme; // Use the main theme

      result.add(
        Container(
          padding: pinTheme.fieldOuterPadding,
          child: AnimatedContainer(
            curve: widget.animationCurve,
            duration: widget.animationDuration,
            width: pinTheme.fieldWidth,
            height: pinTheme.fieldHeight,
            decoration: BoxDecoration(
              color: widget.enableActiveFill ? fillColor : Colors.transparent,
              boxShadow: boxShadow ?? widget.boxShadows,
              shape: pinTheme.shape == PinCodeFieldShape.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              borderRadius: pinTheme.shape != PinCodeFieldShape.circle &&
                      pinTheme.shape != PinCodeFieldShape.underline
                  ? pinTheme.borderRadius
                  : null, // Apply border radius only for box shape
              border: pinTheme.shape == PinCodeFieldShape.underline
                  ? Border(
                      bottom:
                          BorderSide(color: borderColor, width: borderWidth))
                  : Border.all(color: borderColor, width: borderWidth),
            ),
            alignment: Alignment.center, // Center content
            child: _buildCellChild(i, isSelected, isFilled),
          ),
        ),
      );

      // Add separator if needed
      if (widget.separatorBuilder != null && i < widget.length - 1) {
        result.add(widget.separatorBuilder!(context, i));
      }
    }
    return result;
  }

  // Builds the content of a single cell (character, cursor, hint, obscure widget)
  Widget _buildCellChild(int index, bool isSelected, bool isFilled) {
    Widget content;

    // Determine if obscuring applies
    bool showObscured = widget.obscureText &&
        (!widget.blinkWhenObscuring ||
            (widget.blinkWhenObscuring && _hasBlinked) ||
            index !=
                _controller.text.length -
                    1); // Don't obscure the very last typed char during blink

    if (isFilled) {
      if (showObscured && widget.obscuringWidget != null) {
        // Use obscuring widget
        content = widget.obscuringWidget!;
      } else {
        // Use character (obscured or plain)
        final char =
            showObscured ? widget.obscuringCharacter : _controller.text[index];
        final style = _textStyle;
        content = widget.textGradient != null
            ? Gradiented(
                gradient: widget.textGradient!,
                child: Text(char,
                    key: ValueKey(char + index.toString()),
                    style: style.copyWith(color: Colors.white)))
            : Text(char,
                key: ValueKey(char + index.toString()),
                style: style); // Use ValueKey with index too
      }
    } else if (isSelected && widget.showCursor && !widget.readOnly) {
      // Show cursor
      final cursorColor = widget.cursorColor ??
          Theme.of(context).textSelectionTheme.cursorColor ??
          Theme.of(context).colorScheme.secondary;
      final cursorHeight = widget.cursorHeight ?? _textStyle.fontSize! + 8;
      // Simple cursor implementation from POC
      content = Center(
        child: Container(
          width: widget.cursorWidth,
          height: cursorHeight,
          color: cursorColor,
          // Add pulsing animation here later if desired, using another controller
        ),
      );
    } else if (_hintAvailable) {
      // Show hint character
      content = Text(widget.hintCharacter!,
          key: ValueKey('hint_$index'), style: _hintStyle);
    } else {
      // Empty cell
      content = Text('', key: ValueKey('empty_$index'));
    }

    // Apply animation transition
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      switchInCurve: widget.animationCurve,
      switchOutCurve: widget.animationCurve,
      transitionBuilder: (child, animation) {
        if (widget.animationType == AnimationType.scale) {
          return ScaleTransition(scale: animation, child: child);
        } else if (widget.animationType == AnimationType.fade) {
          return FadeTransition(opacity: animation, child: child);
        } else if (widget.animationType == AnimationType.none) {
          return child;
        } else {
          // Slide is default
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, .5), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        }
      },
      child: content,
    );
  }

  // --- TextSelectionGestureDetectorBuilderDelegate Methods ---
  // (Copied from the working POC, adjusted slightly)

  @override
  void onSingleTapUp(TapUpDetails details) {
    if (widget.readOnly) return;
    editableTextKey.currentState?.hideToolbar();
    if (!_focusNode!.hasFocus) FocusScope.of(context).requestFocus(_focusNode);
    // Trigger custom onTap if provided
    widget.onTap?.call();
    // Move cursor to end
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.readOnly) {
        _controller.selection =
            TextSelection.collapsed(offset: _controller.text.length);
      }
    });
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (selectionEnabled) {
      // Feedback.forLongPress(context); // Add haptic feedback if needed
      editableTextKey.currentState?.showToolbar();
    }
  }

  @override
  void onDragSelectionStart(DragStartDetails details) {
    if (selectionEnabled) editableTextKey.currentState?.showToolbar();
  }

  @override
  void onDragSelectionUpdate(DragStartDetails start, DragUpdateDetails update) {
    if (selectionEnabled) editableTextKey.currentState?.showToolbar();
  }

  @override
  void onDragSelectionEnd(DragEndDetails details) {}
  @override
  void onForcePressStart(ForcePressDetails details) {
    if (selectionEnabled) editableTextKey.currentState?.showToolbar();
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {}
  @override
  void onSecondaryTap() {
    if (selectionEnabled) editableTextKey.currentState?.showToolbar();
  }

  @override
  void onSecondaryTapUp(TapUpDetails details) {
    if (selectionEnabled) editableTextKey.currentState?.showToolbar();
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (selectionEnabled) editableTextKey.currentState?.showToolbar();
  }

  @override
  void onSingleLongTapEnd(LongPressEndDetails details) {}

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause? cause) {
    if (widget.readOnly) return;
    // Always force selection to be collapsed at the end
    if (_controller.selection.baseOffset != _controller.text.length ||
        _controller.selection.extentOffset != _controller.text.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.selection =
              TextSelection.collapsed(offset: _controller.text.length);
        }
      });
    }
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    // Platform-specific controls if none provided
    final platform = Theme.of(context).platform;
    final TextSelectionControls selectionControls = widget.selectionControls ??
        switch (platform) {
          TargetPlatform.iOS ||
          TargetPlatform.macOS =>
            cupertinoTextSelectionHandleControls,
          TargetPlatform.android ||
          TargetPlatform.fuchsia =>
            materialTextSelectionHandleControls,
          TargetPlatform.linux ||
          TargetPlatform.windows =>
            desktopTextSelectionHandleControls,
        };

    // Build using the gesture detector
    return SlideTransition(
      // Wrap with error shake animation
      position: _offsetAnimation,
      child: _gestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          // Use SizedBox to constrain height if error text is not needed/handled externally
          height: widget.pinTheme.fieldHeight, // Use theme height
          child: Stack(
            alignment: Alignment
                .center, // Or Alignment.topCenter if error text was below
            children: [
              // --- Layer 1: Visual Cells ---
              Row(
                mainAxisAlignment: widget.mainAxisAlignment,
                mainAxisSize: MainAxisSize.min, // Important for centering Row
                children: _generateFields(),
              ),

              // --- Layer 2: Functionality via EditableText ---
              Padding(
                // Padding to ensure EditableText covers the cells for interaction
                padding: EdgeInsets.symmetric(
                    horizontal: widget.pinTheme.fieldOuterPadding.horizontal /
                        2), // Adjust as needed
                child: SizedBox(
                  // Constrain the invisible text field approximately
                  // Precise calculation might be needed based on separators
                  width: (widget.pinTheme.fieldWidth +
                          widget.pinTheme.fieldOuterPadding.horizontal) *
                      widget.length,
                  height: widget.pinTheme.fieldHeight +
                      widget.pinTheme.fieldOuterPadding.vertical,
                  child: EditableText(
                    key: editableTextKey,
                    controller: _controller,
                    focusNode: _focusNode,
                    readOnly: widget.readOnly,
                    // Styling & Behavior from POC
                    style: const TextStyle(
                        color: Colors.transparent, fontSize: 0.1, height: 0),
                    cursorColor: Colors.transparent,
                    backgroundCursorColor: Colors.transparent,
                    selectionColor: Colors.transparent,
                    showCursor: false,
                    showSelectionHandles: false,
                    rendererIgnoresPointer: true,
                    enableInteractiveSelection: selectionEnabled,
                    selectionControls:
                        selectionEnabled ? selectionControls : null,
                    contextMenuBuilder:
                        selectionEnabled ? widget.contextMenuBuilder : null,
                    // Standard Properties mapped from widget
                    keyboardType: widget.keyboardType,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          widget.length), // Ensure length limit first
                      ...widget.inputFormatters, // Add custom formatters
                      if (widget.keyboardType == TextInputType.number)
                        FilteringTextInputFormatter
                            .digitsOnly, // Apply digit filter last if needed
                    ],
                    autofocus: false, // Handled in initState
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: widget.textCapitalization,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onSubmitted, // Pass through callbacks
                    onEditingComplete: widget.onEditingComplete,
                    onSelectionChanged: _handleSelectionChanged,
                    keyboardAppearance: widget.keyboardAppearance ??
                        Theme.of(context).brightness,
                    scrollPadding: widget.scrollPadding,
                    // Autofill integration needed here if enablePinAutofill is true
                    // autofillHints: widget.enablePinAutofill ? [AutofillHints.oneTimeCode] : null,
                    // Need to implement AutofillClient if using Autofill
                    textAlign: TextAlign
                        .center, // Helps with logical cursor positioning
                    maxLines: 1,
                    clipBehavior:
                        Clip.none, // Allow potential overflow for calculations
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to prevent setState calls when the widget is disposed
  void _setState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
