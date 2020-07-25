import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final String favId, productId, userId;
  bool favorite;
  FavoriteModel({this.favId, this.productId, this.favorite, this.userId});

  factory FavoriteModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return FavoriteModel(
        favId: doc.documentID,
        productId: data['productId'],
        userId: data['userId'],
        favorite: data["favorite"]);
  }
}
