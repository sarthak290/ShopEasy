import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'app_localizations.dart';

class CustomTextWidget extends StatelessWidget {
  final String textKey;
  final TextStyle style;
  final String addText;
  final int maxLines;
  final double maxFontSize, minFontSize;
  final TextAlign textAlign;
  CustomTextWidget(
      {Key key,
      @required this.textKey,
      this.style,
      this.addText = "",
      this.maxFontSize = 18.0,
      this.minFontSize = 12.0,
      this.textAlign = TextAlign.start,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return textKey.isEmpty || textKey == null
        ? Container()
        : AutoSizeText(
            allTranslations.text(textKey) + " " + addText,
            maxLines: maxLines,
            maxFontSize: maxFontSize,
            minFontSize: minFontSize,
            textAlign: textAlign,
            style: style == null ? Theme.of(context).textTheme.body1 : style,
          );
  }
}
