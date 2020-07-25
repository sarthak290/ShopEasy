import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/products_bloc/bloc.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/search.dart';

class SearchScreen extends StatelessWidget {
  final String userId;
  SearchScreen({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("USER ID $userId");
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          BlocProvider(
            create: (context) => ProductsBloc()..add(LoadProducts()),
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (BuildContext context, ProductsState state) {
                if (state is ProductsLoading) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductsLoaded) {
                  return StreamBuilder(
                    stream: state.products,
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
                          final List<ProductModel> products = snapshot.data;

                          return SearchWidget(
                            products: products,
                            userId: userId,
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
    );
  }
}
