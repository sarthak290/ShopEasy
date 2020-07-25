import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PinEntryType { underline, boxTight, boxLoose }

abstract class PinDecoration {
  
  final TextStyle textStyle;

  
  final ObscureStyle obscureStyle;

    final String errorText;

 
  final TextStyle errorTextStyle;

  final String hintText;

  final TextStyle hintTextStyle;

  PinEntryType get pinEntryType;

  const PinDecoration({
    this.textStyle,
    this.obscureStyle,
    this.errorText,
    this.errorTextStyle,
    this.hintText,
    this.hintTextStyle,
  });

  PinDecoration copyWith({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
  });
}

class ObscureStyle {
  static final _wrapLine = '\n';

  final bool isTextObscure;

  
  final String obscureText;

  ObscureStyle({
    this.isTextObscure: false,
    this.obscureText: '*',
  })  :

        
        assert(obscureText.length > 0),
        assert(obscureText.indexOf(_wrapLine) == -1);
}

class UnderlineDecoration extends PinDecoration {
  final double gapSpace;


  final List<double> gapSpaces;

  
  final Color color;

  final double lineHeight;

 
  final Color enteredColor;

  const UnderlineDecoration({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
    this.enteredColor,
    this.gapSpace: 16.0,
    this.gapSpaces,
    this.color: Colors.cyan,
    this.lineHeight: 2.0,
  }) : super(
          textStyle: textStyle,
          obscureStyle: obscureStyle,
          errorText: errorText,
          errorTextStyle: errorTextStyle,
          hintText: hintText,
          hintTextStyle: hintTextStyle,
        );

  @override
  PinEntryType get pinEntryType => PinEntryType.underline;

  @override
  PinDecoration copyWith({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
  }) {
    return UnderlineDecoration(
      textStyle: textStyle ?? this.textStyle,
      obscureStyle: obscureStyle ?? this.obscureStyle,
      errorText: errorText ?? this.errorText,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      hintText: hintText ?? this.hintText,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      enteredColor: this.enteredColor,
      color: this.color,
      gapSpace: this.gapSpace,
      lineHeight: this.lineHeight,
      gapSpaces: this.gapSpaces,
    );
  }
}

class BoxTightDecoration extends PinDecoration {
  final double strokeWidth;

  final Radius radius;

  final Color strokeColor;

  final Color solidColor;

  const BoxTightDecoration({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
    this.solidColor,
    this.strokeWidth: 1.0,
    this.radius: const Radius.circular(8.0),
    this.strokeColor: Colors.cyan,
  }) : super(
          textStyle: textStyle,
          obscureStyle: obscureStyle,
          errorText: errorText,
          errorTextStyle: errorTextStyle,
          hintText: hintText,
          hintTextStyle: hintTextStyle,
        );

  @override
  PinEntryType get pinEntryType => PinEntryType.boxTight;

  @override
  PinDecoration copyWith({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
  }) {
    return BoxTightDecoration(
      textStyle: textStyle ?? this.textStyle,
      obscureStyle: obscureStyle ?? this.obscureStyle,
      errorText: errorText ?? this.errorText,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      hintText: hintText ?? this.hintText,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      solidColor: this.solidColor,
      strokeColor: this.strokeColor,
      strokeWidth: this.strokeWidth,
      radius: this.radius,
    );
  }
}

class BoxLooseDecoration extends PinDecoration {
  final Radius radius;

  final double strokeWidth;

  final double gapSpace;

 
  final List<double> gapSpaces;

  final Color strokeColor;

  final Color solidColor;

  final Color enteredColor;

  const BoxLooseDecoration({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
    this.enteredColor,
    this.solidColor,
    this.radius: const Radius.circular(8.0),
    this.strokeWidth: 1.0,
    this.gapSpace: 16.0,
    this.gapSpaces,
    this.strokeColor: Colors.cyan,
  }) : super(
          textStyle: textStyle,
          obscureStyle: obscureStyle,
          errorText: errorText,
          errorTextStyle: errorTextStyle,
          hintText: hintText,
          hintTextStyle: hintTextStyle,
        );

  @override
  PinEntryType get pinEntryType => PinEntryType.boxLoose;

  @override
  PinDecoration copyWith({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
  }) {
    return BoxLooseDecoration(
      textStyle: textStyle ?? this.textStyle,
      obscureStyle: obscureStyle ?? this.obscureStyle,
      errorText: errorText ?? this.errorText,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      hintText: hintText ?? this.hintText,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      solidColor: this.solidColor,
      strokeColor: this.strokeColor,
      strokeWidth: this.strokeWidth,
      radius: this.radius,
      enteredColor: this.enteredColor,
      gapSpace: this.gapSpace,
      gapSpaces: this.gapSpaces,
    );
  }
}

class PinInputTextField extends StatefulWidget {
  final int pinLength;

  final ValueChanged<String> onSubmit;

  final PinDecoration decoration;

  final List<TextInputFormatter> inputFormatters;

  final TextInputType keyboardType;

  final TextEditingController controller;

  final bool autoFocus;

  final FocusNode focusNode;

  final TextInputAction textInputAction;


  final bool enabled;
  final ValueChanged<String> onChanged;

  PinInputTextField({
    Key key,
    this.pinLength: 6,
    this.onSubmit,
    this.decoration: const BoxLooseDecoration(),
    List<TextInputFormatter> inputFormatter,
    this.keyboardType: TextInputType.phone,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.onChanged,
  })  :

        assert(pinLength != null && pinLength > 0),
        assert(decoration != null),

        assert(decoration.hintText == null ||
            decoration.hintText.length == pinLength),
        assert(decoration is BoxTightDecoration ||
            (decoration is UnderlineDecoration &&
                pinLength - 1 ==
                    (decoration.gapSpaces?.length ?? (pinLength - 1))) ||
            (decoration is BoxLooseDecoration &&
                pinLength - 1 ==
                    (decoration.gapSpaces?.length ?? (pinLength - 1)))),
        inputFormatters = inputFormatter == null
            ? <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(pinLength)
              ]
            : inputFormatter
          ..add(LengthLimitingTextInputFormatter(pinLength)),
        super(key: key);

  @override
  State createState() {
    return _PinInputTextFieldState();
  }
}

class _PinInputTextFieldState extends State<PinInputTextField> {
  String _text;

  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  void _pinChanged() {
    setState(() {
      _updateText();

    });
  }

  void _updateText() {
    if (_effectiveController.text.runes.length > widget.pinLength) {
      _text = String.fromCharCodes(
          _effectiveController.text.runes.take(widget.pinLength));
    } else {
      _text = _effectiveController.text;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveController.addListener(_pinChanged);

    _updateText();
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_pinChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(PinInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller.removeListener(_pinChanged);
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
      _controller.addListener(_pinChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller.removeListener(_pinChanged);
      _controller = null;
      widget.controller.addListener(_pinChanged);
      if (_text != widget.controller.text) {
        _pinChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_pinChanged);
      widget.controller.addListener(_pinChanged);
    }

    if (oldWidget.pinLength > widget.pinLength &&
        _text.runes.length > widget.pinLength) {
      setState(() {
        _text = _text.substring(0, widget.pinLength);
        _effectiveController.text = _text;
        _effectiveController.selection =
            TextSelection.collapsed(offset: _text.runes.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _PinPaint(
          text: _text ?? _text.trim(),
          pinLength: widget.pinLength,
          decoration: widget.decoration,
          themeData: Theme.of(context)),
      child: TextField(
       
        controller: _effectiveController,

        
        style: TextStyle(
        
  color: Colors.transparent,
          fontSize: 1,
        ),

        
cursorColor: Colors.transparent,

        cursorWidth: 0.0,

        
autocorrect: false,

        
textAlign: TextAlign.center,

        
enableInteractiveSelection: false,

        
maxLength: widget.pinLength,

        
onSubmitted: widget.onSubmit,

        
keyboardType: widget.keyboardType,

        
inputFormatters: widget.inputFormatters,

        
focusNode: widget.focusNode,

        
autofocus: widget.autoFocus,

        
textInputAction: widget.textInputAction,

        
obscureText: true,

        onChanged: widget.onChanged,

        
decoration: InputDecoration(
        
  counterText: '',

        
  border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),

        
  errorText: widget.decoration.errorText,

        
  errorStyle: widget.decoration.errorTextStyle,
        ),
        enabled: widget.enabled,
      ),
    );
  }
}

class _PinPaint extends CustomPainter {
  final String text;
  final int pinLength;
  final PinEntryType type;
  final PinDecoration decoration;
  final ThemeData themeData;

  _PinPaint({
    @required this.text,
    @required this.pinLength,
    PinDecoration decoration,
    this.type: PinEntryType.boxTight,
    this.themeData,
  }) : this.decoration = decoration.copyWith(
          textStyle: decoration.textStyle ?? themeData.textTheme.headline6,
          errorTextStyle: decoration.errorTextStyle ??
              themeData.textTheme.caption.copyWith(color: themeData.errorColor),
          hintTextStyle: decoration.hintTextStyle ??
              themeData.textTheme.headline6
                  .copyWith(color: themeData.hintColor),
        );

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      !(oldDelegate is _PinPaint && oldDelegate.text == this.text);

  _drawBoxTight(Canvas canvas, Size size) {
    
double mainHeight;
    if (decoration.errorText != null && decoration.errorText.isNotEmpty) {
      mainHeight = size.height - (decoration.errorTextStyle.fontSize + 8.0);
    } else {
      mainHeight = size.height;
    }

    
var dr = decoration as BoxTightDecoration;
    Paint borderPaint = Paint()
      ..color = dr.strokeColor
      ..strokeWidth = dr.strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    
Paint insidePaint;
    if (dr.solidColor != null) {
      insidePaint = Paint()
        ..color = dr.solidColor
        ..strokeWidth = dr.strokeWidth
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
    }

    Rect rect = Rect.fromLTRB(
      dr.strokeWidth / 2,
      dr.strokeWidth / 2,
      size.width - dr.strokeWidth / 2,
      mainHeight - dr.strokeWidth / 2,
    );

    if (insidePaint != null) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, dr.radius), insidePaint);
    }

    
canvas.drawRRect(RRect.fromRectAndRadius(rect, dr.radius), borderPaint);

    
double singleWidth =
        (size.width - dr.strokeWidth * (pinLength + 1)) / pinLength;

    for (int i = 1; i < pinLength; i++) {
      double offsetX = singleWidth +
          dr.strokeWidth * i +
          dr.strokeWidth / 2 +
          singleWidth * (i - 1);
      canvas.drawLine(Offset(offsetX, dr.strokeWidth),
          Offset(offsetX, mainHeight - dr.strokeWidth), borderPaint);
    }

    
var index = 0;
    var startY = 0.0;
    var startX = 0.0;

    
bool obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle.isTextObscure;

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: decoration.textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

    
  textPainter.layout();

    
  if (startY == 0.0) {
        startY = mainHeight / 2 - textPainter.height / 2;
      }
      startX = dr.strokeWidth * (index + 1) +
          singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2;
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null) {
      decoration.hintText.substring(index).runes.forEach((rune) {
        String code = String.fromCharCode(rune);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            style: decoration.hintTextStyle,
            text: code,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

    
    textPainter.layout();

        startY = mainHeight / 2 - textPainter.height / 2;
        startX = dr.strokeWidth * (index + 1) +
            singleWidth * index +
            singleWidth / 2 -
            textPainter.width / 2;
        textPainter.paint(canvas, Offset(startX, startY));
        index++;
      });
    }
  }

  _drawBoxLoose(Canvas canvas, Size size) {
    
double mainHeight;
    if (decoration.errorText != null && decoration.errorText.isNotEmpty) {
      mainHeight = size.height - (decoration.errorTextStyle.fontSize + 8.0);
    } else {
      mainHeight = size.height;
    }

    
var dr = decoration as BoxLooseDecoration;
    Paint borderPaint = Paint()
      ..color = dr.strokeColor
      ..strokeWidth = dr.strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    
Paint insidePaint;
    if (dr.solidColor != null) {
      insidePaint = Paint()
        ..color = dr.solidColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
    }

    double gapTotalLength =
        dr.gapSpaces?.reduce((a, b) => a + b) ?? (pinLength - 1) * dr.gapSpace;

    List<double> gapSpaces =
        dr.gapSpaces ?? List.filled(pinLength - 1, dr.gapSpace);

    
double singleWidth =
        (size.width - dr.strokeWidth * 2 * pinLength - gapTotalLength) /
            pinLength;

    var startX = dr.strokeWidth / 2;
    var startY = mainHeight - dr.strokeWidth / 2;

    
for (int i = 0; i < pinLength; i++) {
      if (i < text.length && dr.enteredColor != null) {
        borderPaint.color = dr.enteredColor;
      } else if (decoration.errorText != null &&
          decoration.errorText.isNotEmpty) {
    
    if (dr.solidColor == null) {
          borderPaint.color = decoration.errorTextStyle.color;
        } else {
          insidePaint = Paint()
            ..color = decoration.errorTextStyle.color
            ..style = PaintingStyle.fill
            ..isAntiAlias = true;
        }
      } else {
        borderPaint.color = dr.strokeColor;
      }
      RRect rRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(
            startX,
            dr.strokeWidth / 2,
            startX + singleWidth + dr.strokeWidth,
            startY,
          ),
          dr.radius);
      canvas.drawRRect(rRect, borderPaint);
      if (insidePaint != null) {
        canvas.drawRRect(rRect, insidePaint);
      }
      startX += singleWidth +
          dr.strokeWidth * 2 +
          (i == pinLength - 1 ? 0 : gapSpaces[i]);
    }

    
var index = 0;
    startY = 0.0;

    
bool obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle.isTextObscure;

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: decoration.textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

    
  textPainter.layout();

    
  if (startY == 0.0) {
        startY = mainHeight / 2 - textPainter.height / 2;
      }
      startX = singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2 +
          _sumList(gapSpaces.take(index)) +
          dr.strokeWidth * index * 2 +
          dr.strokeWidth;
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null) {
      decoration.hintText.substring(index).runes.forEach((rune) {
        String code = String.fromCharCode(rune);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            style: decoration.hintTextStyle,
            text: code,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

    
    textPainter.layout();

        startY = mainHeight / 2 - textPainter.height / 2;
        startX = singleWidth * index +
            singleWidth / 2 -
            textPainter.width / 2 +
            _sumList(gapSpaces.take(index)) +
            dr.strokeWidth * index * 2 +
            dr.strokeWidth;
        textPainter.paint(canvas, Offset(startX, startY));
        index++;
      });
    }
  }

  _drawUnderLine(Canvas canvas, Size size) {
    
double mainHeight;
    if (decoration.errorText != null && decoration.errorText.isNotEmpty) {
      mainHeight = size.height - (decoration.errorTextStyle.fontSize + 8.0);
    } else {
      mainHeight = size.height;
    }

    
var dr = decoration as UnderlineDecoration;
    Paint underlinePaint = Paint()
      ..color = dr.color
      ..strokeWidth = dr.lineHeight
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    var startX = 0.0;
    var startY = mainHeight - dr.lineHeight;

    double gapTotalLength =
        dr.gapSpaces?.reduce((a, b) => a + b) ?? (pinLength - 1) * dr.gapSpace;

    List<double> gapSpaces =
        dr.gapSpaces ?? List.filled(pinLength - 1, dr.gapSpace);

    
double singleWidth = (size.width - gapTotalLength) / pinLength;

    for (int i = 0; i < pinLength; i++) {
      if (i < text.length && dr.enteredColor != null) {
        underlinePaint.color = dr.enteredColor;
      } else if (decoration.errorText != null &&
          decoration.errorText.isNotEmpty) {
    
        underlinePaint.color = decoration.errorTextStyle.color;
      } else {
        underlinePaint.color = dr.color;
      }
      canvas.drawLine(Offset(startX, startY),
          Offset(startX + singleWidth, startY), underlinePaint);
      startX += singleWidth + (i == pinLength - 1 ? 0 : gapSpaces[i]);
    }

    
var index = 0;
    startX = 0.0;
    startY = 0.0;

    
bool obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle.isTextObscure;

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: decoration.textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

    
  textPainter.layout();

    
  if (startY == 0.0) {
        startY = mainHeight / 2 - textPainter.height / 2;
      }
      startX = singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2 +
          _sumList(gapSpaces.take(index));
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null) {
      decoration.hintText.substring(index).runes.forEach((rune) {
        String code = String.fromCharCode(rune);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            style: decoration.hintTextStyle,
            text: code,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

    
    textPainter.layout();

        startY = mainHeight / 2 - textPainter.height / 2;
        startX = singleWidth * index +
            singleWidth / 2 -
            textPainter.width / 2 +
            _sumList(gapSpaces.take(index));
        textPainter.paint(canvas, Offset(startX, startY));
        index++;
      });
    }
  }

  
T _sumList<T extends num>(Iterable<T> list) {
    T sum = 0 as T;
    list.forEach((n) => sum += n);
    return sum;
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (decoration.pinEntryType) {
      case PinEntryType.boxTight:
        {
          _drawBoxTight(canvas, size);
          break;
        }
      case PinEntryType.boxLoose:
        {
          _drawBoxLoose(canvas, size);
          break;
        }
      case PinEntryType.underline:
        {
          _drawUnderLine(canvas, size);
          break;
        }
    }
  }
}

class PinInputTextFormField extends FormField<String> {
  
final TextEditingController controller;

  
final int pinLength;

  PinInputTextFormField({
    Key key,
    this.controller,
    String initialValue,
    this.pinLength = 6,
    ValueChanged<String> onSubmit,
    PinDecoration decoration = const BoxLooseDecoration(),
    List<TextInputFormatter> inputFormatter,
    TextInputType keyboardType = TextInputType.phone,
    FocusNode focusNode,
    bool autoFocus = false,
    TextInputAction textInputAction = TextInputAction.done,
    bool enabled = true,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    bool autovalidate = false,
    ValueChanged<String> onChanged,
  })  : assert(initialValue == null || controller == null),
        assert(autovalidate != null),
        assert(pinLength != null && pinLength > 0),
        super(
            key: key,
            initialValue:
                controller != null ? controller.text : (initialValue ?? ''),
            onSaved: onSaved,
            validator: (value) {
              var result = validator(value);
              if (result == null) {
                if (value.isEmpty) {
                  return 'Input field is empty.';
                }
                if (value.length < pinLength) {
                  if (pinLength - value.length > 1) {
                    return 'Missing ${pinLength - value.length} digits of input.';
                  } else {
                    return 'Missing last digit of input.';
                  }
                }
              }
              return result;
            },
            autovalidate: autovalidate,
            enabled: enabled,
            builder: (FormFieldState<String> field) {
              final _PinInputTextFormFieldState state = field;
              return PinInputTextField(
                pinLength: pinLength,
                onSubmit: onSubmit,
                decoration: decoration.copyWith(errorText: field.errorText),
                inputFormatter: inputFormatter,
                keyboardType: keyboardType,
                controller: state._effectiveController,
                focusNode: focusNode,
                autoFocus: autoFocus,
                textInputAction: textInputAction,
                enabled: enabled,
                onChanged: onChanged,
              );
            });

  @override
  _PinInputTextFormFieldState createState() => _PinInputTextFormFieldState();
}

class _PinInputTextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  PinInputTextFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(PinInputTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
      _controller.addListener(_handleControllerChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller.removeListener(_handleControllerChanged);
      _controller = null;
      widget.controller.addListener(_handleControllerChanged);
     
      if (value != widget.controller.text) {
        _handleControllerChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
     
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }

  
  if (oldWidget.pinLength > widget.pinLength &&
        value.runes.length > widget.pinLength) {
      setState(() {
        setValue(value.substring(0, widget.pinLength));
        _effectiveController.text = value;
        _effectiveController.selection = TextSelection.collapsed(
          offset: value.runes.length,
        );
      });
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  @override
  void didChange(String value) {
    if (value.runes.length > widget.pinLength) {
      super.didChange(String.fromCharCodes(
        value.runes.take(widget.pinLength),
      ));
    } else {
      super.didChange(value);
    }
  }

  void _handleControllerChanged() {
  
  if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }
}

