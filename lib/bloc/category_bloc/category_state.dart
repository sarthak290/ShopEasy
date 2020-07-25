import 'package:equatable/equatable.dart';
import 'package:matrix/models/category.dart';
import 'package:meta/meta.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryLoading extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  final Stream<List<CategoryModel>> category;

  CategoryLoaded({@required this.category});

  @override
  List<Object> get props => [category];
}

class CategoryFailed extends CategoryState {
  @override
  List<Object> get props => [];
}
