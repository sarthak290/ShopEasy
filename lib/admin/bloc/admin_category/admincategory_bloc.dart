import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/services/category_repository.dart';
import './bloc.dart';

class AdminCategoryBloc extends Bloc<AdminCategoryEvent, AdminCategoryState> {
  final CategoryRepository categoryRepository = CategoryRepository();

  @override
  AdminCategoryState get initialState => AdminCategoryLoading();

  @override
  Stream<AdminCategoryState> mapEventToState(
    AdminCategoryEvent event,
  ) async* {
    if (event is LoadAdminCategory) {
      yield* _mapLoadAdminCategoryToState();
    } else if (event is DeleteAdminCategory) {
      yield* _mapDeleteAdminCategoryToState(event.category);
    }
  }

  Stream<AdminCategoryState> _mapDeleteAdminCategoryToState(
      CategoryModel category) async* {
    yield AdminCategoryLoading();
    try {
      yield AdminCategoryLoading();
      categoryRepository.deleteCategory(category.categoryId);
      
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminCategoryLoadingFailed();
    }
  }

  Stream<AdminCategoryState> _mapLoadAdminCategoryToState() async* {
    yield AdminCategoryLoading();
    try {
      yield AdminCategoryLoading();
      final Stream<List<CategoryModel>> brands =
          categoryRepository.streamCategorys();
      yield AdminCategoryLoaded(category: brands);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminCategoryLoadingFailed();
    }
  }
}
