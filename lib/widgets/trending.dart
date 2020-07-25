import 'package:flutter/material.dart';
import 'package:matrix/models/favorites.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/products/product_horizontal.dart';
import 'package:matrix/widgets/text_widget.dart';

class Trending extends StatefulWidget {
  final List<ProductModel> trending;
  final List<FavoriteModel> favs;
  final String userId;

  const Trending(
      {Key key,
      @required this.trending,
      @required this.favs,
      @required this.userId})
      : super(key: key);
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  var opacity1 = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();

    super.initState();
  }

  void setData() async {
    animationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
            child: CustomTextWidget(
              textKey: "trending",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18.0,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: opacity1,
            duration: Duration(milliseconds: 500),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                itemCount: widget.trending.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ProductCardHorizontal(
                    product: widget.trending[index],
                    favs: widget.favs,
                    userId: widget.userId,
                    search: false,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
