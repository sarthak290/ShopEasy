import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/models/cart.dart';

class OrderModel {
  final status, paymentId, orderId, userId, status1, status2, status3;
  final double totalAmount, taxAmount, subTotal;
  final List<CartModel> cart;
  final DateTime createdAt;
  final AddressModel address;

  OrderModel(
      {this.orderId,
      this.status,
      this.subTotal,
      this.cart,
      this.userId,
      this.taxAmount,
      this.createdAt,
      this.totalAmount,
      this.status1,
      this.status2,
      this.address,
      this.status3,
      this.paymentId});

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    try {
      return OrderModel(
          orderId: doc.documentID,
          paymentId: data["paymentId"] ?? null,
          cart: data["cart"]
              .map((c) => CartModel.fromMap(c))
              .toList()
              .cast<CartModel>(),
          createdAt: DateTime.fromMillisecondsSinceEpoch(
              data['createdAt'].millisecondsSinceEpoch),
          status: data["status"],
          subTotal: data["subTotal"] != null ? data["subTotal"] + 0.0 : 0.0,
          totalAmount:
              data["totalAmount"] != null ? data["totalAmount"] + 0.0 : 0.0,
          taxAmount: data["taxAmount"] != null ? data["taxAmount"] + 0.0 : 0.0,
          userId: data["userId"],
          status1: data["status1"],
          status2: data["status2"],
          status3: data["status3"],
          address: data["address"] == null
              ? null
              : AddressModel.fromJson(data["address"]));
    } catch (e) {
      print(e);
      throw null;
    }
  }
}
