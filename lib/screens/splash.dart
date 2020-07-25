import 'package:flutter/material.dart';
import 'package:matrix/utils/config.dart';

class SplashCreen extends StatelessWidget {
  const SplashCreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoConfig = Logo;
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Center(
            child: !logoConfig["isImage"]
                ? Text(
                    logoConfig["title"],
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontFamily: logoConfig["fontFamily"],
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.73,
                      fontSize: logoConfig["fontSize"],
                    ),
                  )
                : logoConfig["isAsset"]
                    ? Image.asset(logoConfig["image"])
                    : Image.network(logoConfig["image"])),
      ),
    );
  }
}

