import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/brand.dart';
import 'package:matrix/services/brand_repository.dart';
import './bloc.dart';

class AdminbrandsBloc extends Bloc<AdminbrandsEvent, AdminbrandsState> {
  final BrandRepository brandRepository = BrandRepository();

  @override
  AdminbrandsState get initialState => AdminBrandsLoading();

  @override
  Stream<AdminbrandsState> mapEventToState(
    AdminbrandsEvent event,
  ) async* {
    if (event is LoadAdminBrands) {
      yield* _mapLoadAdminBrandsToState();
    } else if (event is DeleteAdminBrand) {
      yield* _mapDeleteAdminBrandToState(event.brand);
    }
  }

  Stream<AdminbrandsState> _mapDeleteAdminBrandToState(
      BrandModel brand) async* {
    yield AdminBrandsLoading();
    try {
      yield AdminBrandsLoading();
      brandRepository.deleteBrand(brand.brandId);
      // yield AdminBrandsLoaded(brands: brands);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminBrandsLoadingFailed();
    }
  }

  Stream<AdminbrandsState> _mapLoadAdminBrandsToState() async* {
    yield AdminBrandsLoading();
    try {
      yield AdminBrandsLoading();
      final Stream<List<BrandModel>> brands = brandRepository.streamBrands();
      yield AdminBrandsLoaded(brands: brands);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield AdminBrandsLoadingFailed();
    }
  }
}
