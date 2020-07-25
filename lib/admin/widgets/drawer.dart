import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/screens/brands.dart';
import 'package:matrix/admin/screens/category_admin.dart';
import 'package:matrix/admin/screens/page_design_screen.dart';
import 'package:matrix/admin/screens/product_option_screen.dart';
import 'package:matrix/admin/screens/page_design_card.dart';
import 'package:matrix/admin/screens/orders.dart';
import 'package:matrix/admin/screens/products.dart';
import 'package:matrix/admin/screens/slider_admin.dart';
import 'package:matrix/admin/screens/users.dart';
import 'package:matrix/authentication_bloc/bloc.dart';
import 'package:matrix/utils/config.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matrix/admin/screens/product_option_card.dart';

import 'package:matrix/widgets/text_widget.dart';

List<Map> navItems = [
  {"icon": "stores", "label": "STORES"},
  {"icon": "orders", "label": "ORDERS"},
  {"icon": "referrals", "label": "REFERRALS"},
  {"icon": "support", "label": "SUPPORT"},
  {"icon": "person", "label": "ACCOUNT"},
];

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _firestore = Firestore.instance;
  List<Page_design_card> cards = [
    
    
  ];
  List<product_option_card> option_cards = [];

  @override
  void initState() {
    super.initState();
    makeDesignCards();
    makeOptionCards();
  }

  void makeDesignCards() async {
    await for (var snapshot
        in _firestore.collection('page_design').snapshots()) {
      for (var docs in snapshot.documents) {
        // print('sarthak');
        // print(docs.data['name']);
        cards.add(
          Page_design_card(
            name: docs.data['name'],
            admin: docs.data['admin'],
          ),
        );
        print(cards);
      }
    }
  }

  void makeOptionCards() async {
    await for (var snapshot
        in _firestore.collection('product_option').snapshots()) {
      for (var docs in snapshot.documents) {
        // print('sarthak');
        // print(docs.data['name']);
        option_cards.add(
          product_option_card(
            name: docs.data['name'],
            action: docs.data['action'],
            type: docs.data['type'],
            caption: docs.data['caption'],
          ),
        );
        print(option_cards);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const logoConfig = Logo;
    return Drawer(
      child: new Material(
        color: Theme.of(context).focusColor,
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
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
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              
              
              ListTile(
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => UsersAdmin()));
                },
                leading: ImageIcon(
                  AssetImage("assets/icons/users.png"),
                  size: 24.0,
                  color: Colors.white,
                ),
                title: CustomTextWidget(
                    textKey: "users",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF',
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0)),
              ),
              ListTile(
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ProductsAdmin()));
                },
                leading: ImageIcon(
                  AssetImage("assets/icons/products.png"),
                  size: 24.0,
                  color: Colors.white,
                ),
                title: CustomTextWidget(
                    textKey: "products",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF',
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0)),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(FadeRoute(page: AdminOrders()));
                },
                leading: ImageIcon(
                  AssetImage("assets/icons/orders.png"),
                  size: 24.0,
                  color: Colors.white,
                ),
                title: CustomTextWidget(
                    textKey: "orders",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF',
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0)),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(FadeRoute(page: CategoryAdmin()));
                },
                leading: ImageIcon(
                  AssetImage("assets/icons/category.png"),
                  size: 24.0,
                  color: Colors.white,
                ),
                title: CustomTextWidget(
                    textKey: "category",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF',
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0)),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(FadeRoute(page: BrandsAdmin()));
                },
                leading: ImageIcon(
                  AssetImage("assets/icons/brands.png"),
                  size: 24.0,
                  color: Colors.white,
                ),
                title: CustomTextWidget(
                    textKey: "brands",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF',
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0)),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(FadeRoute(page: SlidersAdmin()));
                },
                leading: ImageIcon(
                  AssetImage("assets/icons/tag.png"),
                  size: 24.0,
                  color: Colors.white,
                ),
                title: CustomTextWidget(
                    textKey: "slider",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF',
                        fontWeight: FontWeight.normal,
                        fontSize: 24.0)),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        LoggedOut(),
                      );
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        size: 24.0,
                        color: Colors.white,
                      ),
                      title: CustomTextWidget(
                          textKey: "signout",
                          style: new TextStyle(
                              color: Colors.white,
                              fontFamily: 'SF',
                              fontWeight: FontWeight.normal,
                              fontSize: 24.0)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
