import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/cart_bloc/bloc.dart';
import 'package:matrix/bloc/favorite_bloc/bloc.dart';
import 'package:matrix/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/products/add_cart.dart';
import 'package:matrix/widgets/text_widget.dart';

class DetailsBottom extends StatelessWidget {
  final String userId;
  final ProductModel product;
  const DetailsBottom({Key key, @required this.userId, @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc()..add(LoadFavorite(userId: userId)),
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (BuildContext context, FavoriteState state) {
          if (state is FavoriteLoading) {
            return Container(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FavoriteLoaded) {
            return StreamBuilder(
              stream: state.favorite,
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: CustomTextWidget(
                        textKey: "error",
                      ),
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
                    FavoriteModel fav = favs
                                .where(
                                    (fav) => fav.productId == product.productId)
                                .toList()
                                .length >
                            0
                        ? favs
                            .where((fav) => fav.productId == product.productId)
                            .toList()[0]
                        : FavoriteModel(
                            favId: "abc",
                            userId: userId,
                            productId: product.productId,
                            favorite: true);
                    bool isFavorite = favs
                                .where(
                                    (fav) => fav.productId == product.productId)
                                .toList()
                                .length >
                            0
                        ? true
                        : false;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 54,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0.0),
                                    ),
                                  ),
                                  color: Colors.lightGreen,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  onPressed: () {
                                    FavoriteBloc()
                                      ..add(ToggleFavorite(
                                          fav: fav, userId: userId));
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomTextWidget(
                                        textKey: isFavorite
                                            ? "removeWishlist"
                                            : "addToWishlist",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        )),
                                  ),
                                ),
                              ),
                              Container(
                                height: 54,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: AddToCart(
                                  product: product,
                                ),
                              )
                            ],
                          ),
                        ),
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
    );
  }
}
