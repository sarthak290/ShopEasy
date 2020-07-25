import 'package:equatable/equatable.dart';
import 'package:matrix/models/order.dart';
import 'package:meta/meta.dart';

abstract class AdminOrdersState extends Equatable {
  const AdminOrdersState();
}

class AdminOrdersLoading extends AdminOrdersState {
  @override
  List<Object> get props => [];
}

class AdminOrdersLoaded extends AdminOrdersState {
  final Stream<List<OrderModel>> orders;

  AdminOrdersLoaded({@required this.orders});

  @override
  List<Object> get props => [orders];
}

class AdminOrdersFailed extends AdminOrdersState {
  @override
  List<Object> get props => [];
}
