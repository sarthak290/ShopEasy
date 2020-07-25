import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/favorites.dart';

class FavoriteRepository {
  final favCollection = Firestore().collection("favorites");

 
  Stream<List<FavoriteModel>> streamFavorites(String userId) {
    try {
      return favCollection
          .where("favorite", isEqualTo: true)
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((list) => list.documents
              .map((doc) => FavoriteModel.fromFirestore(doc))
              .toList());
    } on PlatformException catch (e) {
      print(e.message);
      throw e.message;
    }
  }

  Future<void> toggleFavorite(FavoriteModel fav, String userId) async {
    try {
      final data = await favCollection.document(fav.favId).get();

      if (data.exists) {
        await favCollection.document(fav.favId).updateData({
          "favorite": !fav.favorite,
          "updatedAt": FieldValue.serverTimestamp()
        });
      } else {
        await favCollection.document().setData({
          "productId": fav.productId,
          "userId": fav.userId,
          "favorite": fav.favorite,
          "updatedAt": FieldValue.serverTimestamp()
        });
      }
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
}
