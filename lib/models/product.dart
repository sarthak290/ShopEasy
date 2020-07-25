import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId, description, stockUnit, name;
  final int inventoryQty, minOrderQty, thresholdQty, tax;
  final double price, offerPrice;
  final List images, sizes, colors, categories;
  final Map brand;
  final bool active, featured, offer;

  ProductModel({
    this.name,
    this.active,
    this.tax,
    this.description,
    this.featured,
    this.inventoryQty,
    this.minOrderQty,
    this.offer,
    this.offerPrice,
    this.price,
    this.sizes,
    this.colors,
    this.categories,
    this.brand,
    this.productId,
    this.images,
    this.stockUnit,
    this.thresholdQty,
  });

  factory ProductModel.fromMap(Map data) {
    try {
      return ProductModel(
        name: data["name"] ?? null,
        active: data["active"] ?? false,
        description: data["description"] ?? null,
        featured: data["featured"] ?? false,
        inventoryQty: data["inventoryQty"] ?? 0,
        minOrderQty: data["minOrderQty"] ?? 1,
        offer: data["offer"] ?? false,
        offerPrice: data["offerPrice"] != null ? data["offerPrice"] + 0.0 : 0.0,
        price: data["price"] != null ? data["price"] + 0.0 : 0.0,
        stockUnit: data["stockUnit"] ?? "SKU",
        thresholdQty: data["thresholdQty"] ?? 0,
        tax: data["tax"] != null ? data["tax"] : 0,
        images: data["images"] ?? null,
        sizes: data["sizes"] ?? null,
        colors: data["colors"] ?? null,
        categories: data["categories"] ?? null,
        brand: data["brand"] ?? null,
      );
    } catch (e) {
      print(e);
      throw null;
    }
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    try {
      return ProductModel(
        productId: doc.documentID,
        name: data["name"] ?? null,
        active: data["active"] ?? false,
        description: data["description"] ?? null,
        featured: data["featured"] ?? false,
        inventoryQty: data["inventoryQty"] ?? 0,
        minOrderQty: data["minOrderQty"] ?? 1,
        offer: data["offer"] ?? false,
        offerPrice: data["offerPrice"] != null ? data["offerPrice"] + 0.0 : 0.0,
        price: data["price"] != null ? data["price"] + 0.0 : 0.0,
        stockUnit: data["stockUnit"] ?? "SKU",
        thresholdQty: data["thresholdQty"] ?? 0,
        tax: data["tax"] != null ? data["tax"] : 0,
        images: data["images"] ?? null,
        sizes: data["sizes"] ?? null,
        colors: data["colors"] ?? null,
        categories: data["categories"] ?? null,
        brand: data["brand"] ?? null,
      );
    } catch (e) {
      print(e);
      throw null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "active": active,
      "description": description,
      "featured": featured,
      "images": images,
      "inventoryQty": inventoryQty,
      "minOrderQty": minOrderQty,
      "offer": offer,
      "offerPrice": offerPrice,
      "price": price,
      "stockUnit": stockUnit,
      "thresholdQty": thresholdQty,
      "tax": tax,
      "sizes": sizes,
      "colors": colors,
      "categories": categories,
      "brand": brand
    };
  }
}
