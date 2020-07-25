import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/favorite_bloc/bloc.dart';
import 'package:matrix/bloc/products_bloc/bloc.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/categories/categorgy_square.dart';
import 'package:matrix/widgets/latest.dart';
import 'package:matrix/widgets/slider/offers_slider.dart';
import 'package:matrix/widgets/trending.dart';

class HomeScreen extends StatelessWidget {
  final String userId;
  const HomeScreen({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          CategorySquare(
            userId: userId,
          ),
          OfferSlider(),
          BlocProvider(
            create: (context) =>
                FavoriteBloc()..add(LoadFavorite(userId: userId)),
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (BuildContext context, FavoriteState state) {
                if (state is FavoriteLoaded) {
                  return StreamBuilder(
                    stream: state.favorite,
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          child: Center(
                            child: Text("Something went wrong"),
                          ),
                        );
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          break;
                        default:
                          final List<FavoriteModel> favs = snapshot.data;
                          return BlocProvider(
                            create: (context) =>
                                ProductsBloc()..add(LoadProducts()),
                            child: BlocBuilder<ProductsBloc, ProductsState>(
                              builder:
                                  (BuildContext context, ProductsState state) {
                                if (state is ProductsLoaded) {
                                  return StreamBuilder(
                                    stream: state.products,
                                    initialData: [],
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasError) {
                                        return Container(
                                          child: Center(
                                            child: Text("Something went wrong"),
                                          ),
                                        );
                                      }
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Container(
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                          break;
                                        default:
                                          final List<ProductModel> products =
                                              snapshot.data;

                                          final List<ProductModel> trending =
                                              products
                                                  .where(
                                                      (ProductModel product) =>
                                                          product.featured)
                                                  .toList();
                                          return Column(
                                            children: <Widget>[
                                              Trending(
                                                trending: trending,
                                                favs: favs,
                                                userId: userId,
                                              ),
                                              Latest(
                                                products: products,
                                                userId: userId,
                                                favs: favs,
                                                from: "home",
                                              ),
                                            ],
                                          );
                                      }
                                    },
                                  );
                                }
                                return Container();
                              },
                            ),
                          );
                      }
                    },
                  );
                }
                if (state is FavoriteFailed) {
                  return Container();
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
