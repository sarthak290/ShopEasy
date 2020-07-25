// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/image_picker.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/widgets/progress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pagedesignform extends StatefulWidget {
  final CategoryModel category;
  bool ForEdit;
  String Edit_name;
  Pagedesignform(
      {Key key,
      @required this.category,
      @required this.ForEdit,
      this.Edit_name})
      : super(key: key);

  _PagedesignformState createState() => _PagedesignformState();
}

class _PagedesignformState extends State<Pagedesignform> {
  String pageDesignName;
  FirebaseUser loggedInuser;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  bool isFeatured = false;
  bool _saving = false;
  List<Asset> assetImages = List<Asset>();
  List<String> oldImages;
  CategoryModel categoryData;

  FormBlocBloc _formBlocBloc;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    final CategoryModel cat = widget.category;
    categoryData = widget.category;
    isFeatured = cat != null ? cat.featured : false;
    _nameController.text = cat != null ? cat.name : null;
    _descriptionController.text = cat != null ? cat.description : null;
    oldImages =
        cat != null && cat.images != null ? cat.images.cast<String>() : null;
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInuser = user;
    }
  }

  void updateOldImages(urlNewImages) {
    print("upatedImages $urlNewImages");
    setState(() {
      oldImages = urlNewImages;
    });
  }

  void updateAssetImages(assetNewImages) {
    print("upatedImages $assetImages");
    setState(() {
      assetImages = assetNewImages;
    });
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
    print(_nameController.text.length);
    print(_descriptionController.text.length);
    if (_nameController.text.length <= 0 ||
        _descriptionController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      _formBlocBloc.add(
        AddAdminCategory(
          category: CategoryModel(
              active: true,
              name: _nameController.text,
              description: _descriptionController.text,
              images: assetImages,
              featured: isFeatured),
        ),
      );
    }
  }

  void onUpdate(BuildContext context) async {
    print(_nameController.text.length);
    print(_descriptionController.text.length);
    if (_nameController.text.length <= 0 ||
        _descriptionController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      _formBlocBloc.add(
        EditAdminCategory(
            category: CategoryModel(
                categoryId: categoryData.categoryId,
                active: true,
                name: _nameController.text,
                description: _descriptionController.text,
                images: assetImages,

                
                featured: isFeatured),
            oldImages: oldImages),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _formBlocBloc,
        listener: (BuildContext context, FormBlocState state) {
          print("STATE ${state.isSubmitting}");
          if (state.isFailure) {
            showNotification(
                context, "Error adding category", Colors.redAccent);
          } else if (state.isSubmitting) {
            setState(() {
              _saving = true;
            });
          } else if (state.isSuccess) {
            setState(() {
              _saving = false;
            });
            showNotification(
                context, "category added successfully", Colors.green);
            Navigator.pop(context);
          }
        },
        child: ModalProgressHUD(
          child: Scaffold(
            key: globalKey,
            appBar: AppBar(
              leading: IconButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Text(
                widget.ForEdit ? "Edit Page Design" : "Add Page Design",
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
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: Center(
                                    child: Text(
                                      'Add Page Design',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: TextFormField(
                                    controller:
                                        widget.ForEdit ? null : _nameController,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Name",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    initialValue: widget.ForEdit
                                        ? widget.Edit_name
                                        : null,
                                    onChanged: (value) {
                                      pageDesignName = value;
                                      print(pageDesignName);
                                    },
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid name. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),

                                Container(
                                  height: 300,
                                  child: null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 40,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          "SUBMIT",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          if (widget.ForEdit == false) {
                                            _firestore
                                                .collection('page_design')
                                                .add({
                                              'name': pageDesignName,
                                              'admin': loggedInuser.email
                                            });

                                            showNotification(
                                                context,
                                                "Page Design Added",
                                                Colors.green);
                                          } else {
                                            showNotification(
                                                context,
                                                "Page Design Edited",
                                                Colors.blue);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          inAsyncCall: _saving,
        ));
  }
}
