import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginWithGooglePressed extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginWithFacebookPressed extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

class PhoneChanged extends LoginEvent {
  final String phone;

  PhoneChanged({@required this.phone});

  @override
  List<Object> get props => [phone];
}

class SendVerificationCodePressed extends LoginEvent {
  final String phone;

  SendVerificationCodePressed({@required this.phone});

  @override
  List<Object> get props => [phone];
}

class LoginWithPhonePressed extends LoginEvent {
  final String smsCode;
  final String verificationCode;

  LoginWithPhonePressed(
      {@required this.smsCode, @required this.verificationCode});

  @override
  List<Object> get props => [smsCode, verificationCode];
}
