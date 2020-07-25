import 'package:cloud_firestore/cloud_firestore.dart';

class SliderModel {
  final String sliderId, name;
  final bool active;
  final List images;

  SliderModel({this.name, this.active, this.sliderId, this.images});

  factory SliderModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return SliderModel(
      sliderId: doc.documentID,
      name: data["name"] ?? null,
      active: data["active"] ?? false,
      images: data["images"] ?? null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "active": active,
      "images": images,
      "sliderId": sliderId,
    };
  }
}
