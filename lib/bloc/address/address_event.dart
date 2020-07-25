import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();
}

class LoadAddresss extends AddressEvent {
  final String userId;
  LoadAddresss({@required this.userId}) : assert(userId != null);

  @override
  List<Object> get props => [];
}
