import 'package:equatable/equatable.dart';
import 'package:matrix/models/cart.dart';
import 'package:meta/meta.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCart extends CartEvent {
  final String userId;

  LoadCart({@required this.userId}) : assert(userId != null);
  @override
  List<Object> get props => [];
}

class ToggleCart extends CartEvent {
  final String userId;
  final CartModel cart;

  ToggleCart({@required this.userId, @required this.cart})
      : assert(userId != null);
  @override
  List<Object> get props => [];
}

class UpdateCartQty extends CartEvent {
  final String type;
  final CartModel cart;

  UpdateCartQty({@required this.type, @required this.cart});
  @override
  List<Object> get props => [];
}
