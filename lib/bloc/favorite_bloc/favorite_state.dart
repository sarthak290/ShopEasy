import 'package:equatable/equatable.dart';
import 'package:matrix/models/favorites.dart';
import 'package:meta/meta.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class FavoriteLoading extends FavoriteState {
  @override
  List<Object> get props => [];
}

class FavoriteLoaded extends FavoriteState {
  final Stream<List<FavoriteModel>> favorite;

  FavoriteLoaded({@required this.favorite});

  @override
  List<Object> get props => [favorite];
}

class FavoriteFailed extends FavoriteState {
  @override
  List<Object> get props => [];
}
