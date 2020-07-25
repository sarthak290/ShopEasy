import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final String type;

  ThemeState({this.type});
  @override
  List<Object> get props => [type];
}

class ThemeChangedFailed extends ThemeState {
  @override
  List<Object> get props => [];
}
