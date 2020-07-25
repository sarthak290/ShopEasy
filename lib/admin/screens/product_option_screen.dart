import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/admin_category/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/category_form.dart';
import 'package:matrix/admin/widgets/product_option_form.dart';
import 'package:matrix/admin/widgets/category_list.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/admin/screens/product_option_card.dart';

class ProductOptionAdmin extends StatefulWidget {
  final List<product_option_card> optionCards;
  const ProductOptionAdmin({Key key,@required this.optionCards}) : super(key: key);

  @override
  _ProductOptionAdminState createState() => _ProductOptionAdminState();
}

class _ProductOptionAdminState extends State<ProductOptionAdmin> {

  Column makeColumn() {
    

    return Column(
      children: widget.optionCards,
    );
  }
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
          "Product Option",
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
                      child: ProductOptionForm(
                        product: null,
                        ForEdit: false,
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
                        Text('ADD PRODUCT OPTION',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            makeColumn(),
          ],
        ),
      ),
    );
  }
}
