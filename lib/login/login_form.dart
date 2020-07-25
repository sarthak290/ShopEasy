import 'package:matrix/authentication_bloc/bloc.dart';
import 'package:matrix/login/forgot_password.dart';
import 'package:matrix/login/login.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/text_widget.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _loginBloc,
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
          Navigator.pop(context);
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Text(
                        "Login to ShopEasy",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserat",
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          suffix: _emailController.text == "" ||
                                  _emailController.text == null
                              ? Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                              : GestureDetector(
                                  child: Icon(
                                    Icons.close,
                                    size: 16.0,
                                  ),
                                  onTap: () {
                                    _emailController.text = "";
                                  },
                                ),
                        ),
                        autovalidate: true,
                        autocorrect: false,
                        validator: (value) {
                          return value.length > 3 && !state.isEmailValid
                              ? 'Invalid Email'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffix: _passwordController.text == "" ||
                                  _passwordController.text == null
                              ? Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                              : GestureDetector(
                                  child: Icon(
                                    Icons.close,
                                    size: 16.0,
                                  ),
                                  onTap: () {
                                    _passwordController.text = "";
                                  },
                                ),
                        ),
                        obscureText: true,
                        autovalidate: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? 'Invalid Password'
                              : null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(SlideTopRoute(page: ForgotPassword()));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: " Get help signing in.",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.check),
              foregroundColor: Colors.white,
              backgroundColor: isLoginButtonEnabled(state)
                  ? Theme.of(context).primaryColor
                  : Colors.grey[400],
              onPressed: isLoginButtonEnabled(state) ? _onFormSubmitted : null,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
