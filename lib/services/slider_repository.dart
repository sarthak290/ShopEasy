import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/slider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class SliderRepository {
  final sliderCollection = Firestore().collection("sliders");

  
  Stream<List<SliderModel>> streamSliders() {
    try {
      return sliderCollection.where("active", isEqualTo: true).snapshots().map(
          (list) => list.documents
              .map((doc) => SliderModel.fromFirestore(doc))
              .toList());
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  
  Future saveImage(Asset asset) async {
    var uuid = new Uuid();
    var imageName = uuid.v4();

    String path = asset.name;
    String _extension = p.extension(path).split('?').first;

    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('$imageName${_extension.toLowerCase()}');
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }


  Future<void> addSlider(SliderModel slider) async {
    try {
      List images = [];
      for (var item in slider.images) {
        var url = await saveImage(item);
        images.add(url);
      }
      await sliderCollection.add({
        ...slider.toMap(),
        "images": images,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> editSlider(SliderModel slider, oldImages) async {
    try {
      List images = [];
      for (var item in slider.images) {
        var url = await saveImage(item);
        images.add(url);
      }

      await sliderCollection.document(slider.sliderId).updateData({
        ...slider.toMap(),
        "images": slider.images.length > 0 ? images : oldImages,
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> deleteSlider(String sliderId) async {
    try {
      await sliderCollection.document(sliderId).updateData(
          {"active": false, "updatedAt": FieldValue.serverTimestamp()});
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
}
