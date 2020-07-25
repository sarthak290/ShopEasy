import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/services/user_repository.dart';

class AddressRepository {
  final addressCollection = Firestore().collection("address");

  Stream<List<AddressModel>> streamAddress(String userId) {
    //print(userId);
    try {
      return addressCollection
          .where("active", isEqualTo: true)
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((list) {
        //print(list.documents);
        return list.documents.map((doc) {
          return AddressModel.fromFirestore(doc);
        }).toList();
      });
    } on PlatformException catch (e) {
      //print(e);
      return null;
    } catch (err) {
      //print(err);
      return null;
    }
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      final UserRepository userRepository = UserRepository();
      final user = await userRepository.getCurrentUser();

      await addressCollection.add({
        ...address.toMap(),
        "userId": user.uid,
        "active": true,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      });
    } on PlatformException catch (e) {
      //print(e.message);
      return null;
    }
  }

  Future<void> editAddress(AddressModel address) async {
    try {
      await addressCollection.document(address.id).updateData(
          {...address.toMap(), "updatedAt": FieldValue.serverTimestamp()});
    } on PlatformException catch (e) {
      //print(e.message);
      throw e;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await addressCollection.document(addressId).updateData(
          {"active": false, "updatedAt": FieldValue.serverTimestamp()});
    } on PlatformException catch (e) {
      //print(e.message);
      return null;
    }
  }
}
