import 'package:flutter/material.dart';
import 'package:matrix/register/email_field.dart';
import 'package:matrix/widgets/custom_route.dart';

class DisplayNameField extends StatefulWidget {
  DisplayNameField({Key key, @required this.birthday}) : super(key: key);
  final String birthday;
  _DisplayNameFieldState createState() => _DisplayNameFieldState();
}

class _DisplayNameFieldState extends State<DisplayNameField> {
  final TextEditingController _nameController = TextEditingController();
  bool get isPopulated => _nameController.text.isNotEmpty;
  @override
  void initState() {
    super.initState();

    _nameController.addListener(_onEmailChanged);
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
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  suffix:
                      _nameController.text == "" || _nameController.text == null
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
                                _nameController.text = "";
                              },
                            ),
                ),
                autocorrect: false,
                autovalidate: true,
                validator: (value) {
                  return value.length > 1 && !this.isValidName
                      ? 'Name must be greater than 2 letters.'
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
              isValidName ? Theme.of(context).primaryColor : Colors.grey[400],
          onPressed: isValidName
              ? () {
                  Navigator.of(context).push(FadeRoute(
                    page: EmailField(
                      birthday: widget.birthday,
                      name: _nameController.text,
                    ),
                  ));
                }
              : null,
        ),
        backgroundColor: Colors.white);
  }

  bool isValidName = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    setState(() {
      isValidName = _nameController.text.length > 2;
    });
  }
}
