import 'package:matrix/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      icon: Image.asset("assets/icons/fb.png"),
      onPressed: () {
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithFacebookPressed(),
        );
      },
    );
  }
}
