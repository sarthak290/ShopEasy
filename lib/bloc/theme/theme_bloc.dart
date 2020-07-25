import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/services/theme_repository.dart';
import './bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => ThemeState();

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield* _mapThemeChangedToState(event.type);
    }
  }

  Stream<ThemeState> _mapThemeChangedToState(String type) async* {
    try {
      await themeRepository.setPreferredTheme(type);

      yield ThemeState(type: type);
    } catch (e) {
      yield ThemeChangedFailed();
    }
  }
}
