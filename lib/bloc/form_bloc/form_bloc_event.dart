import 'package:equatable/equatable.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/models/user.dart';
import 'package:meta/meta.dart';

abstract class FormBlocEvent extends Equatable {
  const FormBlocEvent();
}

class EditUserimage extends FormBlocEvent {
  final UserModel user;
  EditUserimage({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class EditUserDetails extends FormBlocEvent {
  final UserModel user;
  EditUserDetails({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class AddAddress extends FormBlocEvent {
  final AddressModel address;
  AddAddress({@required this.address}) : assert(address != null);

  @override
  List<Object> get props => [address];
}

class EditAddress extends FormBlocEvent {
  final AddressModel address;
  EditAddress({@required this.address}) : assert(address != null);

  @override
  List<Object> get props => [address];
}

class DeleteAddress extends FormBlocEvent {
  final String addressId;
  DeleteAddress({@required this.addressId}) : assert(addressId != null);

  @override
  List<Object> get props => [addressId];
}
