import 'package:equatable/equatable.dart';
import 'package:matrix/models/cart.dart';
import 'package:meta/meta.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartLoading extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final Stream<List<CartModel>> cart;

  CartLoaded({@required this.cart});

  @override
  List<Object> get props => [cart];
}

class CartFailed extends CartState {
  @override
  List<Object> get props => [];
}
