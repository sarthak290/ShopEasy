import 'package:flutter/material.dart';
import 'package:matrix/bloc/cart_bloc/bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/cart/cart_bottom.dart';
import 'package:matrix/widgets/cart/cart_empty.dart';
import 'package:matrix/widgets/text_widget.dart';

class Cart extends StatefulWidget {
  final List<CartModel> carts;
  final UserModel user;
  Cart({@required this.carts, @required this.user});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final List<CartModel> carts = widget.carts;
    var total = carts.fold(
        0, (total, current) => total + (current.product.price * current.qty));

    var taxTotal = carts.fold(
        0,
        (total, current) =>
            total +
            ((current.product.tax / 100) *
                current.product.price *
                current.qty));

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: carts.length > 0
          ? CartBottom(
              totalAmount: total + taxTotal,
              subTotal: total,
              taxAmount: taxTotal,
              cart: carts,
              user: widget.user,
            )
          : null,
      body: carts.length > 0
          ? SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).cardColor,
                    child: ListView.builder(
                      itemCount: carts.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int position) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: position == carts.length - 1 ? 0 : 1,
                                  color: position == carts.length - 1
                                      ? Colors.transparent
                                      : Colors.grey[300]),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black12.withOpacity(0.1),
                                            blurRadius: 0.5,
                                            spreadRadius: 0.1)
                                      ]),
                                  child: Image.network(
                                    '${carts[position].product.images[0]}',
                                    height: 130.0,
                                    width: 120.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25.0, left: 10.0, right: 5.0),
                                child: Column(
                                  
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${carts[position].product.name}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        '${carts[position].product.description}',
                                        maxLines: 2,
                                        style: TextStyle(
                                          
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Text(
                                      '${Tools.getCurrecyFormatted(carts[position].product.price)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    CustomTextWidget(
                                      textKey: 'tax',
                                      addText:
                                          "- ${Tools.getCurrecyFormatted(carts[position].product.tax)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 0.0),
                                      child: Container(
                                        width: 112.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            border: Border.all(
                                                color: Colors.black12
                                                    .withOpacity(0.1))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (carts[position].qty ==
                                                      0) {
                                                   
                                                    CartBloc().add(ToggleCart(
                                                        cart: carts[position],
                                                        userId:
                                                            widget.user.uid));
                                                  } else {
                                                    CartBloc().add(
                                                        UpdateCartQty(
                                                            cart:
                                                                carts[position],
                                                            type: "decrement"));
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.black12
                                                          .withOpacity(0.1),
                                                    ),
                                                  ),
                                                ),
                                                child: Center(child: Text("-")),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18.0),
                                              child: Text(carts[position]
                                                  .qty
                                                  .toString()),
                                            ),

                                          
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  CartBloc().add(UpdateCartQty(
                                                      cart: carts[position],
                                                      type: "increment"));
                                                });
                                              },
                                              child: Container(
                                                height: 30.0,
                                                width: 28.0,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color: Colors
                                                                .black12
                                                                .withOpacity(
                                                                    0.1)))),
                                                child: Center(child: Text("+")),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CustomTextWidget(
                              textKey: "orderSummary",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            leading: CustomTextWidget(
                              textKey: "subTotal",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              Tools.getCurrecyFormatted(total),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: CustomTextWidget(
                              textKey: "taxTotal",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              Tools.getCurrecyFormatted(taxTotal),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: CustomTextWidget(
                              textKey: "total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            trailing: Text(
                              Tools.getCurrecyFormatted(total + taxTotal),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )
          : CartEmpty(),
    );
  }
}
