import 'package:flutter/material.dart';
import 'package:matrix/register/register_form.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/utils/validators.dart';
import 'package:matrix/widgets/custom_route.dart';

class EmailField extends StatefulWidget {
  EmailField({Key key, @required this.birthday, @required this.name})
      : super(key: key);
  final String birthday;
  final String name;
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();
  bool get isPopulated => _emailController.text.isNotEmpty;
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
          brightness: Brightness.light,
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
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                autofocus: true,
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: Icon(Icons.check),
          foregroundColor: Colors.white,
          backgroundColor:
              isValidEMail ? Theme.of(context).primaryColor : Colors.grey[400],
          onPressed: isValidEMail
              ? () {
                  Navigator.of(context).push(FadeRoute(
                    page: RegisterScreen(
                      name: widget.name,
                      birthday: widget.birthday,
                      email: _emailController.text,
                      userRepository: UserRepository(),
                    ),
                  ));
                }
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
    });
  }
}
