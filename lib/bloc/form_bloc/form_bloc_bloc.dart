import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/services/address_repository.dart';

import 'package:matrix/services/user_repository.dart';
import './bloc.dart';

class FormBlocBloc extends Bloc<FormBlocEvent, FormBlocState> {
  @override
  FormBlocState get initialState => FormBlocState.empty();

  @override
  Stream<FormBlocState> mapEventToState(
    FormBlocEvent event,
  ) async* {
    if (event is EditUserimage) {
      yield* _mapEditUserImageToState(event.user);
    } else if (event is EditUserDetails) {
      yield* _mapEditUserDetailsToState(event.user);
    } else if (event is AddAddress) {
      yield* _mapAddAddressToState(event.address);
    } else if (event is EditAddress) {
      yield* _mapEditAddressToState(event.address);
    } else if (event is DeleteAddress) {
      yield* _mapDeleteAddressToState(event.addressId);
    }
  }

  Stream<FormBlocState> _mapEditUserImageToState(UserModel user) async* {
    yield FormBlocState.loading();
    try {
      final UserRepository userRepository = UserRepository();

      yield FormBlocState.loading();
      await userRepository.updateImage(user);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error adding brand");
    }
  }

  Stream<FormBlocState> _mapEditUserDetailsToState(UserModel user) async* {
    yield FormBlocState.loading();
    try {
      final UserRepository userRepository = UserRepository();

      yield FormBlocState.loading();
      await userRepository.updateUseDetails(user);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }

  Stream<FormBlocState> _mapAddAddressToState(AddressModel address) async* {
    yield FormBlocState.loading();
    try {
      final AddressRepository addressRepository = AddressRepository();

      yield FormBlocState.loading();
      await addressRepository.addAddress(address);
      yield FormBlocState.success();
    } catch (e) {
      //print("Error adding customer, ${e.message}");
      yield FormBlocState.failure("Error adding customer");
    }
  }

  Stream<FormBlocState> _mapEditAddressToState(AddressModel address) async* {
    yield FormBlocState.loading();
    try {
      final AddressRepository addressRepository = AddressRepository();

      yield FormBlocState.loading();
      await addressRepository.editAddress(address);
      yield FormBlocState.success();
    } catch (e) {
      //print("Error adding customer, ${e.message}");
      yield FormBlocState.failure("Error editings");
    }
  }

  Stream<FormBlocState> _mapDeleteAddressToState(String addressId) async* {
    yield FormBlocState.loading();
    try {
      final AddressRepository addressRepository = AddressRepository();

      yield FormBlocState.loading();
      await addressRepository.deleteAddress(addressId);
      yield FormBlocState.success();
    } catch (e) {
      //print("Error adding customer, ${e.message}");
      yield FormBlocState.failure("Error editings");
    }
  }
}
