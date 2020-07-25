import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/services/category_repository.dart';
import './bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository = CategoryRepository();
  @override
  CategoryState get initialState => CategoryLoading();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is LoadCategory) {
      yield* _mapLoadCategoryToState();
    }
  }

  Stream<CategoryState> _mapLoadCategoryToState() async* {
    yield CategoryLoading();
    try {
      yield CategoryLoading();
      final Stream<List<CategoryModel>> category =
          categoryRepository.streamCategorys();
      yield CategoryLoaded(category: category);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield CategoryFailed();
    }
  }
}
