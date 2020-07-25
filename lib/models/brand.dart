import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String brandId, description, name;
  final bool active, featured;
  final List images;

  BrandModel({
    this.name,
    this.active,
    this.description,
    this.images,
    this.featured,
    this.brandId,
  });

  factory BrandModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return BrandModel(
      brandId: doc.documentID,
      name: data["name"] ?? null,
      active: data["active"] ?? false,
      description: data["description"] ?? null,
      featured: data["featured"] ?? false,
      images: data["images"] ?? "https://i.imgur.com/RS2mTYj.jpg",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "active": active,
      "description": description,
      "featured": featured,
      "images": images,
    };
  }
}
