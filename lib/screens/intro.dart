import 'package:flutter/material.dart';
import 'package:matrix/main.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/utils/config.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/onboarding/onboarding.dart';
import 'package:matrix/widgets/onboarding/page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

var color = Settings['Setting']['MainColor'];

final pageList = [
  PageModel(
    color: HexColor(color),
    heroAssetPath: 'assets/intro/vendor.svg',
    title: Text('Multi Vendor',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 34.0,
        )),
    body: Text(
        'An eCommerce App which support multi vendor, Role management, etc',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        )),
    iconAssetPath: 'assets/intro/vendor.svg',
  ),
  PageModel(
      color: HexColor(color),
      heroAssetPath: 'assets/intro/cart.svg',
      title: Text('Cart',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('Realtime cart which syncs across all devices ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconAssetPath: 'assets/intro/cart.svg'),
  PageModel(
      color: HexColor(color),
      heroAssetPath: 'assets/intro/login.svg',
      title: Text('Auth',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('Login/Signup uisng email, gmail, facebook, phone.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconAssetPath: 'assets/intro/login.svg'),
  PageModel(
    color: HexColor(color),
    heroAssetPath: 'assets/intro/payment.svg',
    title: Text('Payment',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 34.0,
        )),
    body: Text('Use credit card, debit cart, paytm, upi for payments',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        )),
    iconAssetPath: 'assets/intro/payment.svg',
  ),
];

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key key}) : super(key: key);

  void gotoScreen(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('seen', true);
    final UserRepository userRepository = UserRepository();
    Navigator.of(context).pushReplacement(FadeRoute(
        page: App(
      userRepository: userRepository,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HtOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () {
          gotoScreen(context);
        },
        onSkipButtonPressed: () {
          gotoScreen(context);
        },
      ),
    );
  }
}

