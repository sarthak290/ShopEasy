import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/brand_picker.dart';
import 'package:matrix/admin/widgets/category_picker.dart';
import 'package:matrix/admin/widgets/color_picker.dart';
import 'package:matrix/widgets/chips_input.dart';
import 'package:matrix/admin/widgets/image_picker.dart';
import 'package:matrix/models/brand.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/progress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductOptionForm extends StatefulWidget {
  final ProductModel product;
  bool ForEdit;
  String Edit_name, Edit_action, Edit_type, Edit_caption;
  ProductOptionForm(
      {Key key,
      @required this.product,
      this.ForEdit,
      this.Edit_name,
      this.Edit_action,
      this.Edit_type,
      this.Edit_caption})
      : super(key: key);

  _ProductOptionFormState createState() => _ProductOptionFormState();
}

class _ProductOptionFormState extends State<ProductOptionForm> {
  FirebaseUser loggedInuser;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String product_option_caption, product_option_name;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

 

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _stockUnitController = TextEditingController();
  final TextEditingController _inventoryQtyController = TextEditingController();
  final TextEditingController _thresholdQtyController = TextEditingController();
  final TextEditingController _minOrderQtyController = TextEditingController();

  bool isFeatured = false;
  List<SizeProfile> sizeProfiles = new List<SizeProfile>();

 

  bool _saving = false;
  List<Asset> assetImages = List<Asset>();
  List<String> oldImages;
  final globalKey = GlobalKey<ScaffoldState>();
  List<SizeProfile> sizes;
  List<ColorProfile> colors;
  Map brand;
  List<CategoryModel> categories;
  FormBlocBloc _formBlocBloc;

  ProductModel productData;

  
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    productData = widget.product;

    final ProductModel product = widget.product;
    _nameController.text = product != null ? product.name : null;
    _captionController.text = product != null ? product.description : null;
    _priceController.text = product != null ? product.price.toString() : null;
    _salePriceController.text =
        product != null ? product.offerPrice.toString() : null;
    _taxController.text = product != null ? product.tax.toString() : null;
    _stockUnitController.text =
        product != null ? product.stockUnit.toString() : null;
    _inventoryQtyController.text =
        product != null ? product.inventoryQty.toString() : null;
    _thresholdQtyController.text =
        product != null ? product.thresholdQty.toString() : null;
    _minOrderQtyController.text =
        product != null ? product.minOrderQty.toString() : null;
    isFeatured = product != null ? product.featured : false;
    sizes = product != null && product.sizes != null
        ? product.sizes
            .map((size) => SizeProfile(size["name"], size["name"]))
            .toList()
        : List<SizeProfile>();
    colors = product != null && product.colors != null
        ? product.colors
            .map((color) => ColorProfile(
                name: color["name"],
                colorId: color["colorId"],
                code: color["code"]))
            .toList()
        : List<ColorProfile>();
    categories = product != null && product.categories != null
        ? product.categories
            .map((cat) =>
                CategoryModel(name: cat["name"], categoryId: cat["categoryId"]))
            .toList()
        : List<CategoryModel>();
    brand = product != null && product.brand != null ? product.brand : null;
    oldImages = product != null && product.images != null
        ? product.images.cast<String>()
        : null;
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInuser = user;
    }
  }

 

  void updateSizes(result) {
    setState(() {
      sizes = result
          .map((size) => SizeProfile(size.name, size.name))
          .toList()
          .cast<SizeProfile>();
    });
  }

  

  void updateColors(result) {
    setState(() {
      colors = result
          .map((color) => ColorProfile(
              name: color.name, code: color.code, colorId: color.colorId))
          .toList()
          .cast<ColorProfile>();
    });
  }

  

  void updateCategories(result) {
    setState(() {
      categories = result
          .map((cat) =>
              CategoryModel(name: cat.name, categoryId: cat.categoryId))
          .toList()
          .cast<CategoryModel>();
    });
  }

  

  void updateBrand(result) {
    setState(() {
      brand = result != null
          ? {"name": result.name, "brandId": result.brandId}
          : null;
    });
  }

  void updateOldImages(urlNewImages) {
    print("upatedImages $urlNewImages");
    setState(() {
      oldImages = urlNewImages;
    });
  }

  void updateAssetImages(assetNewImages) {
    print("upatedImages $assetNewImages");
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
    if (_nameController.text.length <= 0 ||
        _captionController.text.length <= 0 ||
        _priceController.text.length <= 0 ||
        assetImages.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      print("PRODUCT - \n \n  $sizes, $colors, $brand, $categories \n\n\n  ");

      _formBlocBloc.add(
        AddProducts(
          product: ProductModel(
              active: true,
              name: _nameController.text,
              description: _captionController.text,
              price: double.parse(_priceController.text),
              offer: false,
              offerPrice: _salePriceController.text.length == 0
                  ? null
                  : double.parse(_salePriceController.text),
              tax: _taxController.text.length == 0
                  ? null
                  : int.parse(_taxController.text),
              stockUnit: _stockUnitController.text,
              inventoryQty: _inventoryQtyController.text.length == 0
                  ? null
                  : int.parse(_inventoryQtyController.text),
              thresholdQty: _thresholdQtyController.text.length == 0
                  ? null
                  : int.parse(_thresholdQtyController.text),
              minOrderQty: _minOrderQtyController.text.length == 0
                  ? null
                  : int.parse(_minOrderQtyController.text),
              sizes: sizes
                  .map((size) => {"name": size.name, "id": size.id})
                  .toList(),
              colors: colors
                  .map((color) => {
                        "name": color.name,
                        "colorId": color.colorId,
                        "code": color.code
                      })
                  .toList(),
              categories: categories
                  .map(
                      (cat) => {"name": cat.name, "categoryId": cat.categoryId})
                  .toList(),
              brand: brand,
              images: assetImages,
              featured: isFeatured),
        ),
      );
    }
  }

  void onUpdate(BuildContext context) async {
    print(_nameController.text.length);
    print(_captionController.text.length);
    if (_nameController.text.length <= 0 ||
        _captionController.text.length <= 0 ||
        _priceController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
     

      print("onUpdated called");

      _formBlocBloc.add(
        EditAdminProduct(
          oldImages: oldImages,
          product: ProductModel(
              productId: productData.productId,
              active: true,
              name: _nameController.text,
              description: _captionController.text,
              price: double.parse(_priceController.text),
              offer: false,
              offerPrice: _salePriceController.text.length == 0
                  ? null
                  : double.parse(_salePriceController.text),
              tax: _taxController.text.length == 0
                  ? null
                  : int.parse(_taxController.text),
              stockUnit: _stockUnitController.text,
              inventoryQty: _inventoryQtyController.text.length == 0
                  ? null
                  : int.parse(_inventoryQtyController.text),
              thresholdQty: _thresholdQtyController.text.length == 0
                  ? null
                  : int.parse(_thresholdQtyController.text),
              minOrderQty: _minOrderQtyController.text.length == 0
                  ? null
                  : int.parse(_minOrderQtyController.text),
              sizes: sizes
                  .map((size) => {"name": size.name, "id": size.id})
                  .toList(),
              colors: colors
                  .map((color) => {
                        "name": color.name,
                        "colorId": color.colorId,
                        "code": color.code
                      })
                  .toList(),
              categories: categories
                  .map(
                      (cat) => {"name": cat.name, "categoryId": cat.categoryId})
                  .toList(),
              brand: brand,
              images: assetImages,
              featured: isFeatured),
        ),
      );
    }
  }

  String optionAction = 'Add';
  String optionType = 'Product';

  final List<String> items = <String>['1', '2', '3'];
  String selectedItem = '1';
  String option_action, option_type;
  @override
  Widget build(BuildContext context) {
    print("oldImages $oldImages");
    return BlocListener(
        bloc: _formBlocBloc,
        listener: (BuildContext context, FormBlocState state) {
          print("STATE ${state.isSubmitting}");
          if (state.isFailure) {
            showNotification(context, "Error adding brand", Colors.redAccent);
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
            showNotification(context, "Brand added successfully", Colors.green);
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
                widget.ForEdit ? "Edit Product Option" : "Add Product Option",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: BlocBuilder(
              bloc: _formBlocBloc,
              builder: (BuildContext context, FormBlocState state) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: Form(
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
                                  child: TextFormField(
                                    controller:
                                        widget.ForEdit ? null : _nameController,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Product Option Name",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    initialValue: widget.ForEdit
                                        ? widget.Edit_name
                                        : null,
                                    onChanged: (value) {
                                      product_option_name = value;
                                      print(product_option_name);
                                      widget.Edit_name = value;
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    
                                    child: DropDownFormField(
                                      filled: false,
                                      titleText: 'Option Action',
                                      hintText: 'Please choose one',
                                      value: widget.ForEdit
                                          ? widget.Edit_action
                                          : option_action,
                                      onSaved: (value) {
                                        setState(() {
                                          option_action = value;
                                          widget.Edit_action = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          option_action = value;
                                          print(option_action);
                                          widget.Edit_action = value;
                                        });
                                      },
                                      dataSource: [
                                        {
                                          "display": "Add",
                                          "value": "Add",
                                        },
                                        {
                                          "display": "Remove",
                                          "value": "Remove",
                                        },
                                      ],
                                      textField: 'display',
                                      valueField: 'value',
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    
                                    child: DropDownFormField(
                                      filled: false,
                                      titleText: 'Option type',
                                      hintText: 'Please choose one',
                                      value: widget.ForEdit
                                          ? widget.Edit_type
                                          : option_type,
                                      onSaved: (value) {
                                        setState(() {
                                          option_type = value;
                                          widget.Edit_type = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          option_type = value;
                                          widget.Edit_type = value;
                                        });
                                      },
                                      dataSource: [
                                        {
                                          "display": "Product",
                                          "value": "Product",
                                        },
                                        {
                                          "display": "Property",
                                          "value": "Property",
                                        },
                                      ],
                                      textField: 'display',
                                      valueField: 'value',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: TextFormField(
                                    controller: widget.ForEdit
                                        ? null
                                        : _captionController,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Caption",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    initialValue: widget.ForEdit
                                        ? widget.Edit_caption
                                        : null,
                                    onChanged: (value) {
                                      product_option_caption = value;
                                      print(product_option_caption);
                                      widget.Edit_caption = value;
                                    },
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid caption. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),

                                
                                SizedBox(
                                  height: 50,
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
                                                .collection('product_option')
                                                .add({
                                              'name': product_option_name,
                                              'action': option_action,
                                              'type': option_type,
                                              'caption': product_option_caption,
                                              'admin': loggedInuser.email,
                                            });

                                            showNotification(
                                                context,
                                                "Product Option Added",
                                                Colors.green);
                                          } else {
                                            showNotification(
                                                context,
                                                "Product Option Edited",
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

class SizeProfile {
  final String name;
  final String id;

  const SizeProfile(this.name, this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
