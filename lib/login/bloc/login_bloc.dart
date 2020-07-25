import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/login/login.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:matrix/utils/validators.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithFacebookPressed) {
      yield* _mapLoginWithFacebookPressed();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event.phone);
    } else if (event is LoginWithPhonePressed) {
      yield* _mapLoginWithPhonePressedToState(
          smsCode: event.smsCode, verificationCode: event.verificationCode);
    }
  }

  Stream<LoginState> _mapPhoneChangedToState(String phone) async* {
    yield state.update(
      isPhoneValid: phone.length == 10,
    );
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } on PlatformException catch (e) {
      yield LoginState.failure(e.message);
    }
  }

  Stream<LoginState> _mapLoginWithFacebookPressed() async* {
    try {
      var user = await _userRepository.signInWithFacebook();
      print("Cheking for $user");
      if (user != null) {
        yield LoginState.success();
      } else {
        yield LoginState.failure("Cancelled by user");
      }
    } on PlatformException catch (e) {
      yield LoginState.failure(e.message);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } on PlatformException catch (e) {
      yield LoginState.failure(e.message);
    }
  }


  Stream<LoginState> _mapLoginWithPhonePressedToState(
      {String smsCode, String verificationCode}) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithPhone(smsCode, verificationCode);
      yield LoginState.success();
    } on PlatformException catch (e) {
      yield LoginState.failure(e.message);
    }
  }
}

