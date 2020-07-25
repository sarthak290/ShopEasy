import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid, avatarURL, displayName, email, type, role;
  final Map address;
  UserModel(
      {this.uid,
      this.avatarURL,
      this.displayName,
      this.email,
      this.type,
      this.address,
      this.role});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return UserModel(
      uid: doc.documentID,
      avatarURL: data['avatarURL'],
      displayName: data['displayName'] != null ? data['displayName'] : "User",
      email: data['email'] != null ? data["email"] : "email@email.com",
      type: data['type'],
      role: data['role'],
      address: data["address"] != null
          ? data["address"] is String ? null : data["address"]
          : null,
    );
  }
}
