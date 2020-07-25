import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/services/favorite_repository.dart';
import './bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  @override
  FavoriteState get initialState => FavoriteLoading();

  @override
  Stream<FavoriteState> mapEventToState(
    FavoriteEvent event,
  ) async* {
    if (event is LoadFavorite) {
      yield* _mapLoadFavoriteToState(event.userId);
    } else if (event is ToggleFavorite) {
      yield* _mapToggleFavoriteToState(event.fav, event.userId);
    }
  }

  Stream<FavoriteState> _mapLoadFavoriteToState(String userId) async* {
    yield FavoriteLoading();
    try {
      yield FavoriteLoading();
      final FavoriteRepository favoriteRepository = FavoriteRepository();
      final Stream<List<FavoriteModel>> favorite =
          favoriteRepository.streamFavorites(userId);
      yield FavoriteLoaded(favorite: favorite);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FavoriteFailed();
    }
  }

  Stream<FavoriteState> _mapToggleFavoriteToState(
      FavoriteModel fav, String userId) async* {
    try {
      final FavoriteRepository favoriteRepository = FavoriteRepository();
      favoriteRepository.toggleFavorite(fav, userId);
    } catch (e) {
      print("Error adding brand, ${e.message}");
      yield FavoriteFailed();
    }
  }
}
