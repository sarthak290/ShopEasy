import 'package:flutter/material.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/products/details_bottom.dart';
import 'package:matrix/widgets/slider/product_image_slider.dart';
import 'package:matrix/widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;
  final String userId;

  ProductDetails({Key key, @required this.product, @required this.userId})
      : super(key: key);

  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int currentSizeIndex = 0;
  int currentColorIndex = 0;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> colorSelector() {
    List<Widget> colorItemList = new List();

    for (var i = 0; i < widget.product.colors.length; i++) {
      colorItemList.add(colorItem(
          widget.product.colors[i], i == currentColorIndex, context, () {
        setState(() {
          currentColorIndex = i;
        });
      }));
    }

    return colorItemList;
  }

  Widget colorItem(
      color, bool isSelected, BuildContext context, VoidCallback _ontab) {
    return GestureDetector(
      onTap: _ontab,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: Colors.black.withOpacity(.8),
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0))
                    ]
                  : []),
          child: ClipPath(
            clipper: MClipper(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: HexColor(color["code"]),
            ),
          ),
        ),
      ),
    );
  }

  Widget sizeItem(Map size, bool isSelected, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 30.0,
          minWidth: 30.0,
        ),
        child: Container(
          // width: 30.0,
          // height: 30.0,
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              color: isSelected ? Color(0xFFFC3930) : Color(0xFF525663),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: isSelected
                        ? Colors.black.withOpacity(.5)
                        : Colors.black12,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ]),
          child: Center(
            child: Text(size["name"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductModel product = widget.product;
    return Container(
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: DetailsBottom(
          userId: widget.userId,
          product: product,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ProductImageSlider(
                    imgList: product.images,
                  ),
                  Positioned(
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      brightness: Brightness.light,
                      elevation: 0.0,
                      leading: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 8.0,
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height: 24.0,
                              width: 24.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: Container(
                  width: double.maxFinite,
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.brand != null
                              ? product.brand["name"]
                              : "Default",
                          style: TextStyle(
                             
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            Tools.getCurrecyFormatted(product.price),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CustomTextWidget(
                            textKey: "taxMessage",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Card(
                child: Container(
                  width: double.maxFinite,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 26.0, bottom: 4.0, left: 16, right: 16),
                        child: AnimatedCrossFade(
                          firstChild: Text(
                            product.description != null
                                ? product.description
                                : "",
                            maxLines: 2,
                            style: TextStyle(
                               
                                fontSize: 14.0,
                                fontFamily: "Montserrat-Medium"),
                          ),
                          secondChild: Text(
                            product.description != null
                                ? product.description
                                : "",
                            style: TextStyle(
                                // color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: "Montserrat-Medium"),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: kThemeAnimationDuration,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 26.0,
                          right: 18.0,
                        ),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: CustomTextWidget(
                              textKey: isExpanded ? "less" : "more",
                              style: TextStyle(
                                  color: Color(0xFFFB382F),
                                  fontWeight: FontWeight.w700),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Card(
                child: Container(
                  width: double.maxFinite,
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomTextWidget(
                            textKey: "sizeAndColors",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            children: colorSelector(),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 38.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: product.sizes.map((item) {
                                var index = product.sizes.indexOf(item);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentSizeIndex = index;
                                    });
                                  },
                                  child: sizeItem(
                                      item, index == currentSizeIndex, context),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Card(
                child: Container(
                  width: double.maxFinite,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 16, bottom: 16),
                        child: CustomTextWidget(
                          textKey: "deliveryOptions",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ImageIcon(
                                    AssetImage(
                                      "assets/icons/cart_return.png",
                                    ),
                                  ),
                                ),
                                CustomTextWidget(
                                  textKey: "return",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .color,
                                    fontSize: 14.0,
                                  ),
                                ),
                                CustomTextWidget(
                                  textKey: "available",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Container(
                            height: 80,
                            width: 1.5,
                            color: Colors.grey[300],
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ImageIcon(
                                    AssetImage(
                                      "assets/icons/exchange.png",
                                    ),
                                  ),
                                ),
                                CustomTextWidget(
                                  textKey: "exchange",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .color,
                                    fontSize: 14.0,
                                  ),
                                ),
                                CustomTextWidget(
                                  textKey: "available",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Card(
                elevation: 2.0,
                child: Container(
                  width: double.maxFinite,
                  color: Theme.of(context).cardColor,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: CustomTextWidget(
                            textKey: "explore",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ListTile(
                          leading: CustomTextWidget(
                            textKey: "moreFrom",
                            addText: product.brand != null
                                ? product.brand["name"]
                                : "Default",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        Divider(
                          height: 0,
                        ),
                        ListTile(
                          leading: CustomTextWidget(
                            textKey: "moreFrom",
                            addText: product.categories != null &&
                                    product.categories.length > 0
                                ? product.categories[0]["name"]
                                : "Other",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(size.width, size.height * 0.2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
