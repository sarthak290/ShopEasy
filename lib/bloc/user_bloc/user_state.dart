import 'package:equatable/equatable.dart';
import 'package:matrix/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final Stream<UserModel> user;
  UserLoaded(this.user);

  @override
  List<Object> get props => [];
}

class UserLoadingFailed extends UserState {
  @override
  List<Object> get props => [];
}
