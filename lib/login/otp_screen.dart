import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrix/authentication_bloc/bloc.dart';
import 'package:matrix/login/bloc/bloc.dart';
import 'package:matrix/login/otp_input.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/widgets/text_widget.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final UserRepository userRepository;
  OTPScreen(
      {Key key, @required this.mobileNumber, @required this.userRepository})
      : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginBloc _loginBloc;

  
  TextEditingController _pinEditingController = TextEditingController();

  
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black, hintText: '333333');

  bool isCodeSent = false;
  String _verificationId;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    print("isValid - $isCodeSent");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.only(left: 16.0, bottom: 16, top: 4),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextWidget(
                      textKey: "verify",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomTextWidget(
                      textKey: "otpSend",
                      addText: widget.mobileNumber,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    "assets/icons/phone.png",
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(100),
        ),
      ),
      body: BlocListener(
        bloc: _loginBloc,
        listener: (BuildContext context, LoginState state) {
          if (state.isFailure) {
            setState(() {
              isCodeSent = false;
            });
            showToast(state.message, Colors.red);
          }
          if (state.isSubmitting) {
            showToast("Logging in", Colors.grey);
          }
          if (state.isSuccess) {
            showToast("Logged in", Theme.of(context).primaryColor);
            Navigator.pop(context);
            Navigator.pop(context);
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
        },
        child: BlocBuilder(
          bloc: _loginBloc,
          builder: (BuildContext context, LoginState state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PinInputTextField(
                      pinLength: 6,
                      decoration: _pinDecoration,
                      controller: _pinEditingController,
                      autoFocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmit: (pin) {
                        if (pin.length == 6) {
                          _onFormSubmitted();
                        } else {
                          showToast("Invalid OTP", Colors.red);
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          child: AutoSizeText(
                            "ENTER OTP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_pinEditingController.text.length == 6) {
                              _onFormSubmitted();
                            } else {
                              showToast("Invalid OTP", Colors.red);
                            }
                          },
                          padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          Navigator.pop(context);
          Navigator.pop(context);
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

   

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() {
    print(_pinEditingController.text);
    _loginBloc.add(
      LoginWithPhonePressed(
          smsCode: _pinEditingController.text,
          verificationCode: _verificationId),
    );
  }
}
