import 'package:equatable/equatable.dart';
import 'package:matrix/models/favorites.dart';
import 'package:meta/meta.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class LoadFavorite extends FavoriteEvent {
  final String userId;

  LoadFavorite({@required this.userId}) : assert(userId != null);
  @override
  List<Object> get props => [];
}

class ToggleFavorite extends FavoriteEvent {
  final String userId;
  final FavoriteModel fav;

  ToggleFavorite({@required this.userId, @required this.fav});
  @override
  List<Object> get props => [];
}
