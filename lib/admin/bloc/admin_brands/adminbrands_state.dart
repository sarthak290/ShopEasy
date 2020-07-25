import 'package:equatable/equatable.dart';
import 'package:matrix/models/brand.dart';
import 'package:meta/meta.dart';

abstract class AdminbrandsState extends Equatable {
  const AdminbrandsState();
  @override
  List<Object> get props => [];
}

class AdminBrandsLoading extends AdminbrandsState {
  @override
  List<Object> get props => [];
}

class AdminBrandsLoaded extends AdminbrandsState {
  final Stream<List<BrandModel>> brands;
  AdminBrandsLoaded({@required this.brands});

  @override
  List<Object> get props => [];
}

class AdminBrandsLoadingFailed extends AdminbrandsState {
  @override
  List<Object> get props => [];
}
