import 'package:equatable/equatable.dart';
import 'package:matrix/models/brand.dart';
import 'package:meta/meta.dart';

abstract class AdminbrandsEvent extends Equatable {
  const AdminbrandsEvent();
}

class LoadAdminBrands extends AdminbrandsEvent {
  @override
  List<Object> get props => [];
}

class DeleteAdminBrand extends AdminbrandsEvent {
  final BrandModel brand;
  DeleteAdminBrand({@required this.brand});
  @override
  List<Object> get props => [];
}
