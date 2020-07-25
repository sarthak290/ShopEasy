import 'package:equatable/equatable.dart';
import 'package:matrix/models/slider.dart';
import 'package:meta/meta.dart';

abstract class AdminSlidersEvent extends Equatable {
  const AdminSlidersEvent();
}

class LoadAdminSliders extends AdminSlidersEvent {
  @override
  List<Object> get props => [];
}

class DeleteAdminSlider extends AdminSlidersEvent {
  final SliderModel slider;
  DeleteAdminSlider({@required this.slider});
  @override
  List<Object> get props => [];
}
