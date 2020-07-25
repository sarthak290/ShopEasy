import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/order.dart';
import 'package:matrix/services/orders_repository.dart';
import './bloc.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  @override
  OrdersState get initialState => OrdersLoading();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is LoadOrders) {
      yield* _mapLoadOrdersToState(event.userId);
    }
  }

  Stream<OrdersState> _mapLoadOrdersToState(String userId) async* {
    yield OrdersLoading();
    try {
      yield OrdersLoading();
      final OrdersRepository ordersRepository = OrdersRepository();
      final Stream<List<OrderModel>> orders =
          ordersRepository.streamOrders(userId);
      yield OrdersLoaded(orders: orders);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield OrdersFailed();
    }
  }
}
