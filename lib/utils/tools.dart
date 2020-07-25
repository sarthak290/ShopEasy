import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matrix/utils/config.dart';
import 'package:matrix/widgets/app_localizations.dart';
import 'package:intl/intl.dart';

enum DeviceScreenType { Mobile, Tablet, Desktop }

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Tools {
  
  static image(
      {String url,
      Size size,
      double width,
      double height,
      BoxFit fit,
      String tag,
      double offset = 0.0,
      bool isResize = false}) {
    if (url == null || url == '') {
      return Container(
        width: width,
        height: height,
        color: Colors.grey,
      );
    }

    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: fit,
      cache: true,
      enableLoadState: false,
      alignment: Alignment(
          (offset >= -1 && offset <= 1) ? offset : (offset > 0) ? 1.0 : -1.0,
          0.0),
    );
  }

  static bool isTablet(MediaQueryData query) {
    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static String getCurrecyFormatted(price) {
    Map<String, dynamic> defaultCurrency =
        CurrencyFormat[allTranslations.currentLanguage];
    final formatCurrency = new NumberFormat.currency(
        locale: allTranslations.currentLanguage,
        symbol: defaultCurrency['symbol'],
        decimalDigits: defaultCurrency['decimalDigits']);
    try {
      if (price is String) {
        return formatCurrency
            .format(price.isNotEmpty ? double.parse(price) : 0);
      } else {
        return formatCurrency.format(price);
      }
    } catch (err) {
      return formatCurrency.format(0);
    }
  }
}

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  var orientation = mediaQuery.orientation;

  double deviceWidth = 0;

  if (orientation == Orientation.landscape) {
    deviceWidth = mediaQuery.size.height;
  } else {
    deviceWidth = mediaQuery.size.width;
  }

  if (deviceWidth > 950) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}

class SizingInformation {
  final Orientation orientation;
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation({
    this.orientation,
    this.deviceScreenType,
    this.screenSize,
    this.localWidgetSize,
  });

  @override
  String toString() {
    return 'Orientation:$orientation DeviceType:$deviceScreenType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
