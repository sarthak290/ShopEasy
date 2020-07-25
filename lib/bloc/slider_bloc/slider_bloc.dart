import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/services/slider_repository.dart';
import './bloc.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final SliderRepository sliderRepository = SliderRepository();
  @override
  SliderState get initialState => SliderLoading();

  @override
  Stream<SliderState> mapEventToState(
    SliderEvent event,
  ) async* {
    if (event is LoadSlider) {
      yield* _mapLoadSliderToState();
    }
  }

  Stream<SliderState> _mapLoadSliderToState() async* {
    yield SliderLoading();
    try {
      yield SliderLoading();
      final Stream<List<SliderModel>> sliders =
          sliderRepository.streamSliders();
      yield SliderLoaded(sliders: sliders);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield SliderLoadingFailed();
    }
  }
}
