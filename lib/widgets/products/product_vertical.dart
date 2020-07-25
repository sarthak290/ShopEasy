import 'package:flutter/material.dart';
import 'package:matrix/bloc/favorite_bloc/bloc.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/products/add_cart.dart';
import 'package:matrix/widgets/products/product_details.dart';
import 'package:matrix/utils/config.dart';

class ProductCardVertical extends StatelessWidget {
  final ProductModel product;
  final List<FavoriteModel> favs;
  final String userId;

  ProductCardVertical(
      {@required this.product, @required this.favs, @required this.userId});

  @override
  Widget build(BuildContext context) {
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    var height = MediaQuery.of(context).size.height;
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
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Theme.of(context).cardColor,
      child: InkWell(
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
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: isTablet ? height / 4 : height / 4.3,
              ),
              child: Image.network(product.images[0],
                  height: isTablet ? height / 4 : height / 4.3,
                  fit: BoxFit.contain),
            ),
            SizedBox(height: 7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.brand != null ? product.brand["name"] : "Default",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
                InkWell(
                  onTap: () {
                    FavoriteBloc()
                      ..add(ToggleFavorite(fav: fav, userId: userId));
                  },
                  child: !isFavorite
                      ? Icon(Icons.favorite_border, size: 16)
                      : Icon(Icons.favorite,
                          size: 16,
                          color:
                              HexColor(Settings["Setting"]["TeritiaryColor"])),
                )
              ],
            ),
            SizedBox(height: 4),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                product.name,
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.subtitle.color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${Tools.getCurrecyFormatted(product.price)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.73,
                      decoration: product.offerPrice < product.price
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                product.offerPrice < product.price
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${Tools.getCurrecyFormatted(product.offerPrice)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 0.73,
                            
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            AddToCart(
              product: product,
            )
          ],
        ),
      ),
    );
  }
}
