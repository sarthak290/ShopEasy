import 'package:equatable/equatable.dart';
import 'package:matrix/models/product.dart';

abstract class AdminproductState extends Equatable {
  const AdminproductState();
}

class AdminProductLoading extends AdminproductState {
  @override
  List<Object> get props => [];
}

class AdminProductLoaded extends AdminproductState {
  final Stream<List<ProductModel>> products;

  AdminProductLoaded({this.products});
  @override
  List<Object> get props => [products];
}

class AdminProductLoadingFailed extends AdminproductState {
  @override
  List<Object> get props => [];
}
