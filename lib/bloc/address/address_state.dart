import 'package:equatable/equatable.dart';
import 'package:matrix/models/address.dart';
import 'package:meta/meta.dart';

abstract class AddressState extends Equatable {
  const AddressState();
}

class AddressLoading extends AddressState {
  @override
  List<Object> get props => [];
}

class AddressLoaded extends AddressState {
  final Stream<List<AddressModel>> data;

  AddressLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class AddressFailed extends AddressState {
  @override
  List<Object> get props => [];
}
