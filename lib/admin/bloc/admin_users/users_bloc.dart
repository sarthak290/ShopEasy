import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/services/user_repository.dart';
import './bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  @override
  UsersState get initialState => UsersLoading();

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is LoadUsers) {
      yield* _mapLoadUsersToState();
    }
  }

  Stream<UsersState> _mapLoadUsersToState() async* {
    yield UsersLoading();
    try {
      final UserRepository userRepository = UserRepository();
      yield UsersLoading();
      final Stream<List<UserModel>> users = userRepository.streamUsers();
      yield UsersLoaded(users: users);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield UsersLoadingFailed();
    }
  }
}
