import 'package:equatable/equatable.dart';
import 'package:matrix/models/order.dart';
import 'package:meta/meta.dart';

abstract class AdminOrdersEvent extends Equatable {
  const AdminOrdersEvent();
}

class LoadAdminOrders extends AdminOrdersEvent {
  @override
  List<Object> get props => [];
}

class ChnageOrderStatus extends AdminOrdersEvent {
  final OrderModel order;
  final String type;
  ChnageOrderStatus({@required this.order, @required this.type});

  @override
  List<Object> get props => [];
}
