import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matrix/models/product.dart';

class CartModel {
  final String cartId, productId, userId;
  bool deleted, ordered;
  ProductModel product;
  int qty;
  CartModel(
      {this.cartId,
      this.ordered,
      this.productId,
      this.deleted,
      this.userId,
      this.qty,
      this.product});

  factory CartModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return CartModel(
      cartId: doc.documentID,
      qty: data["qty"],
      productId: data['productId'],
      product: ProductModel.fromMap(data["product"]),
      userId: data['userId'],
      deleted: data["deleted"],
      ordered: data["ordered"],
    );
  }

  factory CartModel.fromMap(Map data) {
    return CartModel(
      cartId: data["cartId"],
      qty: data["qty"],
      productId: data['productId'],
      product: ProductModel.fromMap(data["product"]),
      userId: data['userId'],
      deleted: data["deleted"],
      ordered: data["ordered"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cartId": cartId,
      "qty": qty,
      "productId": productId,
      "product": product.toMap(),
      "userId": userId,
      "deleted": deleted,
      "ordered": ordered,
    };
  }
}
