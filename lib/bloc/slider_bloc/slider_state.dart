import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:matrix/models/slider.dart';

abstract class SliderState extends Equatable {
  const SliderState();
}

class SliderLoading extends SliderState {
  @override
  List<Object> get props => [];
}

class SliderLoaded extends SliderState {
  final Stream<List<SliderModel>> sliders;

  SliderLoaded({@required this.sliders});

  @override
  List<Object> get props => [sliders];
}

class SliderLoadingFailed extends SliderState {
  @override
  List<Object> get props => [];
}
