import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/form_bloc/bloc.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/widgets/progress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class PersonalInfo extends StatefulWidget {
  final UserModel user;
  PersonalInfo({Key key, @required this.user}) : super(key: key);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isFeatured = false;
  bool _saving = false;
  bool loading = false;

  FormBlocBloc _formBlocBloc;

  @override
  void initState() {
    super.initState();
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    _displayNameController.text = widget.user.displayName;
    // _addressController.text = widget.user.address;
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

  Future saveImage(Asset asset) async {
    var uuid = new Uuid();
    var imageName = uuid.v4();

    String path = asset.name;
    String _extension = p.extension(path).split('?').first;

    ByteData byteData = await asset.getThumbByteData(1080, 1080, quality: 70);
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('$imageName${_extension.toLowerCase()}');
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      loading = true;
    });

    String avatarURL = await saveImage(resultList[0]);

    setState(() {
      loading = false;
    });
    _formBlocBloc.add(EditUserimage(
        user: UserModel(uid: widget.user.uid, avatarURL: avatarURL)));

    // final UserRepository userRepository = UserRepository();
    // AuthenticationBloc(userRepository: userRepository).add(LoggedIn());
  }

  onUpdate() {
    if (_displayNameController.text.length <= 2 ||
        _addressController.text.length < 10) {
      showNotification(context, "Please correct all the errors", Colors.red);
    } else {
      _formBlocBloc.add(
        EditUserDetails(
          user: UserModel(
            uid: widget.user.uid,
            displayName: _displayNameController.text,
          ),
        ),
      );

      // final UserRepository userRepository = UserRepository();
      // AuthenticationBloc(userRepository: userRepository).add(LoggedIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = widget.user;
    return BlocListener(
        bloc: _formBlocBloc,
        listener: (BuildContext context, FormBlocState state) {
          print("STATE ${state.isSubmitting}");
          if (state.isFailure) {
            showNotification(context, "Error adding brand", Colors.redAccent);
          } else if (state.isSubmitting) {
            setState(() {
              _saving = true;
            });
          } else if (state.isSuccess) {
            setState(() {
              _saving = false;
            });
            showNotification(
                context, "User updated successfully", Colors.green);
            Navigator.pop(context);
          }
        },
        child: ModalProgressHUD(
          child: Scaffold(
            backgroundColor: Colors.white,
            key: globalKey,
            appBar: AppBar(
              leading: IconButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Text(
                "Edit user",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: BlocBuilder(
              bloc: _formBlocBloc,
              builder: (BuildContext context, FormBlocState state) {
                print("NEW SATET ${state.isSubmitting}");
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          loading
                              ? CircularProgressIndicator()
                              : Container(
                                  height: 100.0,
                                  width: 100.0,
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 2.5),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: user.avatarURL == null ||
                                                user.avatarURL == ""
                                            ? AssetImage(
                                                "assets/icons/icon-user.png",
                                              )
                                            : NetworkImage(user.avatarURL),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: loadAssets,
                            color: Colors.lightBlue,
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: TextFormField(
                          controller: _displayNameController,
                          maxLength: 64,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Name",
                          ),
                          autovalidate: true,
                          autocorrect: false,
                          validator: (value) {
                            return value.length < 2
                                ? 'Invalid name. Atleast 2 letter is needed.'
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: TextFormField(
                          initialValue: user.email,
                          maxLength: 64,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                          ),
                          readOnly: true,
                          autovalidate: true,
                          autocorrect: false,
                          validator: (value) {
                            return value.length < 2
                                ? 'Invalid name. Atleast 2 letter is needed.'
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: onUpdate,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          inAsyncCall: _saving,
        ));
  }
}
