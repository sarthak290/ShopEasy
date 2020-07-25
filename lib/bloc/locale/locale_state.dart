import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleState extends Equatable {
  final Locale locale;

  LocaleState({this.locale});
  @override
  List<Object> get props => [locale];
}

class LocaleChangeFailed extends LocaleState {
  @override
  List<Object> get props => [];
}
