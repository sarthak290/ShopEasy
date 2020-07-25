import 'package:equatable/equatable.dart';
import 'package:matrix/models/category.dart';
import 'package:meta/meta.dart';

abstract class AdminCategoryState extends Equatable {
  const AdminCategoryState();
  @override
  List<Object> get props => [];
}

class AdminCategoryLoading extends AdminCategoryState {
  @override
  List<Object> get props => [];
}

class AdminCategoryLoaded extends AdminCategoryState {
  final Stream<List<CategoryModel>> category;
  AdminCategoryLoaded({@required this.category});

  @override
  List<Object> get props => [];
}

class AdminCategoryLoadingFailed extends AdminCategoryState {
  @override
  List<Object> get props => [];
}
