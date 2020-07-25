import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/category_bloc/bloc.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/screens/category_details_screen.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/base_widget.dart';
import 'package:matrix/widgets/custom_route.dart';

class CategorySquare extends StatelessWidget {
  final String userId;
  CategorySquare({@required this.userId});

  buildItem(BuildContext context, CategoryModel cat) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SlideLeftRoute(
          page: CategoryDetailsScreen(
            userId: userId,
            cat: cat,
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8),
        child: Container(
          height: 105.0,
          width: 160.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            image: cat.images.length > 0
                ? DecorationImage(
                    image: NetworkImage(cat.images[0]), fit: BoxFit.cover)
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
                child: AutoSizeText(
              cat.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              maxFontSize: 18,
              minFontSize: 12,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w900,
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget buildContent(double height) {
    return BlocProvider(
      create: (context) => CategoryBloc()..add(LoadCategory()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (BuildContext context, CategoryState state) {
         
          if (state is CategoryLoaded) {
            return StreamBuilder(
              stream: state.category,
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
                    final List<CategoryModel> categories = snapshot.data;
                    print(categories.length);
                    return Container(
                      padding: EdgeInsets.only(right: 8.0),
                      height: height,
                      child: ListView.builder(
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return buildItem(context, categories[index]);
                        },
                      ),
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

  @override
  Widget build(BuildContext context) {
    double heightQuery = MediaQuery.of(context).size.height;
    return BaseWidget(builder: (context, sizeInfo) {
      print(sizeInfo.screenSize);

      if (sizeInfo.orientation == Orientation.portrait) {
        if (sizeInfo.deviceScreenType == DeviceScreenType.Mobile) {
          return buildContent(heightQuery / 8);
        } else {
          return buildContent(heightQuery / 10);
        }
      } else {
        if (sizeInfo.deviceScreenType == DeviceScreenType.Mobile) {
          return buildContent(heightQuery / 5);
        } else {
          return buildContent(heightQuery / 7);
        }
      }
    });
  }
}
