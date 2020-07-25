import 'package:equatable/equatable.dart';
import 'package:matrix/models/product.dart';
import 'package:meta/meta.dart';

abstract class AdminproductEvent extends Equatable {
  const AdminproductEvent();
}

class LoadProducts extends AdminproductEvent {
  @override
  List<Object> get props => [];
}

class DeleteAdminProduct extends AdminproductEvent {
  final ProductModel product;
  DeleteAdminProduct({@required this.product});
  @override
  List<Object> get props => [product];
}
