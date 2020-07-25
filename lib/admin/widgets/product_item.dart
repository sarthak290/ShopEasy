import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:matrix/admin/bloc/admin_product/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/screens/new_addProduct.dart';
import 'package:matrix/admin/widgets/product_form.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/utils/config.dart';

class ProductItemAdmin extends StatelessWidget {
  final ProductModel product;
  List designs;

  ProductItemAdmin({@required this.product,this.designs}) : assert(product != null);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: SizedBox.fromSize(
          size: Size.fromRadius(44.0),
          child: Material(
              elevation: 20.0,
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              shadowColor: Color(0x802196F3),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    image: DecorationImage(
                      image: NetworkImage(
                        product.images[0],
                      ),
                      fit: BoxFit.contain,
                    )),
              )),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 24.0),
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(0.0),
            shadowColor: Color(0x802196F3),
          
            child: InkWell(
              onTap: () {
                
              },
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            '${product.brand != null ? product.brand["name"] + " - " + product.name : product.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                '${product.description}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('CurrentQty -', style: TextStyle()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(8.0),
                            color:
                                HexColor(Settings["Setting"]["SecondaryColor"]),
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('${product.inventoryQty}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        SlideAction(
          onTap: () {
            Navigator.of(context).push(
              SlideTopRoute(
                page: BlocProvider(
                    create: (context) => FormBlocBloc(),
                    child: ProductForm(product: product),),
              ),
            );
          },
          child: CircleAvatar(
            radius: 30,
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        SlideAction(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      actions: <Widget>[
                        ButtonBar(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                AdminproductBloc()
                                    .add(DeleteAdminProduct(product: product));
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.check,
                                color: Colors.red,
                              ),
                            )
                          ],
                        )
                      ],
                      content: Container(
                        child: Text("Are you sure?"),
                      ),
                    ));
          },
          child: CircleAvatar(
            radius: 30,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}


