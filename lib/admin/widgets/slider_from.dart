import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/image_picker.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/widgets/progress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SlidersForm extends StatefulWidget {
  final SliderModel slider;

  SlidersForm({Key key, @required this.slider}) : super(key: key);

  _SlidersFormState createState() => _SlidersFormState();
}

class _SlidersFormState extends State<SlidersForm> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  List<Asset> assetImages = List<Asset>();
  List<String> oldImages;
  SliderModel sliderData;

  FormBlocBloc _formBlocBloc;

  @override
  void initState() {
    super.initState();
    _formBlocBloc = BlocProvider.of<FormBlocBloc>(context);
    final SliderModel slider = widget.slider;
    sliderData = widget.slider;
    _nameController.text = slider != null ? slider.name : null;
    oldImages = slider != null && slider.images != null
        ? slider.images.cast<String>()
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
    if (_nameController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      _formBlocBloc.add(
        AddSlider(
          slider: SliderModel(
            active: true,
            name: _nameController.text,
            images: assetImages,
          ),
        ),
      );
    }
  }

  void onUpdate(BuildContext context) async {
    print(_nameController.text.length);
    if (_nameController.text.length <= 0) {
      showNotification(context, "Add all the details", Colors.redAccent);
    } else {
      

      print("onUpdate is called");
      print(assetImages);
      print("OLD IMAGES ON UPDATE $oldImages");

      _formBlocBloc.add(
        EditSlider(
            slider: SliderModel(
              sliderId: sliderData.sliderId,
              active: true,
              name: _nameController.text,
              images: assetImages,
            ),
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
            showNotification(context, "Error adding Slider", Colors.redAccent);
          } else if (state.isSubmitting) {
            setState(() {
              _saving = true;
            });
          } else if (state.isSuccess) {
            setState(() {
              _saving = false;
            });
            showNotification(
                context, "Slider added successfully", Colors.green);
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
                sliderData != null ? "Edit Slider" : "Add Slider",
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
                                      labelText: "Slider Name",
                                    ),
                                    autovalidate: true,
                                    autocorrect: false,
                                    validator: (value) {
                                      return value.length < 3
                                          ? 'Invalid Slider name. Atleast 3 letter is needed.'
                                          : null;
                                    },
                                  ),
                                ),
                                Container(
                                  height: 300,
                                  child: ImagePicker(
                                    oldImages: oldImages,
                                    pickerTitle: "Pick Images",
                                    imageCount: 1,
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
                                        onPressed: () => widget.slider != null
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
