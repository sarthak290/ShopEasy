import 'package:flutter/material.dart';

/// basic colors
const hTeal50 = Color(0xFFE0F2F1);
const hTeal100 = Color(0xFF3FC1BE);

const hDefaultBackgroundAvatar = '3FC1BE';
const hDefaultTextColorAvatar = 'EEEEEE';
const hDefaultAdminBackgroundAvatar = 'EEEEEE';
const hDefaultAdminTextColorAvatar = '3FC1BE';

const hTeal400 = Color(0xFF26A69A);
const hGrey900 = Color(0xFF263238);
const hGrey600 = Color(0xFF546E7A);
const hGrey200 = Color(0xFFEEEEEE);
const hGrey400 = Color(0xFF90a4ae);
const hErrorRed = Color(0xFFe74c3c);
const hSurfaceWhite = Color(0xFFFFFBFA);
const hBackgroundWhite = Colors.white;

/// color for theme
const hLightPrimary = Color(0xff3a4660);
const hLightAccent = Color(0xFF546E7A);
const hDarkAccent = Color(0xff384550);
const hDarkDrawer = Color(0xFF1b2a49);
const hLightDrawer = Colors.lightBlueAccent;
const hLightBG = Color(0xffF1F2F3);
const hDarkBG = Color(0xff20282F);
const hDarkBgLight = Color(0xff1E1E1E);
const hBadgeColor = Colors.red;

const hProductTitleStyleLarge =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

const hTextField = InputDecoration(
  hintText: 'Enter your value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

IconThemeData _customIconTheme(IconThemeData original, Color color) {
  return original.copyWith(color: color);
}

ThemeData buildLightTheme(Color primaryColor) {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: hColorScheme,
    buttonColor: hTeal400,
    cardColor: Colors.white,
    textSelectionColor: hTeal100,
    errorColor: hErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: hColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryColorLight: hLightBG,
    // focusColor: hLightDrawer,
    primaryIconTheme: _customIconTheme(base.iconTheme, primaryColor),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme, primaryColor),
    hintColor: Colors.black26,
    backgroundColor: primaryColor,
    primaryColor: hLightPrimary,
    // drawerColor: hLightDrawer,
    accentColor: hLightAccent,
    cursorColor: hLightAccent,
    scaffoldBackgroundColor: hLightBG,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      elevation: 0,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: hDarkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
    ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline6: base.headline6
            .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
        bodyText1: base.headline6.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyText2: base.bodyText2.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Quicksand',
        displayColor: hGrey900,
        bodyColor: hGrey900,
      )
      .copyWith(headline6: base.headline6.copyWith(fontFamily: 'Quicksand'));
}

TextTheme _buildDarkTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline6: base.headline6
            .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
        headline5: base.headline6.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyText2: base.bodyText2.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Quicksand',
        displayColor: hSurfaceWhite,
        bodyColor: hSurfaceWhite,
      )
      .copyWith(headline6: base.headline6.copyWith(fontFamily: 'Quicksand'));
}

const ColorScheme hColorScheme = ColorScheme(
  primary: hTeal100,
  primaryVariant: hGrey900,
  secondary: hTeal50,
  secondaryVariant: hGrey900,
  surface: hSurfaceWhite,
  background: hBackgroundWhite,
  error: hErrorRed,
  onPrimary: hGrey900,
  onSecondary: hGrey900,
  onSurface: hGrey900,
  onBackground: hGrey900,
  onError: hSurfaceWhite,
  brightness: Brightness.light,
);

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    cardColor: hDarkBgLight,
    brightness: Brightness.dark,
    backgroundColor: hDarkBG,
    primaryColor: hDarkBG,
    primaryColorLight: hDarkBgLight,
    accentColor: hDarkAccent,
    // focusColor: hDarkDrawer,
    scaffoldBackgroundColor: hDarkBG,
    cursorColor: hDarkAccent,
    textTheme: _buildDarkTextTheme(base.textTheme),
    primaryIconTheme: _customIconTheme(base.iconTheme, Colors.white),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme, Colors.white),
    appBarTheme: AppBarTheme(
      elevation: 0,
      brightness: Brightness.dark,
      color: hDarkBG,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: hDarkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: hDarkAccent,
      ),
    ),
  );
}

const hMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: hTeal400, width: 2.0),
  ),
);

const hSendButtonTextStyle = TextStyle(
  color: hTeal400,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const hMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);
