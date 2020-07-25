import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/order.dart';

class OrdersRepository {
  final ordersCollection = Firestore().collection("orders");

 
  Stream<List<OrderModel>> streamOrders(String userId) {
    print(userId);
    try {
      print("coming here");
      return ordersCollection
          .where("userId", isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((list) => list.documents
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList());
    } on PlatformException catch (e) {
      print(e.message);
      throw e.message;
    } catch (e) {
      print(e);
      throw e.message;
    }
  }

 

  Stream<List<OrderModel>> streamAdminOrders() {
    try {
      return ordersCollection
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((list) => list.documents
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList());
    } on PlatformException catch (e) {
      print(e.message);
      throw e.message;
    }
  }

  Future<void> changeStatus(OrderModel order, String type) {
    try {
      if (type == "dispatched") {
        return ordersCollection.document(order.orderId).updateData(
          {"status2": type, "updatedAt": FieldValue.serverTimestamp()},
        );
      } else {
        return ordersCollection.document(order.orderId).updateData(
          {"status3": type, "updatedAt": FieldValue.serverTimestamp()},
        );
      }
    } on PlatformException catch (e) {
      print(e.message);
      throw e.message;
    }
  }
}
