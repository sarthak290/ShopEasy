import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/brand.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/services/brand_repository.dart';
import 'package:matrix/services/category_repository.dart';
import 'package:matrix/services/product_repository.dart';
import 'package:matrix/services/slider_repository.dart';
import 'package:matrix/services/user_repository.dart';
import './bloc.dart';

class FormBlocBloc extends Bloc<FormBlocEvent, FormBlocState> {
  @override
  FormBlocState get initialState => FormBlocState.empty();

  @override
  Stream<FormBlocState> mapEventToState(
    FormBlocEvent event,
  ) async* {
    if (event is AddAdminBrands) {
      yield* _mapAddAdminBrandsToState(event.brand);
    } else if (event is EditAdminBrand) {
      yield* _mapAEditAdminBrandToState(event.brand, event.oldImages);
    } else if (event is AddAdminCategory) {
      yield* _mapAddAdminCategoryToState(event.category);
    } else if (event is EditAdminCategory) {
      yield* _mapEditAdminCategoryToState(event.category, event.oldImages);
    } else if (event is AddProducts) {
      yield* _mapAddProductsToState(event.product);
    } else if (event is EditAdminProduct) {
      yield* _mapEditAdminProductToState(event.product, event.oldImages);
    } else if (event is AddSlider) {
      yield* _mapAddSliderToState(event.slider);
    } else if (event is EditSlider) {
      yield* _mapEditSliderToState(event.slider, event.oldImages);
    } else if (event is EditUserimage) {
      yield* _mapEditUserImageToState(event.user);
    } else if (event is EditUserDetails) {
      yield* _mapEditUserDetailsToState(event.user);
    }
  }

  Stream<FormBlocState> _mapAddAdminBrandsToState(BrandModel brand) async* {
    yield FormBlocState.loading();
    try {
      final BrandRepository brandRepository = BrandRepository();
      yield FormBlocState.loading();
      await brandRepository.addBrand(brand);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }

  Stream<FormBlocState> _mapAEditAdminBrandToState(
      BrandModel brand, oldImages) async* {
    yield FormBlocState.loading();
    try {
      final BrandRepository brandRepository = BrandRepository();
      yield FormBlocState.loading();
      await brandRepository.editBrand(brand, oldImages);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }


  Stream<FormBlocState> _mapAddAdminCategoryToState(
      CategoryModel category) async* {
    yield FormBlocState.loading();
    try {
      final CategoryRepository categoryRepository = CategoryRepository();

      yield FormBlocState.loading();
      await categoryRepository.addCategory(category);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding category, ${e.message}");
      yield FormBlocState.failure("Error ading category");
    }
  }

  Stream<FormBlocState> _mapEditAdminCategoryToState(
      CategoryModel category, oldImages) async* {
    yield FormBlocState.loading();
    try {
      final CategoryRepository categoryRepository = CategoryRepository();

      yield FormBlocState.loading();
      await categoryRepository.editCategory(category, oldImages);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }

  
  Stream<FormBlocState> _mapAddProductsToState(ProductModel product) async* {
    yield FormBlocState.loading();
    try {
      final ProductRepository productRepository = ProductRepository();

      yield FormBlocState.loading();
      await productRepository.addProduct(product);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding product, ${e.message}");
      yield FormBlocState.failure("Error ading product");
    }
  }

  Stream<FormBlocState> _mapEditAdminProductToState(
      ProductModel product, oldImages) async* {
    yield FormBlocState.loading();
    try {
      final ProductRepository productRepository = ProductRepository();

      yield FormBlocState.loading();
      await productRepository.editProduct(product, oldImages);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }

 

  Stream<FormBlocState> _mapAddSliderToState(SliderModel slider) async* {
    yield FormBlocState.loading();
    try {
      final SliderRepository sliderRepository = SliderRepository();

      yield FormBlocState.loading();
      await sliderRepository.addSlider(slider);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding slider, ${e.message}");
      yield FormBlocState.failure("Error ading slider");
    }
  }

  Stream<FormBlocState> _mapEditSliderToState(
      SliderModel slider, oldImages) async* {
    yield FormBlocState.loading();
    try {
      final SliderRepository sliderRepository = SliderRepository();

      yield FormBlocState.loading();
      await sliderRepository.editSlider(slider, oldImages);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }

 

  Stream<FormBlocState> _mapEditUserImageToState(UserModel user) async* {
    yield FormBlocState.loading();
    try {
      final UserRepository userRepository = UserRepository();

      yield FormBlocState.loading();
      await userRepository.updateImage(user);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }

  

  Stream<FormBlocState> _mapEditUserDetailsToState(UserModel user) async* {
    yield FormBlocState.loading();
    try {
      final UserRepository userRepository = UserRepository();

      yield FormBlocState.loading();
      await userRepository.updateUseDetails(user);
      yield FormBlocState.success();
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FormBlocState.failure("Error ading brand");
    }
  }
}
