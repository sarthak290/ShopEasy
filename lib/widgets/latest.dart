import 'package:flutter/material.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/products/product_vertical.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:matrix/widgets/text_widget.dart';

class Latest extends StatelessWidget {
  final List<ProductModel> products;
  final List<FavoriteModel> favs;
  final String userId;
  final String from;
  const Latest(
      {Key key,
      @required this.products,
      @required this.favs,
      this.from = "cat",
      @required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = Tools.isTablet(MediaQuery.of(context));

    return Container(
      padding: const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          from == "cat"
              ? SizedBox(
                  height: 8,
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 20.0, right: 8),
                  child: CustomTextWidget(
                    textKey: "latest",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0,
                    ),
                  ),
                ),
          Container(
            padding: const EdgeInsets.only(left: 8.0, top: 16),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: isTablet ? 3 : 4,
              mainAxisSpacing: 8.0,
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8.0,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCardVertical(
                  product: products[index],
                  favs: favs,
                  userId: userId,
                );
              },
              staggeredTileBuilder: (index) =>
                  new StaggeredTile.fit(isTablet ? 1 : 2),
            ),
          ),
        ],
      ),
    );
  }
}
