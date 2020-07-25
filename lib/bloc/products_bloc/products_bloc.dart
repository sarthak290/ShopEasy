import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/services/product_repository.dart';
import './bloc.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  @override
  ProductsState get initialState => ProductsLoading();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is LoadProducts) {
      yield* _mapLoadProductsToState();
    }
  }

  Stream<ProductsState> _mapLoadProductsToState() async* {
    yield ProductsLoading();
    try {
      yield ProductsLoading();
      final ProductRepository productRepository = ProductRepository();
      final Stream<List<ProductModel>> products =
          productRepository.streamProducts();
      yield ProductsLoaded(products: products);
    } catch (e) {
      print("Error adding product, ${e.message}");
      yield ProductsLoadingFailed();
    }
  }
}
