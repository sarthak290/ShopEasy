import 'package:flutter/material.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/base_widget.dart';

import 'carousel_slider.dart';

final List<String> imgList = [
  "https://i.imgur.com/AkwuoMJ.jpg",
  "https://i.imgur.com/kYG3mcU.jpg",
  "https://i.imgur.com/Qzil7uP.jpg",
  "https://i.imgur.com/8XNKsk4.jpg",
  "https://i.imgur.com/qKIMLfz.jpg"
];

final List child = map<Widget>(
  imgList,
  (index, i) {
    return Container(
      margin: EdgeInsets.only(top: 12.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        child: Stack(children: <Widget>[
          Tools.image(
            url: i,
            fit: BoxFit.fill,
            width: double.maxFinite,
            height: 300.0,
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

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  Widget buildContent(double height) {
    return CarouselSlider(
      height: height,
      items: child,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 5),
      enlargeCenterPage: true,
      aspectRatio: 2.0,
      autoPlayCurve: Curves.linear,
      viewportFraction: 0.8,
      pauseAutoPlayOnTouch: Duration(seconds: 1),
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightQuery = MediaQuery.of(context).size.height;
    return BaseWidget(builder: (context, sizeInfo) {
      if (sizeInfo.orientation == Orientation.portrait) {
        if (sizeInfo.deviceScreenType == DeviceScreenType.Mobile) {
          return buildContent(heightQuery / 4);
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
