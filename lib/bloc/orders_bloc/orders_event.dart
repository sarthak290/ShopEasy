import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
}

class LoadOrders extends OrdersEvent {
  final String userId;

  LoadOrders({@required this.userId});
  @override
  List<Object> get props => [userId];
}
