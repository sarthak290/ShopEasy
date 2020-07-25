import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagePicker extends StatefulWidget {
  final String pickerTitle;
  final int imageCount;
  final updateAssetImages;
  final updateOldImages;
  final List<String> oldImages;
  ImagePicker({
    Key key,
    this.pickerTitle = "Pick image",
    this.imageCount = 1,
    this.oldImages,
    @required this.updateAssetImages,
    @required this.updateOldImages,
  }) : super(key: key);

  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  List<Asset> images = List<Asset>();
  var urlImages;

  @override
  void initState() {
    super.initState();
    urlImages = widget.oldImages != null
        ? new List<String>.from(widget.oldImages)
        : null;
  }

  Widget buildGridViewUrls() {
    return GridView.count(
      crossAxisCount: 3,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children:
          List.generate(urlImages != null ? urlImages.length : 0, (index) {
        String url = urlImages[index];
        return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: <Widget>[
                Image.network(
                  url,
                  width: 150,
                  height: 150,
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        urlImages.removeAt(index);
                      });
                      widget.updateOldImages(urlImages);
                    },
                    child: Material(
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                        child: Center(
                          child: Icon(Icons.close,
                              size: 18, color: Theme.of(context).buttonColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
      }),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(images != null ? images.length : 0, (index) {
        Asset asset = images[index];
        return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: <Widget>[
                AssetThumb(
                  asset: asset,
                  width: 150,
                  height: 150,
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                    child: Material(
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                        child: Center(
                          child: Icon(Icons.close,
                              size: 18, color: Theme.of(context).buttonColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
      }),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: widget.imageCount,
      );
    } on NoImagesSelectedException catch (e) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(e.message),
      ));
    } catch (e) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(e.message),
      ));
    }

   
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
    widget.updateAssetImages(resultList);
  }

  @override
  Widget build(BuildContext context) {
    print(urlImages);
    return Container(
      child: Column(
        children: <Widget>[
          urlImages != null
              ? RaisedButton(
                  child: Text(
                    "Old Images",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: loadAssets,
                  color: Theme.of(context).primaryColor,
                )
              : SizedBox(),
          urlImages != null
              ? Flexible(
                  child: buildGridViewUrls(),
                )
              : SizedBox(),
          RaisedButton(
            child: Text(
              widget.pickerTitle,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: loadAssets,
            color: Theme.of(context).primaryColor,
          ),
          Flexible(
            child: buildGridView(),
          )
        ],
      ),
    );
  }
}
