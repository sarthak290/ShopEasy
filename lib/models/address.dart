import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id,
      name,
      phoneNumber,
      userId,
      flatNumber,
      colonyNumber,
      landmark,
      city,
      state;

  bool active;
  AddressModel(
      {this.id,
      this.name,
      this.city,
      this.colonyNumber,
      this.state,
      this.flatNumber,
      this.landmark,
      this.phoneNumber,
      this.userId,
      this.active});

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    //print(data);
    return AddressModel(
      id: doc.documentID,
      name: data['name'],
      userId: data["userId"],
      phoneNumber: data['phoneNumber'],
      active: data['active'],
      city: data["city"],
      colonyNumber: data["colonyNumber"],
      state: data["state"],
      flatNumber: data["flatNumber"],
      landmark: data["landmark"],
    );
  }

  factory AddressModel.fromJson(Map data) {
    //print(data);
    return AddressModel(
      id: data["id"],
      name: data['name'],
      userId: data["userId"],
      phoneNumber: data['phoneNumber'],
      active: data['active'],
      city: data["city"],
      colonyNumber: data["colonyNumber"],
      state: data["state"],
      flatNumber: data["flatNumber"],
      landmark: data["landmark"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "flatNumber": flatNumber,
      "colonyNumber": colonyNumber,
      "landmark": landmark,
      "city": city,
      "state": state
    };
  }
}
