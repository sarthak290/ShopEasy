import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/favorite_bloc/bloc.dart';
import 'package:matrix/bloc/products_bloc/bloc.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/latest.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String userId;
  final CategoryModel cat;
  const CategoryDetailsScreen(
      {Key key, @required this.userId, @required this.cat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          cat.name != null ? cat.name : "Category",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
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
                                builder: (BuildContext context,
                                    ProductsState state) {
                                 
                                  if (state is ProductsLoaded) {
                                    return StreamBuilder(
                                      stream: state.products,
                                      initialData: [],
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {
                                          return Container(
                                            child: Center(
                                              child:
                                                  Text("Something went wrong"),
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

                                            List<ProductModel> filtered =
                                                products
                                                    .where((p) =>
                                                        p.categories.length >
                                                            0 &&
                                                        p.categories[0][
                                                                "categoryId"] ==
                                                            cat.categoryId)
                                                    .toList();
                                            if (filtered.length == 0) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Container(
                                                  child: Text(
                                                    "No Product Found in this category",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Column(
                                              children: <Widget>[
                                                Latest(
                                                  products: filtered,
                                                  userId: userId,
                                                  favs: favs,
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
      ),
    );
  }
}
