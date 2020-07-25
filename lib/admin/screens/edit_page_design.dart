// import 'dart:html';

// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/image_picker.dart';
import 'package:matrix/models/category.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:matrix/widgets/progress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';

class EditPageDesign extends StatefulWidget {
  final CategoryModel category;
  bool ForEdit;
  String Edit_name;
  EditPageDesign(
      {Key key,
      @required this.category,
      @required this.ForEdit,
      this.Edit_name})
      : super(key: key);

  _PagedesignformState createState() => _PagedesignformState();
}

class _PagedesignformState extends State<EditPageDesign> {
  String pageDesignName, productName, description, price, quantity;
  FirebaseUser loggedInuser;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _product_name_Controller =
      TextEditingController();
  final TextEditingController _price_Controller = TextEditingController();
  final TextEditingController _quantity_Controller = TextEditingController();

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
    makeOptionList();
    
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

  Map<String, bool> cityList = {
    'Text': false,
    'TextArea': false,
    'Clickable Link': false,
    'Date': false,
    'Time': false,
    'Date and Time': false,
    'Drop Down Single Select': false,
    'Drop Down Multiple Select': false,
    'Radio Button Single Select': false,
    'Location': false,
    'Image': false,
    'Image-Slider': false,
  };
  List<int> selectedFields = [];
  List<int> new_field_list = [];

  List optionList = [];
  void makeOptionList() async {
    await for (var snapshot
        in _firestore.collection('product_option').snapshots()) {
      for (var docs in snapshot.documents) {
       

        optionList
            .add({"display": docs.data['name'], "value": docs.data['name']});

        print(optionList);
      }
    }
  }

  bool optionsValue = false;

  String type, purpose, optionSelected;
  Future<Map<String, bool>> _preLocation() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Add field'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.black)),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, cityList);
                      print(selectedFields);
                      showNotification(
                          context, "Field Added", Colors.yellow);
                      setState(() {
                        
                        new_field_list = selectedFields;
                        print(new_field_list);

                        print('list updated');
                      });
                    },
                    child: Text('Done', style: TextStyle(color: Colors.black)),
                  ),
                ],
                content: Container(
                    width: double.minPositive,
                    height: 400,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _product_name_Controller,
                          maxLength: 64,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Caption",
                          ),
                          autovalidate: true,
                          autocorrect: false,
                          onChanged: (value) {
                            productName = value;
                            print(productName);
                          },
                          validator: (value) {
                            return value.length < 3
                                ? 'Invalid Caption. Atleast 3 letter is needed.'
                                : null;
                          },
                        ),
                        DropDownFormField(
                          filled: false,
                          titleText: 'Type',
                          hintText: 'Please Select Type',
                         
                          value: type,
                          onSaved: (value) {
                            setState(() {
                              type = value;
                              
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              type = value;
                              
                            });
                          },
                          dataSource: [
                            {
                              "display": "Label",
                              "value": "Label",
                            },
                            {
                              "display": "Text",
                              "value": "Text",
                            },
                            {
                              "display": "Text Area",
                              "value": "Text Area",
                            },
                            {
                              "display": "Date",
                              "value": "Date",
                            },
                            {
                              "display": "Time",
                              "value": "Time",
                            },
                            {
                              "display": "Date and Time",
                              "value": "Date and Time",
                            },
                            {
                              "display": "Clickable Link",
                              "value": "Clickable Link",
                            },
                            {
                              "display": "DropDown Single Select",
                              "value": "DropDown Multiple Select",
                            },
                            {
                              "display": "Radio Single Single",
                              "value": "radio single Select",
                            },
                            {
                              "display": "Location",
                              "value": "Location",
                            },
                            {
                              "display": "Image",
                              "value": "Image",
                            },
                            {
                              "display": "Image Slider",
                              "value": "Image slider",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          filled: false,
                          titleText: 'Purpose',
                          hintText: 'Please Select Purpose',
                         
                          value: purpose,
                          onSaved: (value) {
                            setState(() {
                              purpose = value;
                             
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              purpose = value;

                             
                            });
                          },
                          dataSource: [
                            {
                              "display": "No Purpose",
                              "value": "No Purpose",
                            },
                            {
                              "display": "Price",
                              "value": "Price",
                            },
                            {
                              "display": "Min. Stock",
                              "value": "Min. Stock",
                            },
                            {
                              "display": "Category",
                              "value": "Category",
                            },
                            {
                              "display": "Brand",
                              "value": "Brand",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          filled: false,
                          titleText: 'Options',
                          hintText: 'Please Select Options',
                         
                          value: optionSelected,
                          onSaved: (value) {
                            setState(() {
                              optionSelected = value;
                             
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              optionSelected = value;

                             
                            });
                          },
                          dataSource: optionList,
                          textField: 'display',
                          valueField: 'value',
                        ),
                        CheckboxListTile(
                        

                          value: optionsValue,
                          title: Text('Hide in user UI'),
                          onChanged: (val) {
                            setState(() {
                              optionsValue = val;
                            });
                          },
                        ),
                      ],
                    )),

              
              );
            },
          );
        });
  }

  Padding makeTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: _product_name_Controller,
        maxLength: 64,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Text Field",
        ),
        autovalidate: true,
        autocorrect: false,
        onChanged: (value) {
          productName = value;
          print(productName);
        },
        validator: (value) {
          return value.length < 3
              ? 'Invalid Text. Atleast 3 letter is needed.'
              : null;
        },
      ),
    );
  }

  Padding makeTextArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
          maxLines: 10,
          decoration: InputDecoration(
              hintText: 'Text Area', border: OutlineInputBorder())),
    );
  }

  DateTime selectedDate;
  Padding makeDateField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: DateField(
        onDateSelected: (DateTime value) {
          setState(() {
            selectedDate = value;
          });
        },
        selectedDate: selectedDate,
        firstDate: DateTime(1990, 1, 1),
        lastDate: DateTime.now(),
      ),
    );
  }

  List<Widget> dynamicFields = [];

  Column makeDynamic(List<int> fieldList) {
    
    for (int i in fieldList) {
      if (i == 0) {
        dynamicFields.add(makeTextField());
        dynamicFields.add(makeTextArea());
        dynamicFields.add(makeDateField());
      }
    }

    return Column(
      children: dynamicFields,
    );
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
                                      'Edit Page Design',
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
                                      labelText: "Page Name",
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: TextFormField(
                                    controller: _product_name_Controller,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Product Name",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      productName = value;
                                      print(productName);
                                    },
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid Product name. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Description",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      description = value;
                                      print(description);
                                    },
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid Description. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: TextFormField(
                                    controller: _price_Controller,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Price",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      price = value;
                                      print(price);
                                    },
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid Price. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: TextFormField(
                                    controller: _quantity_Controller,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Quantity",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      quantity = value;
                                      print(quantity);
                                    },
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid Quantity. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),
                                makeTextField(),
                                makeTextArea(),
                                makeDateField(),
   
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.purple, width: 3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                               
                                  margin: EdgeInsets.only(
                                      left: 230, top: 20, bottom: 20),
                                  child: Material(
                                    elevation: 5.0,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: InkWell(
                                      onTap: () {
                                        _preLocation();
                                    
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.add,
                                                color: Colors.purple),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 16.0)),
                                            Text('ADD ',
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ),
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
