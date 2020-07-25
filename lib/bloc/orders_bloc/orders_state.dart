import 'package:equatable/equatable.dart';
import 'package:matrix/models/order.dart';
import 'package:meta/meta.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
}

class OrdersLoading extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
  final Stream<List<OrderModel>> orders;

  OrdersLoaded({@required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrdersFailed extends OrdersState {
  @override
  List<Object> get props => [];
}
