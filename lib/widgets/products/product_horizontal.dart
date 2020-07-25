import 'package:flutter/material.dart';
import 'package:matrix/bloc/favorite_bloc/bloc.dart';
import 'package:matrix/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/products/add_cart.dart';
import 'package:matrix/widgets/products/product_details.dart';
import 'package:matrix/utils/config.dart';

class ProductCardHorizontal extends StatelessWidget {
  final ProductModel product;
  final List<FavoriteModel> favs;
  final String userId;
  final bool search;

  const ProductCardHorizontal(
      {@required this.product,
      @required this.favs,
      @required this.userId,
      @required this.search});

  @override
  Widget build(BuildContext context) {
    FavoriteModel fav = favs
                .where((fav) => fav.productId == product.productId)
                .toList()
                .length >
            0
        ? favs.where((fav) => fav.productId == product.productId).toList()[0]
        : FavoriteModel(
            favId: "abc",
            userId: userId,
            productId: product.productId,
            favorite: true);
    bool isFavorite = favs
                .where((fav) => fav.productId == product.productId)
                .toList()
                .length >
            0
        ? true
        : false;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(
                product: product,
                userId: userId,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0, right: 15.0, top: 15.0),
        child: Card(
          elevation: 2.0,
          child: Container(
            width: 350,
            color: Theme.of(context).cardColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 130,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.images[0]),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 10.0,
                  height: 4.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: 160,
                            child: Text(
                              product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        search
                            ? SizedBox()
                            : InkWell(
                                onTap: () {
                                  FavoriteBloc()
                                    ..add(ToggleFavorite(
                                        fav: fav, userId: userId));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    elevation: isFavorite ? 8.0 : 0.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      height: 35.0,
                                      width: 35.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: !isFavorite
                                              ? Colors.grey.withOpacity(0.2)
                                              : Colors.white),
                                      child: Center(
                                        child: !isFavorite
                                            ? Icon(
                                                Icons.favorite_border,
                                                size: 18,
                                              )
                                            : Icon(Icons.favorite,
                                                size: 18,
                                                color: HexColor(
                                                    Settings["Setting"]
                                                        ["TeritiaryColor"])),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        product.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).textTheme.button.color),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          Tools.getCurrecyFormatted(product.price),
                          style: TextStyle(
                              color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 160,
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: <Widget>[
                          Container(
                            color: HexColor(Settings["Setting"]["MainColor"]),
                            child: Center(
                                child: AddToCart(
                              product: product,
                            )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
