import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/orders_bloc/bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/order.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/orders/order_details.dart';

class Orders extends StatelessWidget {
  final UserModel user;
  const Orders({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Orders",
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        body: BlocBuilder(
          bloc: BlocProvider.of<OrdersBloc>(context),
          builder: (BuildContext context, OrdersState state) {
            if (state is OrdersLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is OrdersLoaded) {
              return StreamBuilder(
                stream: state.orders,
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
                      final List<OrderModel> orders = snapshot.data;
                      print(orders.length);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            final OrderModel order = orders[index];
                            final List<CartModel> carts = order.cart;

                            return Card(
                              child: ListTile(
                                title: carts.length > 1
                                    ? Text(
                                        "${carts[0].product.name} + ${carts.length - 1} items")
                                    : Text("${carts[0].product.name}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      child: ListView.builder(
                                        itemCount: carts.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Image.network(carts[index]
                                                  .product
                                                  .images[0]));
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Date - ${order.createdAt.toIso8601String().substring(0, 10)}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 7.0)),
                                    Text(
                                      "ID: #${order.orderId}",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 7.0)),
                                    Text(
                                      "Status: ${order.status2 != null ? order.status2 : order.status3 != null ? order.status3 : order.status}",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 7.0)),
                                  ],
                                ),
                                trailing: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Details",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      SlideTopRoute(
                                          page: OrderDetails(
                                        order: order,
                                        address: null,
                                      )),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                  }
                },
              );
            }
            return Container();
          },
        ));
  }
}
