import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/models/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsLoading extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductsLoaded extends ProductsState {
  final Stream<List<ProductModel>> products;

  ProductsLoaded({@required this.products});

  @override
  List<Object> get props => [products];
}

class ProductsLoadingFailed extends ProductsState {
  @override
  List<Object> get props => [];
}
