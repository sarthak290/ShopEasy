import 'package:flutter/material.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/utils/validators.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({
    Key key,
  }) : super(key: key);

  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool get isPopulated => _emailController.text.isNotEmpty;
  final UserRepository _userRepository = UserRepository();

  String emailFbError = "";
  bool loading = false;
  bool disableButton = true;
  @override
  void initState() {
    super.initState();

    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
            padding: EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
            ),
            child: ListView(
              children: <Widget>[
                Text(
                  "Forgot Password",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserat",
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Please enter your email address. We will send you a link to reset password.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 16,
                ),
                Form(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                    autocorrect: false,
                    autovalidate: true,
                    validator: (value) {
                      return value.length > 3 && !this.isValidEMail
                          ? 'Invalid Email'
                          : null;
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      )
                    : Text(
                        emailFbError,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
              ],
            )),
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: Icon(Icons.check),
          foregroundColor: Colors.white,
          backgroundColor: isValidEMail
              ? !disableButton
                  ? Theme.of(context).primaryColor
                  : Colors.grey[400]
              : Colors.grey[400],
          onPressed: isValidEMail
              ? !disableButton
                  ? () async {
                      setState(() {
                        loading = true;
                      });
                      var emailValue = await _userRepository
                          .resetPassword(_emailController.text);
                      setState(() {
                        loading = false;
                        emailFbError = emailValue;
                        disableButton = true;
                        if (emailValue == 'success') {
                          emailFbError =
                              "Email sent! Check your email and follow instructions";
                          disableButton = true;
                        }
                      });
                    }
                  : null
              : null,
        ),
        backgroundColor: Colors.white);
  }

  bool isValidEMail = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    setState(() {
      isValidEMail = Validators.isValidEmail(_emailController.text);
      emailFbError = "";
      disableButton = false;
    });
  }
}

