import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/services/user_repository.dart';
import './bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield* _mapLoadUserToState();
    }
  }

  Stream<UserState> _mapLoadUserToState() async* {
    yield UserLoading();
    try {
      yield UserLoading();
      final UserRepository userRepository = UserRepository();
      final currentUser = await userRepository.getCurrentUser();

      final Stream<UserModel> user = userRepository.getUser(currentUser.uid);
      yield UserLoaded(user);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield UserLoadingFailed();
    }
  }
}
