import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/services/cart_repository.dart';
import './bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  @override
  CartState get initialState => CartLoading();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is LoadCart) {
      yield* _mapLoadCartToState(event.userId);
    } else if (event is ToggleCart) {
      yield* _mapToggleCartToState(event.cart, event.userId);
    } else if (event is UpdateCartQty) {
      yield* _mapUpdateCartQtyToState(event.cart, event.type);
    }
  }

  Stream<CartState> _mapLoadCartToState(String userId) async* {
    yield CartLoading();
    try {
      yield CartLoading();
      final CartRepository cartRepository = CartRepository();
      final Stream<List<CartModel>> cart = cartRepository.streamCarts(userId);
      yield CartLoaded(cart: cart);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield CartFailed();
    }
  }

  Stream<CartState> _mapToggleCartToState(
      CartModel cart, String userId) async* {
    try {
      final CartRepository cartRepository = CartRepository();
      cartRepository.toggleCart(cart, userId);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield CartFailed();
    }
  }

  Stream<CartState> _mapUpdateCartQtyToState(
      CartModel cart, String type) async* {
    try {
      final CartRepository cartRepository = CartRepository();
      cartRepository.updateQty(cart, type);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield CartFailed();
    }
  }
}
