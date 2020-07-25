import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:matrix/bloc/category_bloc/bloc.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/screens/category_details_screen.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/custom_route.dart';

class CategoryRound extends StatelessWidget {
  final String userId;
  CategoryRound({@required this.userId});
  buildItem(BuildContext context, CategoryModel cat) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = screenSize.width / 3;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(SlideLeftRoute(
          page: CategoryDetailsScreen(
            userId: userId,
            cat: cat,
          ),
        ));
      },
      child: Card(
        child: Container(
          width: itemWidth,
          height: 140.0,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                height: 105.0,
                width: 160.0,
                decoration: BoxDecoration(
                  image: cat.images.length > 0
                      ? DecorationImage(
                          image: NetworkImage(cat.images[0]), fit: BoxFit.cover)
                      : null,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                ),
              )),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 2),
                      Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        cat.description,
                        style: TextStyle(
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Tools.isTablet(MediaQuery.of(context));

    return BlocProvider(
      create: (context) => CategoryBloc()..add(LoadCategory()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (BuildContext context, CategoryState state) {
          if (state is CategoryLoading) {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
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
                    return Container(
                      padding: EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: isTablet ? 3 : 4,
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return buildItem(context, categories[index]);
                          },
                          staggeredTileBuilder: (index) =>
                              new StaggeredTile.fit(isTablet ? 1 : 2),
                        ),
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
}
