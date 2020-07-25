import 'package:equatable/equatable.dart';
import 'package:matrix/models/slider.dart';
import 'package:meta/meta.dart';

abstract class AdminSlidersState extends Equatable {
  const AdminSlidersState();
  @override
  List<Object> get props => [];
}

class AdminSlidersLoading extends AdminSlidersState {
  @override
  List<Object> get props => [];
}

class AdminSlidersLoaded extends AdminSlidersState {
  final Stream<List<SliderModel>> sliders;
  AdminSlidersLoaded({@required this.sliders});

  @override
  List<Object> get props => [];
}

class AdminSlidersLoadingFailed extends AdminSlidersState {
  @override
  List<Object> get props => [];
}
