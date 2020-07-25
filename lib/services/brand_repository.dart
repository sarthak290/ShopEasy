import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/brand.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class BrandRepository {
  final brandCollection = Firestore().collection("brands");

 
  Stream<List<BrandModel>> streamBrands() {
    try {
      return brandCollection.where("active", isEqualTo: true).snapshots().map(
          (list) => list.documents
              .map((doc) => BrandModel.fromFirestore(doc))
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

    ByteData byteData = await asset.getThumbByteData(1080, 1080, quality: 70);
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('$imageName${_extension.toLowerCase()}');
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  

  Future<void> addBrand(BrandModel brand) async {
    try {
      List images = [];
      for (var item in brand.images) {
        var url = await saveImage(item);
        images.add(url);
      }
      print(images);
      await brandCollection.add({
        ...brand.toMap(),
        "images": images,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> editBrand(BrandModel brand, oldImages) async {
    try {
      List images = [];
      for (var item in brand.images) {
        var url = await saveImage(item);
        images.add(url);
      }

      await brandCollection.document(brand.brandId).updateData({
        ...brand.toMap(),
        "images": [...images, ...oldImages],
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> deleteBrand(String brandId) async {
    try {
      await brandCollection.document(brandId).updateData(
          {"active": false, "updatedAt": FieldValue.serverTimestamp()});
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
}
