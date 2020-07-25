import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/register/display_name.dart';
import 'package:matrix/widgets/custom_route.dart';

class BirthdayField extends StatefulWidget {
  BirthdayField({Key key}) : super(key: key);

  _BirthdayFieldState createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends State<BirthdayField> {
  bool isValidBirthday = false;
  var birthday;

  birthdayHandler(value) {
  
    setState(() {
      birthday = value;
      isValidBirthday =
          value != null && DateTime.now().difference(value).inDays > 6570;
    });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'What is your birthday?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'You must be 18 years and above.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 20,
                  right: 20,
                ),
                child: Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (v) => birthdayHandler(v),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.check),
            foregroundColor: Colors.white,
            backgroundColor: isValidBirthday
                ? Theme.of(context).primaryColor
                : Colors.grey[400],
            onPressed: isValidBirthday
                ? () {
                    
                    Navigator.of(context).push(FadeRoute(
                      page: DisplayNameField(
                        birthday: birthday.toIso8601String().substring(0, 10),
                      ),
                    ));
                  }
                : null),
        backgroundColor: Colors.white);
  }
}

