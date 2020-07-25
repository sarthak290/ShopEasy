import 'package:meta/meta.dart';

@immutable
class FormBlocState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;

  FormBlocState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.message,
  });

  factory FormBlocState.empty() {
    return FormBlocState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory FormBlocState.loading() {
    return FormBlocState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory FormBlocState.failure(message) {
    return FormBlocState(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  factory FormBlocState.success() {
    return FormBlocState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  FormBlocState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return FormBlocState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        message: message ?? this.message);
  }

  @override
  String toString() {
    return '''FormBlocState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message
    }''';
  }
}
