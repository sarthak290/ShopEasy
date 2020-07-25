import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryId, description, name;
  final bool active, deleted, featured;
  final List images;

  CategoryModel({
    this.name,
    this.active,
    this.deleted,
    this.description,
    this.images,
    this.featured,
    this.categoryId,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return CategoryModel(
      categoryId: doc.documentID,
      name: data["name"] ?? null,
      active: data["active"] ?? false,
      deleted: data["deleted"] ?? false,
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
