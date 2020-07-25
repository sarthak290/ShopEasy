import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;
  final bool isPhoneValid;
  final bool isSmsCodeValid;

  bool get isFormValid => isEmailValid && isPasswordValid;
  bool get isPhoneAuthValid => isPhoneValid;

  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isPhoneValid,
    @required this.isSmsCodeValid,
    this.message,
  });

  factory LoginState.empty() {
    return LoginState(
      isPhoneValid: true,
      isSmsCodeValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isPhoneValid: true,
      isSmsCodeValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.failure(message) {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isPhoneValid: true,
        isSmsCodeValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  factory LoginState.success() {
    return LoginState(
      isPhoneValid: true,
      isSmsCodeValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  LoginState update(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isPhoneValid,
      bool isSmsCodeValid}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPhoneValid: isPhoneValid,
      isSmsCodeValid: isSmsCodeValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    bool isPhoneValid,
    bool isSmsCodeValid,
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
        isPhoneValid: isPhoneValid ?? this.isPhoneValid,
        isSmsCodeValid: isSmsCodeValid ?? this.isSmsCodeValid,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        message: message ?? this.message);
  }

  @override
  String toString() {
    return '''LoginState {
      isPhoneValid: $isPhoneValid,
      isSmsCodeValid: $isSmsCodeValid,
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message
    }''';
  }
}
