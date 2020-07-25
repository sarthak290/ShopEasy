import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matrix/admin/bloc/admin_orders/bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/order.dart';
import 'package:matrix/models/product.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/utils/tools.dart';

class AdminOrderDetails extends StatelessWidget {
  final OrderModel order;
  const AdminOrderDetails({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection("users")
                              .document(order.userId)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              return Container(
                                child:
                                    Center(child: Text("Something went wrong")),
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
                                final UserModel user =
                                    UserModel.fromFirestore(snapshot.data);

                                print(user.displayName);

                                return Column(
                                  children: <Widget>[
                                    Text(
                                      "Name - ${user.displayName}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12
                                                  .withOpacity(0.1),
                                              blurRadius: 4.5,
                                              spreadRadius: 1.0,
                                            )
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // Image.asset("assets/img/house.png"),
                                          if (order.address != null)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Delivery Address",style: TextStyle(color:Colors.black87),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0)),
                                                Text(
                                                  "Home, Work & Other Address",style: TextStyle(color:Colors.black87)
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.0)),
                                                Expanded(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            order.address.name,style: TextStyle(color:Colors.black87)),
                                                        Text(order.address
                                                            .phoneNumber,style: TextStyle(color:Colors.black87)),
                                                        Text(order.address
                                                                .flatNumber +
                                                            " " +
                                                            order.address
                                                                .colonyNumber,style: TextStyle(color:Colors.black87)),
                                                        Text(order
                                                            .address.landmark,style: TextStyle(color:Colors.black87)),
                                                        Text(
                                                            order.address.city +
                                                                " " +
                                                                order.address
                                                                    .state,style: TextStyle(color:Colors.black87)),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                );
                            }
                          }),
                      Text(
                        "Date - ${order.createdAt.toIso8601String().substring(0, 10)}",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          "ID: #${order.orderId}",
                          style: TextStyle(
                            // color: Colors.black54,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          "STATUS: ${order.status}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          "Amount Paid: ${Tools.getCurrecyFormatted(order.totalAmount)}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  "Items",
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: order.cart.length,
                itemBuilder: (BuildContext context, int index) {
                  final ProductModel product = order.cart[index].product;
                  final CartModel cart = order.cart[index];
                  return Card(
                    child: ListTile(
                      trailing: Image.network(product.images[0]),
                      title: Text(
                        product.name,
                        // style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Order Quantity - ${cart.qty.toString()}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: order.status2 == null
                        ? Text(
                            "Dispatch",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        : order.status3 == "delivered"
                            ? Text(
                                "Delivered",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            : Text(
                                "Deliver",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                    onPressed: () {
                      if (order.status3 != "delivered") {
                        AdminOrdersBloc().add(ChnageOrderStatus(
                            order: order,
                            type: order.status2 == null
                                ? "dispatched"
                                : "delivered"));
                        Navigator.pop(context);
                      }
                    },
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
