import 'package:flutter/material.dart';
import 'package:matrix/utils/config.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAdmin = true;
    const logoConfig = Logo;
    return AppBar(
      elevation: 4.0,
      centerTitle: isAdmin ? true : false,
      leading: isAdmin
          ? Builder(
              builder: (context) => IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent, //
                icon: ImageIcon(
                  AssetImage("assets/icons/dashboard.png"),
                  size: 18.0,
                  color: Colors.white,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
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
      actions: <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              
            }),
      ],
    );
  }
}
