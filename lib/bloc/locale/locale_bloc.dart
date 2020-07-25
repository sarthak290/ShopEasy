import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:matrix/widgets/app_localizations.dart';
import './bloc.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  @override
  LocaleState get initialState => LocaleState(locale: allTranslations.locale);

  @override
  Stream<LocaleState> mapEventToState(
    LocaleEvent event,
  ) async* {
    if (event is LocaleChanged) {
      yield* _mapLocaleChangedToState(event.newLocale);
    }
  }

  Stream<LocaleState> _mapLocaleChangedToState(Locale locale) async* {
    try {
      await allTranslations.setNewLanguage(locale.languageCode, true);
      yield LocaleState(locale: locale);
    } catch (e) {
      yield LocaleChangeFailed();
    }
  }
}
