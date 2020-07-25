import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/order.dart';
import 'package:matrix/services/orders_repository.dart';
import './bloc.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  @override
  AdminOrdersState get initialState => AdminOrdersLoading();

  @override
  Stream<AdminOrdersState> mapEventToState(
    AdminOrdersEvent event,
  ) async* {
    if (event is LoadAdminOrders) {
      yield* _mapLoadAdminOrdersToState();
    } else if (event is ChnageOrderStatus) {
      yield* _mapChnageOrderStatusToState(event.order, event.type);
    }
  }

  Stream<AdminOrdersState> _mapLoadAdminOrdersToState() async* {
    yield AdminOrdersLoading();
    try {
      yield AdminOrdersLoading();
      final OrdersRepository ordersRepository = OrdersRepository();
      final Stream<List<OrderModel>> orders =
          ordersRepository.streamAdminOrders();
      yield AdminOrdersLoaded(orders: orders);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminOrdersFailed();
    }
  }

  Stream<AdminOrdersState> _mapChnageOrderStatusToState(
      OrderModel order, String type) async* {
    try {
      final OrdersRepository ordersRepository = OrdersRepository();
      ordersRepository.changeStatus(order, type);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminOrdersFailed();
    }
  }
}
