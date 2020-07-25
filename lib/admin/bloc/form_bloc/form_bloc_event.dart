import 'package:equatable/equatable.dart';
import 'package:matrix/models/brand.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/models/user.dart';
import 'package:meta/meta.dart';

abstract class FormBlocEvent extends Equatable {
  const FormBlocEvent();
}

class AddAdminBrands extends FormBlocEvent {
  final BrandModel brand;
  AddAdminBrands({@required this.brand}) : assert(brand != null);

  @override
  List<Object> get props => [brand];
}

class EditAdminBrand extends FormBlocEvent {
  final BrandModel brand;
  final List<String> oldImages;
  EditAdminBrand({@required this.brand, @required this.oldImages})
      : assert(brand != null);

  @override
  List<Object> get props => [brand];
}

class AddAdminCategory extends FormBlocEvent {
  final CategoryModel category;
  AddAdminCategory({@required this.category}) : assert(category != null);

  @override
  List<Object> get props => [category];
}

class EditAdminCategory extends FormBlocEvent {
  final CategoryModel category;
  final List<String> oldImages;
  EditAdminCategory({@required this.category, @required this.oldImages})
      : assert(category != null);

  @override
  List<Object> get props => [category, oldImages];
}

class AddProducts extends FormBlocEvent {
  final ProductModel product;

  AddProducts({@required this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class EditAdminProduct extends FormBlocEvent {
  final ProductModel product;
  final List<String> oldImages;
  EditAdminProduct({@required this.product, @required this.oldImages})
      : assert(product != null);

  @override
  List<Object> get props => [product, oldImages];
}

class AddSlider extends FormBlocEvent {
  final SliderModel slider;

  AddSlider({@required this.slider}) : assert(slider != null);

  @override
  List<Object> get props => [slider];
}

class EditSlider extends FormBlocEvent {
  final SliderModel slider;
  final List<String> oldImages;
  EditSlider({@required this.slider, @required this.oldImages})
      : assert(slider != null);

  @override
  List<Object> get props => [slider, oldImages];
}

class EditUserimage extends FormBlocEvent {
  final UserModel user;
  EditUserimage({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class EditUserDetails extends FormBlocEvent {
  final UserModel user;
  EditUserDetails({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}
