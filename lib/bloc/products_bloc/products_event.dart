import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

class LoadProducts extends ProductsEvent {
  @override
  List<Object> get props => [];
}
