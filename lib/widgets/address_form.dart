import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrix/bloc/form_bloc/bloc.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/widgets/progress.dart';

class AddressForm extends StatefulWidget {
  final AddressModel address;

  AddressForm({Key key, @required this.address}) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  FormBlocBloc _formBlocBloc;
  final globalKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  AddressModel addressData;

  @override
  void initState() {
    super.initState();
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    final AddressModel data = widget.address;
    addressData = widget.address;
    _nameController.text = data != null ? data.name : null;
    _phoneNumberController.text = data != null ? data.phoneNumber : null;
    _flatNumberController.text = data != null ? data.flatNumber : null;
    _streetController.text = data != null ? data.colonyNumber : null;
    _landmarkController.text = data != null ? data.landmark : null;
    _cityController.text = data != null ? data.city : null;
    _stateController.text = data != null ? data.state : null;

    _phoneNumberController.addListener(_validatePhone);
    _nameController.addListener(_validateName);
  }

  bool isValidPhone = false;
  bool autoValPhone = false;
  bool isValidEmail = false;
  bool autoValEmail = false;
  bool isValidName = false;
  bool autoValName = false;

  _validateName() {
    if (_nameController.text.length == 3) {
      setState(() {
        autoValName = true;
      });
    }
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+").hasMatch(_nameController.text)) {
      setState(() {
        isValidName = true;
      });
    } else {
      setState(() {
        isValidName = false;
      });
    }
  }

  _validatePhone() {
    if (_phoneNumberController.text.length == 3) {
      setState(() {
        autoValPhone = true;
      });
    }
    if (RegExp(r"^(?:[+0]9)?[0-9]{10}$")
        .hasMatch(_phoneNumberController.text)) {
      setState(() {
        isValidPhone = true;
      });
    } else {
      setState(() {
        isValidPhone = false;
      });
    }
  }

  void showNotification(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message),
        ],
      ),
    );
    globalKey.currentState.showSnackBar(snackBar);
  }

  void onSubmit(BuildContext context) async {
    //print(_nameController.text.length);
    if (_nameController.text.length <= 0 ||
        _phoneNumberController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      _formBlocBloc.add(
        AddAddress(
          address: AddressModel(
            active: true,
            name: _nameController.text,
            phoneNumber: _phoneNumberController.text,
            city: _cityController.text,
            flatNumber: _flatNumberController.text,
            colonyNumber: _streetController.text,
            landmark: _landmarkController.text,
            state: _stateController.text,
          ),
        ),
      );
    }
  }

  void onUpdate(BuildContext context) async {
    if (_nameController.text.length <= 0 ||
        _phoneNumberController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      _formBlocBloc.add(EditAddress(
        address: AddressModel(
          name: _nameController.text,
          id: widget.address.id,
          phoneNumber: _phoneNumberController.text,
          city: _cityController.text,
          flatNumber: _flatNumberController.text,
          colonyNumber: _streetController.text,
          landmark: _landmarkController.text,
          state: _stateController.text,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _formBlocBloc,
      listener: (BuildContext context, FormBlocState state) {
       
        if (state.isFailure) {
          showNotification(context, "Something went wrong", Colors.redAccent);
          setState(() {
            _saving = false;
          });
        } else if (state.isSubmitting) {
          setState(() {
            _saving = true;
          });
        } else if (state.isSuccess) {
          setState(() {
            _saving = false;
          });
          showNotification(context, "Success", Colors.green);
          Navigator.pop(context);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Scaffold(
          key: globalKey,
          appBar: AppBar(
            leading: IconButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            title: Text(
              widget.address != null ? "Edit Address" : "Add Address",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              child:
                  Text(widget.address != null ? "Edit Address" : "Add Address"),
              onPressed: () {
                if (isValidPhone && isValidName) {
                  if (widget.address == null) {
                    onSubmit(context);
                  } else {
                    onUpdate(context);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Please fill all fields",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return null;
                }
              },
            ),
          ),
          body: Container(
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      widget.address != null
                          ? "Edit Address"
                          : "Add a new address",
                      style: TextStyle(
                          fontFamily: "Graphik",
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              validator: _validateName(),
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffix: _nameController.text == "" ||
                                        _nameController.text == null
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
                            ),
                            TextFormField(
                              controller: _phoneNumberController,
                              autovalidate: autoValPhone,
                              validator: (value) {
                                return isValidPhone
                                    ? null
                                    : "Invalid Phone Number";
                              },
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffix: _phoneNumberController.text == "" ||
                                        _phoneNumberController.text == null
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
                                          _phoneNumberController.text = "";
                                        },
                                      ),
                              ),
                            ),
                            TextFormField(
                              controller: _flatNumberController,
                              decoration: InputDecoration(
                                labelText: "Flat/House No./Floor/Building",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffix: _flatNumberController.text == "" ||
                                        _flatNumberController.text == null
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
                                          _flatNumberController.text = "";
                                        },
                                      ),
                              ),
                            ),
                            TextFormField(
                              controller: _streetController,
                              decoration: InputDecoration(
                                labelText: "Colony/Street/Locality",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffix: _streetController.text == "" ||
                                        _streetController.text == null
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
                                          _streetController.text = "";
                                        },
                                      ),
                              ),
                            ),
                            TextFormField(
                              controller: _landmarkController,
                              decoration: InputDecoration(
                                labelText: "Landmark",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffix: _landmarkController.text == "" ||
                                        _landmarkController.text == null
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
                                          _landmarkController.text = "";
                                        },
                                      ),
                              ),
                            ),
                            TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                labelText: "City",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffix: _cityController.text == "" ||
                                        _cityController.text == null
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
                                          _cityController.text = "";
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
