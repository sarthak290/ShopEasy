import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/authentication_bloc/bloc.dart';
import 'package:matrix/bloc/cart_bloc/bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/product.dart';

import '../text_widget.dart';

class AddToCart extends StatelessWidget {
  final ProductModel product;
  AddToCart({Key key, @required this.product}) : super(key: key);

  void showConfirm(context, cart) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 32.0,
                      bottom: 4.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    margin: EdgeInsets.only(top: 32.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize:
                          MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Are you sure?",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24.0,
                              color: Colors.redAccent),
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          "Do you want to remove this item from cart?",
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.grey[400]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              iconSize: 24.0,
                              color: Colors.grey[400],
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              color: Colors.red[200],
                              icon: Icon(Icons.done),
                              iconSize: 24,
                              onPressed: () async {
                                CartBloc().add(
                                  ToggleCart(
                                      cart: CartModel(
                                        cartId: cart.cartId,
                                        productId: cart.productId,
                                        userId: cart.userId,
                                        deleted: false,
                                        qty: 0,
                                      ),
                                      userId: cart.userId),
                                );
                                CartBloc().add(UpdateCartQty(
                                    cart: cart, type: "decrement"));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState authState) {
        if (authState is Authenticated) {
          return BlocProvider(
            create: (context) =>
                CartBloc()..add(LoadCart(userId: authState.user.uid)),
            child: Container(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (BuildContext context, CartState state) {
                  if (state is CartLoading) {
                    return Center();
                  }
                  if (state is CartLoaded) {
                    return StreamBuilder(
                      stream: state.cart,
                      initialData: [],
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            width: 20,
                            height: 20,
                          );
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              width: 20,
                              height: 20,
                            );
                            break;
                          default:
                            final List<CartModel> carts = snapshot.data;
                            print(carts.length);
                            CartModel cart = carts
                                        .where((cart) =>
                                            cart.productId == product.productId)
                                        .toList()
                                        .length >
                                    0
                                ? carts
                                    .where((cart) =>
                                        cart.productId == product.productId)
                                    .toList()[0]
                                : CartModel(
                                    cartId: "abc",
                                    userId: authState.user.uid,
                                    productId: product.productId,
                                    product: product,
                                    deleted: false);
                            bool inCart = carts
                                        .where((cart) =>
                                            cart.productId == product.productId)
                                        .toList()
                                        .length >
                                    0
                                ? true
                                : false;
                            if (inCart) {
                              return Container(
                                height: 54,
                                padding: EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black12.withOpacity(0.1)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    
                                    InkWell(
                                      onTap: () {
                                        print("qty ${cart.qty}");

                                        if (cart.qty == 1) {
                                          
                                          showConfirm(context, cart);
                                        } else {
                                          CartBloc().add(UpdateCartQty(
                                              cart: cart, type: "decrement"));
                                        }
                                      },
                                      child: Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "-",
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.white
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              ),
                                        )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Text(cart.qty.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Color(0xff242424),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          )),
                                    ),

                                  
                                    InkWell(
                                      onTap: () {
                                        CartBloc().add(UpdateCartQty(
                                            cart: cart, type: "increment"));
                                      },
                                      child: Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "+",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Center(
                              child: Container(
                                height: 54,
                                child: RaisedButton(
                                  elevation: 0,
                                  child: CustomTextWidget(
                                      textKey: product.inventoryQty <= 0
                                          ? "outOfStock"
                                          : inCart ? "removeBag" : "addToBag",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      )),
                                  onPressed: () {
                                    try {
                                      CartBloc()
                                        ..add(
                                            ToggleCart(cart: cart, userId: ""));
                                    } catch (e) {}
                                  },
                                ),
                              ),
                            );
                        }
                      },
                    );
                  }
                  return Container(
                    width: 20,
                    height: 20,
                  );
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
