import 'package:equatable/equatable.dart';
import 'package:matrix/models/user.dart';
import 'package:meta/meta.dart';

abstract class UsersState extends Equatable {
  const UsersState();
}

class UsersLoading extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersLoaded extends UsersState {
  final Stream<List<UserModel>> users;
  UsersLoaded({@required this.users});

  @override
  List<Object> get props => [];
}

class UsersLoadingFailed extends UsersState {
  @override
  List<Object> get props => [];
}
