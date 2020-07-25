import 'package:equatable/equatable.dart';

abstract class SliderEvent extends Equatable {
  const SliderEvent();
}

class LoadSlider extends SliderEvent {
  @override
  List<Object> get props => [];
}
