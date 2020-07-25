import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/cart.dart';

class CartRepository {
  final cartCollection = Firestore().collection("carts");

  
  Stream<List<CartModel>> streamCarts(String userId) {
    try {
      return cartCollection
          .where("deleted", isEqualTo: false)
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((list) => list.documents
              .map((doc) => CartModel.fromFirestore(doc))
              .toList());
    } on PlatformException catch (e) {
      print(e.message);
      throw e.message;
    }
  }

  Future<void> updateQty(CartModel cart, type) async {
    try {
      await cartCollection.document(cart.cartId).updateData({
        "qty": type == "increment"
            ? FieldValue.increment(1)
            : FieldValue.increment(-1),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> toggleCart(CartModel cart, String userId) async {
    try {
      final data = await cartCollection.document(cart.cartId).get();

      if (data.exists) {
        await cartCollection.document(cart.cartId).updateData({
          "deleted": !cart.deleted,
          "updatedAt": FieldValue.serverTimestamp()
        });
      } else {
        await cartCollection.document().setData({
          "productId": cart.productId,
          "product": cart.product.toMap(),
          "userId": cart.userId,
          "deleted": cart.deleted,
          "qty": 1,
          "updatedAt": FieldValue.serverTimestamp()
        });
      }
    } on PlatformException catch (e) {
      print(e.message);
      return null;
    }
  }
}
