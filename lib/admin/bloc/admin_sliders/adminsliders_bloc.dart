import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/services/slider_repository.dart';
import './bloc.dart';

class AdminSlidersBloc extends Bloc<AdminSlidersEvent, AdminSlidersState> {
  final SliderRepository sliderRepository = SliderRepository();

  @override
  AdminSlidersState get initialState => AdminSlidersLoading();

  @override
  Stream<AdminSlidersState> mapEventToState(
    AdminSlidersEvent event,
  ) async* {
    if (event is LoadAdminSliders) {
      yield* _mapLoadAdminSlidersToState();
    } else if (event is DeleteAdminSlider) {
      yield* _mapDeleteAdminSliderToState(event.slider);
    }
  }

  Stream<AdminSlidersState> _mapDeleteAdminSliderToState(
      SliderModel slider) async* {
    yield AdminSlidersLoading();
    try {
      yield AdminSlidersLoading();
      sliderRepository.deleteSlider(slider.sliderId);
      
    } catch (e) {
      print("Error adding Slider, ${e.message}");
      yield AdminSlidersLoadingFailed();
    }
  }

  Stream<AdminSlidersState> _mapLoadAdminSlidersToState() async* {
    yield AdminSlidersLoading();
    try {
      yield AdminSlidersLoading();
      final Stream<List<SliderModel>> sliders =
          sliderRepository.streamSliders();
      yield AdminSlidersLoaded(sliders: sliders);
    } catch (e) {
      print("Error adding Slider, ${e.message}");
      yield AdminSlidersLoadingFailed();
    }
  }
}
