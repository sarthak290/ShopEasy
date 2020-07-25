import 'package:flutter/material.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/base_widget.dart';

import 'carousel_slider.dart';

List child(imgList) => map<Widget>(
      imgList,
      (index, i) {
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Stack(children: <Widget>[
              Tools.image(
                url: i,
                fit: BoxFit.contain,
                width: double.maxFinite,
                // height: 300.0,
              ),
            ]),
          ),
        );
      },
    ).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class ProductImageSlider extends StatefulWidget {
  final List imgList;
  ProductImageSlider({@required this.imgList});

  @override
  _ProductImageSliderState createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _current = 0;

  buildIndicator(context, index, demoSlider) {
    return InkWell(
      onTap: () {
        print("tapped");
        setState(() {
          demoSlider.jumpToPage(index);
        });
      },
      child: Container(
        width: _current == index ? 28.0 : 6.0,
        height: 6.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: _current == index ? Colors.black : Colors.grey),
      ),
    );
  }

  Widget buildContent(double height) {
    final demoSlider = CarouselSlider(
      height: height,
      items: child(widget.imgList),
      autoPlay: false,
      autoPlayInterval: Duration(seconds: 5),
      enlargeCenterPage: false,
      aspectRatio: 1.2,
      viewportFraction: 1.0,
      autoPlayCurve: Curves.linear,
      pauseAutoPlayOnTouch: Duration(seconds: 1),
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
    );
    return Stack(children: [
      demoSlider,
      Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            widget.imgList,
            (index, url) {
              return InkWell(
                  onTap: () {
                    setState(() {
                      _current = index;
                    });
                  },
                  child: buildIndicator(context, index, demoSlider));
            },
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double heightQuery = MediaQuery.of(context).size.height;
    return BaseWidget(builder: (context, sizeInfo) {
      if (sizeInfo.orientation == Orientation.portrait) {
        if (sizeInfo.deviceScreenType == DeviceScreenType.Mobile) {
          return buildContent(heightQuery / 2);
        } else {
          return buildContent(heightQuery / 4);
        }
      } else {
        if (sizeInfo.deviceScreenType == DeviceScreenType.Mobile) {
          return buildContent(heightQuery / 2);
        } else {
          return buildContent(heightQuery / 2);
        }
      }
    });
  }
}
