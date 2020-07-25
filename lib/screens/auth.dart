import 'package:auto_size_text/auto_size_text.dart';
import 'package:matrix/authentication_bloc/bloc.dart';
import 'package:matrix/login/facebook_login_button.dart';
import 'package:matrix/login/login.dart';
import 'package:matrix/login/login_screen.dart';
import 'package:matrix/login/phone_login_button.dart';
import 'package:matrix/register/birthday_field.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/slider/auth_splash_slider.dart';
import 'package:matrix/widgets/text_widget.dart';

class AuthScreen extends StatelessWidget {
  final UserRepository _userRepository;

  AuthScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    final logoConfig = Logo;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              SlideTopRoute(
                page: LoginScreen(
                  userRepository: _userRepository,
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  textKey: "alreadyHaveAccount",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                CustomTextWidget(
                  textKey: "login",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w900),
                )
              ]),
        ),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<LoginBloc>(context),
        listener: (BuildContext context, LoginState state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(state.message)),
                      Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        textKey: "loading",
                        addText: "...",
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
        },
        child: BlocBuilder(
          bloc: BlocProvider.of<LoginBloc>(context),
          builder: (BuildContext context, LoginState state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: height * 0.1,
                      child: Center(
                          child: !logoConfig["isImage"]
                              ? Text(
                                  logoConfig["title"],
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontFamily: logoConfig["fontFamily"],
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.73,
                                    fontSize: 32,
                                  ),
                                )
                              : logoConfig["isAsset"]
                                  ? Image.asset(logoConfig["image"])
                                  : Image.network(logoConfig["image"])),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      child: CarouselWithIndicator(),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.07,
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0)),
                            child: CustomTextWidget(
                              textKey: "emailSignUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  SlideTopRoute(page: BirthdayField()));
                            },
                            padding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Container(
                      height: height * 0.02,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0),
                        child: Divider(
                          height: 22,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.1,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FacebookLoginButton(),
                            SizedBox(
                              width: 16,
                            ),
                            GoogleLoginButton(),
                            SizedBox(
                              width: 16,
                            ),
                            PhoneLogin(
                              userRepository: _userRepository,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.2,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomTextWidget(
                                  textKey: "terms1",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                CustomTextWidget(
                                    textKey: "terms2",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                CustomTextWidget(
                                    textKey: "terms3",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                                CustomTextWidget(
                                    textKey: "terms4",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
