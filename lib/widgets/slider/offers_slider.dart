import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/slider_bloc/bloc.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/base_widget.dart';

import 'carousel_slider.dart';

List child(imgList) => map<Widget>(
      imgList,
      (index, i) {
        return Container(
          margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Stack(children: <Widget>[
              Image.network(
                i,
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

class OfferSlider extends StatefulWidget {
  @override
  _OfferSliderState createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider> {
  int _current = 0;

  Widget buildContent(double height) {
    return BlocProvider(
      create: (context) => SliderBloc()..add(LoadSlider()),
      child: BlocBuilder<SliderBloc, SliderState>(
        builder: (BuildContext context, SliderState state) {
        
          if (state is SliderLoaded) {
            return StreamBuilder(
              stream: state.sliders,
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
                    final List<SliderModel> sliders = snapshot.data;
                    if (sliders.length == 0) {
                      return Container();
                    }
                    return CarouselSlider(
                      height: height,
                      items: child(
                          sliders.map((slider) => slider.images[0]).toList()),
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: false,
                      aspectRatio: 1.0,
                      autoPlayCurve: Curves.linear,
                      viewportFraction: 1.0,
                      pauseAutoPlayOnTouch: Duration(seconds: 1),
                      onPageChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                    );
                }
              },
            );
          }
          return Container();
        },
      ),
    );

    /**
     * 
     CarouselSlider(
      height: height,
      items: child(widget.imgList),
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 5),
      enlargeCenterPage: false,
      aspectRatio: 1.0,
      autoPlayCurve: Curves.linear,
      viewportFraction: 1.0,
      pauseAutoPlayOnTouch: Duration(seconds: 1),
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
    );
     */
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
