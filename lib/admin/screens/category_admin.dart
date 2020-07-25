import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/admin_category/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/category_form.dart';
import 'package:matrix/admin/widgets/category_list.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/widgets/custom_route.dart';

class CategoryAdmin extends StatelessWidget {
  const CategoryAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Category",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, letterSpacing: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 54.0),
              child: Material(
                elevation: 8.0,
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(0.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(SlideTopRoute(
                        page: BlocProvider(
                      create: (context) => FormBlocBloc(),
                      child: CategoryForm(
                        category: null,
                      ),
                    )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white),
                        Padding(padding: EdgeInsets.only(right: 16.0)),
                        Text('ADD CATEGORY',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BlocProvider(
              create: (context) =>
                  AdminCategoryBloc()..add(LoadAdminCategory()),
              child: BlocBuilder<AdminCategoryBloc, AdminCategoryState>(
                builder: (BuildContext context, AdminCategoryState state) {
                  if (state is AdminCategoryLoading) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is AdminCategoryLoaded) {
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
                            final List<CategoryModel> category = snapshot.data;
                            return Container(
                              child: CategoryList(
                                category: category,
                              ),
                            );
                        }
                      },
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
