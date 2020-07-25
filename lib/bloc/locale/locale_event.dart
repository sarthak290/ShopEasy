import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
}

class LocaleChanged extends LocaleEvent {
  final Locale newLocale;

  LocaleChanged({@required this.newLocale});

  @override
  List<Object> get props => [newLocale];
}
