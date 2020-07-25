import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/admin_product/adminproduct_bloc.dart';
import 'package:matrix/admin/bloc/admin_product/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/product_form.dart';
import 'package:matrix/admin/widgets/product_item.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/admin/screens/new_addProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsAdmin extends StatefulWidget {
  @override
  _ProductsAdminState createState() => _ProductsAdminState();
}

class _ProductsAdminState extends State<ProductsAdmin> {
  final _firestore = Firestore.instance;

  List designList = [];
  void getPagedesigns() async {
    await for (var snapshot
        in _firestore.collection('page_design').snapshots()) {
      for (var docs in snapshot.documents) {
        
        designList
            .add({"display": docs.data['name'], "value": docs.data['name']});

        print(designList);
      }
    }
  }

  @override
  void initState() {
    
    super.initState();
    getPagedesigns();
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
          title: Text('Products',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700)),
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
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
                              child: ProductForm(product: null),
                             
                              ),
                              ),);
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
                          Text('ADD PRODUCT',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              BlocProvider(
                create: (context) => AdminproductBloc()..add(LoadProducts()),
                child: BlocBuilder<AdminproductBloc, AdminproductState>(
                  builder: (BuildContext context, AdminproductState state) {
                    if (state is AdminProductLoading) {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is AdminProductLoaded) {
                      return StreamBuilder(
                        stream: state.products,
                        initialData: [],
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final ProductModel product = products[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProductItemAdmin(product: product,designs: designList,),
                                  );
                                },
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
        ));
  }
}
