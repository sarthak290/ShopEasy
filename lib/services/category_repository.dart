import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/category.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class CategoryRepository {
  final categoryCollection = Firestore().collection("categories");

 
  Stream<List<CategoryModel>> streamCategorys() {
    try {
      return categoryCollection
          .where("active", isEqualTo: true)
          .snapshots()
          .map((list) => list.documents
              .map((doc) => CategoryModel.fromFirestore(doc))
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

  

  Future<void> addCategory(CategoryModel category) async {
    try {
      List images = [];
      for (var item in category.images) {
        var url = await saveImage(item);
        images.add(url);
      }
      print(images);
      await categoryCollection.add({
        ...category.toMap(),
        "images": images,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> editCategory(CategoryModel category, oldImages) async {
    try {
      List images = [];
      for (var item in category.images) {
        var url = await saveImage(item);
        images.add(url);
      }

      await categoryCollection.document(category.categoryId).updateData({
        ...category.toMap(),
        "images": [...images, ...oldImages],
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await categoryCollection.document(categoryId).updateData(
          {"active": false, "updatedAt": FieldValue.serverTimestamp()});
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
}
