import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  final String type;

  ThemeChanged({@required this.type});

  @override
  List<Object> get props => [type];
}
