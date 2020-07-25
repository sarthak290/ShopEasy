import 'package:flutter/material.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/app_localizations.dart';
import 'package:matrix/widgets/products/product_horizontal.dart';
import 'package:matrix/widgets/text_widget.dart';

class SearchWidget extends StatefulWidget {
  final List<ProductModel> products;
  final String userId;

  SearchWidget({@required this.products, @required this.userId})
      : assert(products != null);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool searching = false;
  bool hasSearchResult = false;
  bool firstTime = true;
  List<ProductModel> products;

  @override
  void initState() {
    super.initState();
    products = widget.products;
  }

  void search(String query) async {
    if (query.length == 0) {
      setState(() {
        searching = false;
        hasSearchResult = false;
      });
      return;
    }

    setState(() {
      searching = true;
      firstTime = false;
    });

    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        products = widget.products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searching = false;
        hasSearchResult = products.length != 0 ? true : false;
      });
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15.0,
                            spreadRadius: 0.0)
                      ]),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 10.0,
                      ),
                      child: Theme(
                        data: ThemeData(hintColor: Colors.transparent),
                        child: TextFormField(
                          onChanged: (String query) {
                            search(query);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.search,
                                color: Color(0xFF6991C7),
                                size: 28.0,
                              ),
                              hintText: allTranslations.text("search"),
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: firstTime
                    ? Center(
                        child: Container(
                          child: CustomTextWidget(
                            textKey: "newSearch",
                          ),
                        ),
                      )
                    : searching
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : hasSearchResult
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 216,
                                    child: ProductCardHorizontal(
                                      product: products[index],
                                      favs: [],
                                      userId: widget.userId,
                                      search: true,
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Container(
                                  child: CustomTextWidget(
                                    textKey: "searchNotFound",
                                  ),
                                ),
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
