import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/form_bloc/bloc.dart';
import 'package:matrix/bloc/locale/bloc.dart';
import 'package:matrix/bloc/orders_bloc/bloc.dart';
import 'package:matrix/bloc/theme/bloc.dart';
import 'package:matrix/bloc/user_bloc/bloc.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/screens/address.dart';
import 'package:matrix/widgets/about_us.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/logout.dart';
import 'package:matrix/widgets/orders/orders.dart';
import 'package:matrix/widgets/personal_info_form.dart';
import 'package:matrix/widgets/text_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    Key key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: BlocProvider(
        create: (context) => UserBloc()..add(LoadUser()),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is UserLoaded) {
              return StreamBuilder(
                stream: state.user,
                initialData: [],
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(
                          child: CustomTextWidget(
                        textKey: "error",
                      )),
                    );
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      break;
                    default:
                      final UserModel user = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 130,
                            width: double.maxFinite,
                            color: Theme.of(context).backgroundColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 100.0,
                                  width: 100.0,
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2.5),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: user.avatarURL == null ||
                                                user.avatarURL == ""
                                            ? AssetImage(
                                                "assets/icons/icon-user.png",
                                              )
                                            : NetworkImage(user.avatarURL),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          minHeight: 30.0,
                                          maxHeight: 100.0,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, top: 16, bottom: 16),
                                          child: CustomTextWidget(
                                            textKey: "welcome",
                                            addText: user.displayName,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 0,
                                              top: 16,
                                              bottom: 16),
                                          child: CustomTextWidget(
                                            textKey: "yourWishlist",
                                            minFontSize: 12,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       left: 16, right: 16, top: 16, bottom: 16),
                                        //   child: AutoSizeText(
                                        //     "MY ADDRESS",
                                        //     minFontSize: 12.0,
                                        //     style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 14.0,
                                        //         fontWeight: FontWeight.w700),
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 16, right: 16),
                            child: CustomTextWidget(
                              textKey: "orders",
                              minFontSize: 18.0,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 2.0,
                            child: Container(
                              height: 100,
                              width: double.maxFinite,
                              color: Theme.of(context).cardColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        SlideTopRoute(
                                            page: BlocProvider(
                                          create: (context) => OrdersBloc()
                                            ..add(LoadOrders(userId: user.uid)),
                                          child: Orders(
                                            user: user,
                                          ),
                                        )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ImageIcon(
                                              AssetImage(
                                                "assets/icons/icon-cart.png",
                                              ),
                                              size: 24,
                                            ),
                                          ),
                                          CustomTextWidget(
                                            textKey: "myOrders",
                                            minFontSize: 16.0,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Container(
                                    height: 80,
                                    width: 1.5,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ImageIcon(
                                            AssetImage(
                                              "assets/icons/cart_return.png",
                                            ),
                                            size: 24,
                                          ),
                                        ),
                                        CustomTextWidget(
                                          textKey: "myReturns",
                                          minFontSize: 16.0,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .color,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, top: 16, right: 16),
                            child: CustomTextWidget(
                              textKey: "info",
                              minFontSize: 18.0,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 2.0,
                            child: Container(
                              height: 100,
                              width: double.maxFinite,
                              color: Theme.of(context).cardColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(SlideTopRoute(
                                          page: BlocProvider(
                                        create: (context) => FormBlocBloc(),
                                        child: PersonalInfo(
                                          user: user,
                                        ),
                                      )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ImageIcon(
                                                  AssetImage(
                                                    "assets/icons/icon-user.png",
                                                  ),
                                                  size: 24)),
                                          CustomTextWidget(
                                            textKey: "personalInfo",
                                            minFontSize: 16.0,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Container(
                                    height: 80,
                                    width: 1.5,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        SlideTopRoute(
                                            page: AddressScreen(
                                          user: user,
                                        )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ImageIcon(
                                                AssetImage(
                                                    "assets/icons/icon-home.png"),
                                                size: 24),
                                          ),
                                          CustomTextWidget(
                                            textKey: "address",
                                            minFontSize: 16.0,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 16, right: 16),
                            child: CustomTextWidget(
                              textKey: "settings",
                              minFontSize: 18.0,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 2.0,
                            child: Container(
                              width: double.maxFinite,
                              color: Theme.of(context).cardColor,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          SlideTopRoute(
                                            page: AboutUs(ishelp: true,),
                                          ),
                                        );
                                            
                                      },
                                      leading: CustomTextWidget(
                                        textKey: "helpAndSupport",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .color,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                    Divider(
                                      height: 0,
                                    ),
                                    // ListTile(
                                    //   leading: CustomTextWidget(
                                    //     textKey: "faq",
                                    //     style: TextStyle(
                                    //         color: Theme.of(context)
                                    //             .textTheme
                                    //             .headline6
                                    //             .color,
                                    //         fontSize: 14.0,
                                    //         fontWeight: FontWeight.bold),
                                    //   ),
                                    //   trailing: Icon(Icons.arrow_forward_ios),
                                    // ),
                                    // Divider(
                                    //   height: 0,
                                    // ),
                                    ListTile(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    CustomTextWidget(
                                                      textKey: "changeLang",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontSize: 24),
                                                    ),
                                                    Divider(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    LocaleBloc>(
                                                                context)
                                                            .add(
                                                          LocaleChanged(
                                                            newLocale:
                                                                Locale("en"),
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CustomTextWidget(
                                                          textKey: "english",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      leading: CustomTextWidget(
                                        textKey: "language",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .color,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    CustomTextWidget(
                                                      textKey: "selectTheme",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontSize: 24),
                                                    ),
                                                    Divider(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    ThemeBloc>(
                                                                context)
                                                            .add(
                                                          ThemeChanged(
                                                              type: "dark"),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CustomTextWidget(
                                                          textKey: "dark",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    ThemeBloc>(
                                                                context)
                                                            .add(
                                                          ThemeChanged(
                                                              type: "light"),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CustomTextWidget(
                                                          textKey: "light",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      leading: CustomTextWidget(
                                        textKey: "theme",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .color,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          SlideTopRoute(
                                            page: AboutUs(ishelp: false,),
                                          ),
                                        );
                                      },
                                      leading: CustomTextWidget(
                                        textKey: "aboutUs",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .color,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                    Divider(
                                      height: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 50,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: CustomTextWidget(
                                textKey: "signout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Logout(),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                  }
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
