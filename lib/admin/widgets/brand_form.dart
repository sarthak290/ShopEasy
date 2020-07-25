import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/image_picker.dart';
import 'package:matrix/models/brand.dart';
import 'package:matrix/widgets/progress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class BrandsForm extends StatefulWidget {
  final BrandModel brand;

  BrandsForm({Key key, @required this.brand}) : super(key: key);

  _BrandsFormState createState() => _BrandsFormState();
}

class _BrandsFormState extends State<BrandsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  bool isFeatured = false;
  bool _saving = false;
  List<Asset> assetImages = List<Asset>();
  List<String> oldImages;
  BrandModel brandData;

  FormBlocBloc _formBlocBloc;

  @override
  void initState() {
    super.initState();
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    final BrandModel brand = widget.brand;
    brandData = widget.brand;
    isFeatured = brand != null ? brand.featured : false;
    _nameController.text = brand != null ? brand.name : null;
    _descriptionController.text = brand != null ? brand.description : null;
    oldImages = brand != null && brand.images != null
        ? brand.images.cast<String>()
        : null;
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


  

  void onSubit(BuildContext context) async {
    print(_nameController.text.length);
    print(_descriptionController.text.length);
    if (_nameController.text.length <= 0 ||
        _descriptionController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      _formBlocBloc.add(
        AddAdminBrands(
          brand: BrandModel(
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
      

      print("onUpdate is called");
      print(assetImages);
      print("OLD IMAGES ON UPDATE $oldImages");

      _formBlocBloc.add(
        EditAdminBrand(
            brand: BrandModel(
                brandId: brandData.brandId,
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
            showNotification(context, "Error adding brand", Colors.redAccent);
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
                brandData != null ? "Edit Brand" : "Add Brand",
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
                                  child: TextFormField(
                                    controller: _nameController,
                                    maxLength: 64,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Brand Name",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid Brand name. Atleast 3 letter is needed.'
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
                                      labelText: "Brand description",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid input. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),
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
                                Container(
                                  height: 300,
                                  child: ImagePicker(
                                    oldImages: oldImages,
                                    pickerTitle: "Pick Images",
                                    imageCount: 6,
                                    updateAssetImages: updateAssetImages,
                                    updateOldImages: updateOldImages,
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
                                        onPressed: () => widget.brand != null
                                            ? onUpdate(context)
                                            : onSubit(context),
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
