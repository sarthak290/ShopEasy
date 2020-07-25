import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class LoadUsers extends UsersEvent {
  @override
  List<Object> get props => [];
}
