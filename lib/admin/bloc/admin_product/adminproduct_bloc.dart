import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/services/product_repository.dart';
import './bloc.dart';

class AdminproductBloc extends Bloc<AdminproductEvent, AdminproductState> {
  @override
  AdminproductState get initialState => AdminProductLoading();

  @override
  Stream<AdminproductState> mapEventToState(
    AdminproductEvent event,
  ) async* {
    if (event is LoadProducts) {
      yield* _mapLoadProductsToState();
    } else if (event is DeleteAdminProduct) {
      yield* _mapDeleteAdminProductToState(event.product);
    }
  }

  Stream<AdminproductState> _mapLoadProductsToState() async* {
    yield AdminProductLoading();
    try {
      yield AdminProductLoading();
      final ProductRepository productRepository = ProductRepository();
      final Stream<List<ProductModel>> products =
          productRepository.streamProducts();
      yield AdminProductLoaded(products: products);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminProductLoadingFailed();
    }
  }

  Stream<AdminproductState> _mapDeleteAdminProductToState(
      ProductModel product) async* {
    yield AdminProductLoading();
    try {
      final ProductRepository productRepository = ProductRepository();

      yield AdminProductLoading();
      productRepository.deleteProduct(product.productId);
     
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminProductLoadingFailed();
    }
  }
}
