import 'package:extended_image/extended_image.dart';
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
import 'package:date_field/date_field.dart';

class NewProductForm extends StatefulWidget {
  final ProductModel product;
  bool forEdit;
  List designs;
  String edit_page_design,
      edit_product_name,
      edit_product_desc,
      edit_price,
      edit_quantity,
      edit_text_field,
      edit_text_area;
  NewProductForm(
      {Key key,
      @required this.product,
      this.forEdit,
      this.edit_page_design,
      this.edit_product_name,
      this.edit_price,
      this.edit_quantity,
      this.edit_product_desc,
      this.edit_text_area,
      this.edit_text_field,
      this.designs})
      : super(key: key);

  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  FirebaseUser loggedInuser;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

 

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _stockUnitController = TextEditingController();
  final TextEditingController _inventoryQtyController = TextEditingController();
  final TextEditingController _thresholdQtyController = TextEditingController();
  final TextEditingController _minOrderQtyController = TextEditingController();
  final TextEditingController _product_name_Controller =
      TextEditingController();
  final TextEditingController _description_Controller = TextEditingController();
  final TextEditingController _quantity_Controller = TextEditingController();
  final TextEditingController _text_field_Controller = TextEditingController();
  TextEditingController _text_area_Controller = TextEditingController();

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
   
    print(widget.forEdit);
    getCurrentUser();
    print("sssssssssssssssss");
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    productData = widget.product;

    final ProductModel product = widget.product;
    _nameController.text = product != null ? product.name : null;
    _descriptionController.text = product != null ? product.description : null;
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
        _descriptionController.text.length <= 0 ||
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
              description: _descriptionController.text,
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
    print(_descriptionController.text.length);
    if (_nameController.text.length <= 0 ||
        _descriptionController.text.length <= 0 ||
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
              description: _descriptionController.text,
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

  String page_design,
      product_name,
      product_desc,
      price,
      quantity,
      text_field,
      text_area;

  Padding makeTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: widget.forEdit ? null : _text_field_Controller,
        maxLength: 64,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Text Field",
        ),
        autovalidate: true,
        autocorrect: false,
        initialValue: widget.forEdit ? widget.edit_text_field : null,
        onChanged: (value) {
         
          if (widget.forEdit) {
            widget.edit_text_field = value;
            print(widget.edit_text_field);
          } else {
            text_field = value;
            print(text_field);
          }
         
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
    if (widget.forEdit == true) {
      _text_area_Controller =
          TextEditingController(text: widget.edit_text_area);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
          maxLines: 10,
          controller: _text_area_Controller,
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

  Column makeSelectedLayout() {
    return Column(
      children: <Widget>[
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextFormField(
            controller: widget.forEdit ? null : _product_name_Controller,
            maxLength: 64,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Product Name",
            ),
            autovalidate: true,
            autocorrect: false,
            initialValue: widget.forEdit ? widget.edit_product_name : null,
            onChanged: (value) {
              widget.forEdit
                  ? widget.edit_product_name = value
                  : product_name = value;
              print(product_name);
            },
            validator: (value) {
              return value.length < 3
                  ? 'Invalid Product name. Atleast 3 letter is needed.'
                  : null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextFormField(
            controller: widget.forEdit ? null : _description_Controller,
            maxLength: 64,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Description",
            ),
            autovalidate: true,
            autocorrect: false,
            initialValue: widget.forEdit ? widget.edit_product_desc : null,
            onChanged: (value) {
              
              widget.forEdit
                  ? widget.edit_product_desc = value
                  : product_desc = value;
              print(product_desc);
            },
            validator: (value) {
              return value.length < 3
                  ? 'Invalid Description. Atleast 3 letter is needed.'
                  : null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextFormField(
            controller: widget.forEdit ? null : _priceController,
            maxLength: 64,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Price",
            ),
            autovalidate: true,
            autocorrect: false,
            initialValue: widget.forEdit ? widget.edit_price : null,
            onChanged: (value) {
              widget.forEdit ? widget.edit_price = value : price = value;
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextFormField(
            controller: widget.forEdit ? null : _quantity_Controller,
            maxLength: 64,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Quantity",
            ),
            autovalidate: true,
            autocorrect: false,
            initialValue: widget.forEdit ? widget.edit_quantity : null,
            onChanged: (value) {
              widget.forEdit ? widget.edit_quantity = value : quantity = value;
              print(quantity);
            },
            validator: (value) {
              return value.length < 3
                  ? 'Invalid Quantity. Atleast 3 letter is needed.'
                  : null;
            },
          ),
        ),
        
      ],
    );
  }

  List images = [
    'https://firebasestorage.googleapis.com/v0/b/ShopEasyapp-16c50.appspot.com/o/e2a500be-7857-4773-a981-0b01c04cc23e.jpg?alt=media&token=ccd675df-a24b-4d45-ad55-ed591dd4547f'
  ];

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
                widget.forEdit ? "Edit Product" : "Add Product",
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                   
                                    child: DropDownFormField(
                                      filled: false,
                                      titleText: 'Page Design',
                                      hintText: 'Please Select Page Design',
                                      value: widget.forEdit
                                          ? widget.edit_page_design
                                          : page_design,
                                      onSaved: (value) {
                                        setState(() {
                                          page_design = value;
                                          widget.edit_page_design = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          page_design = value;
                                          print(page_design);
                                          widget.edit_page_design = value;
                                        });
                                      },
                                      dataSource: widget.designs,
                                      textField: 'display',
                                      valueField: 'value',
                                    ),
                                  ),
                                ),
                                makeSelectedLayout(),
                                makeTextField(),
                               makeTextArea(),
                            makeDateField(),
                               
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Featured",
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch(
                                        value: isFeatured,
                                        onChanged: (value) {
                                          setState(() {
                                            isFeatured = value;
                                          });
                                        },
                                        activeTrackColor:
                                            Theme.of(context).primaryColor,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ChipsInput(
                                    initialValue: sizes,
                                    decoration: InputDecoration(
                                        labelText: "Select Sizes",
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                            fontSize: 22.0,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    maxChips: 6,
                                    findSuggestions: (String query) async {
                                      await Future.delayed(Duration(seconds: 1),
                                          () {
                                        SizeProfile newProfile =
                                            SizeProfile(query, query);
                                        setState(() {
                                          sizeProfiles = [
                                            ...sizeProfiles,
                                            newProfile
                                          ];
                                        });
                                      });
                                      if (query.length != 0) {
                                        var lowercaseQuery =
                                            query.toLowerCase();
                                        return sizeProfiles.where((size) {
                                          return size.name
                                              .toLowerCase()
                                              .contains(query.toLowerCase());
                                        }).toList(growable: false)
                                          ..sort((a, b) => a.name
                                              .toLowerCase()
                                              .indexOf(lowercaseQuery)
                                              .compareTo(b.name
                                                  .toLowerCase()
                                                  .indexOf(lowercaseQuery)));
                                      }
                                      return sizeProfiles;
                                    },
                                    onChanged: (data) {
                                      updateSizes(data);
                                    },
                                    chipBuilder: (context, state, size) {
                                      return InputChip(
                                        key: ObjectKey(size),
                                        label: Text(size.name),
                                        onDeleted: () => state.deleteChip(size),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      );
                                    },
                                    suggestionBuilder: (context, state, size) {
                                      return ListTile(
                                        key: ObjectKey(size),
                                        title: Text(size.name),
                                        subtitle: Text("Create a new Size"),
                                        onTap: () =>
                                            state.selectSuggestion(size),
                                      );
                                    },
                                  ),
                                ),
                                ColorPicker(
                                  updateColors: updateColors,
                                  initialColors: colors,
                                ),
                                CategoryPicker(
                                  updateCategories: updateCategories,
                                  initalCategories: categories,
                                ),
                                BrandPicker(
                                  updateBrand: updateBrand,
                                  initalBrands: brand != null
                                      ? BrandModel(
                                          name: brand["name"],
                                          brandId: brand["brandId"])
                                      : null,
                                ),
                                Container(
                                  height: 300,
                                  child: ImagePicker(
                                    pickerTitle: "Pick Images",
                                    imageCount: 6,
                                    updateAssetImages: updateAssetImages,
                                    updateOldImages: updateOldImages,
                                    oldImages: oldImages,
                                  ),
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
                                          if (widget.forEdit == false) {
                                            showNotification(
                                                context,
                                                "Product Added Successfully",
                                                Colors.green);
                                            _firestore
                                                .collection('products')
                                                .add({
                                              'active': true,
                                              'name': product_name,
                                              'admin': loggedInuser.email,
                                              'design': page_design,
                                              'description': product_desc,
                                              'price': int.parse(
                                                  _priceController.text),
                                              'inventoryQty': int.parse(
                                                  _quantity_Controller.text),
                                              'text_field_value': text_field,
                                              'text_area_value': text_area,
                                              'minOrderQty': int.parse('1'),
                                              'thresholdQty': int.parse(
                                                  _quantity_Controller.text),
                                              'offerPrice': int.parse('80'),
                                              'stockPrice': '500',
                                              'sizes': sizes
                                                  .map((size) => {
                                                        "name": size.name,
                                                        "id": size.id
                                                      })
                                                  .toList(),
                                              'color': colors
                                                  .map((color) => {
                                                        "name": color.name,
                                                        "colorId":
                                                            color.colorId,
                                                        "code": color.code
                                                      })
                                                  .toList(),
                                              'categories': categories
                                                  .map((cat) => {
                                                        "name": cat.name,
                                                        "categoryId":
                                                            cat.categoryId
                                                      })
                                                  .toList(),
                                              'brand': brand,
                                              'images': images,
                                              'featured': isFeatured,
                                              'createdAt':
                                                  'July 1, 2020 at 12:12:49',
                                            });
                                          } else {
                                            showNotification(
                                                context,
                                                "Product Edited Successfully",
                                                Colors.green);
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
