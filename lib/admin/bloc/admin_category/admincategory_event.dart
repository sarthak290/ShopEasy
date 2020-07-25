import 'package:equatable/equatable.dart';
import 'package:matrix/models/category.dart';
import 'package:meta/meta.dart';

abstract class AdminCategoryEvent extends Equatable {
  const AdminCategoryEvent();
}

class LoadAdminCategory extends AdminCategoryEvent {
  @override
  List<Object> get props => [];
}

class DeleteAdminCategory extends AdminCategoryEvent {
  final CategoryModel category;
  DeleteAdminCategory({@required this.category});
  @override
  List<Object> get props => [];
}
