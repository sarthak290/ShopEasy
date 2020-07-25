import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/login/bloc/bloc.dart';
import 'package:matrix/login/otp_screen.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/widgets/app_localizations.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/text_widget.dart';

class PhoneLogin extends StatefulWidget {
  final UserRepository _userRepository;

  PhoneLogin({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
   
  }

  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    print("VALID : $isValid");
    return IconButton(
      iconSize: 48,
      color: Theme.of(context).primaryColor,
      icon: Image.asset("assets/icons/phone.png"),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext bc) {
              print("VALID CC: $isValid");

              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                return Container(
                  padding: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTextWidget(
                        textKey: 'login',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      ),
                      CustomTextWidget(
                        textKey: "phoneLoginMessage",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneNumberController,
                          autofocus: true,
                          onChanged: (text) {
                            validate(state);
                          },
                          decoration: InputDecoration(
                            labelText: allTranslations.text("phoneLabel"),
                            prefix: Container(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "+91",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          autovalidate: true,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          validator: (value) {
                            return !isValid
                                ? allTranslations.text("phoneError")
                                : null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: RaisedButton(
                              color: !isValid
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)
                                  : Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0)),
                              child: CustomTextWidget(
                                textKey: !isValid ? "enterPhone" : "continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                if (isValid) {
                                  Navigator.push(
                                      context,
                                      SlideTopRoute(
                                          page: BlocProvider(
                                        create: (context) => LoginBloc(
                                            userRepository:
                                                widget._userRepository),
                                        child: OTPScreen(
                                          userRepository:
                                              widget._userRepository,
                                          mobileNumber:
                                              _phoneNumberController.text,
                                        ),
                                      )));
                                } else {
                                  validate(state);
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
              });
            });
      },
    );
  }
}

