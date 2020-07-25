import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:matrix/admin/bloc/admin_orders/bloc.dart';
import 'package:matrix/admin/widgets/order_details.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/order.dart';
import 'package:matrix/widgets/custom_route.dart';

class AdminOrders extends StatelessWidget {
  const AdminOrders({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Orders",
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        body: BlocProvider(
          create: (context) => AdminOrdersBloc()..add(LoadAdminOrders()),
          child: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
            builder: (BuildContext context, AdminOrdersState state) {
              if (state is AdminOrdersLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is AdminOrdersLoaded) {
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (BuildContext context, int index) {
                              final OrderModel order = orders[index];
                              final List<CartModel> carts = order.cart;

                              return Slidable(
                                actionPane: SlidableStrechActionPane(),
                                child: Card(
                                  child: ListTile(
                                    title: carts.length > 1
                                        ? Text(
                                            "${carts[0].product.name} + ${carts.length - 1} items")
                                        : Text("${carts[0].product.name}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 80,
                                          child: ListView.builder(
                                            itemCount: carts.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Image.network(
                                                      carts[index]
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
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8),
                                          child: Text(
                                            "ID: #${order.orderId}",
                                            style: TextStyle(
                                              
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8),
                                          child: Text(
                                            "STATUS: ${order.status}",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
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
                                              page: AdminOrderDetails(
                                            order: order,
                                          )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  order.status3 != "delivered"
                                      ? SlideAction(
                                          onTap: () {
                                            AdminOrdersBloc().add(
                                                ChnageOrderStatus(
                                                    order: order,
                                                    type: order.status2 == null
                                                        ? "dispatched"
                                                        : "delivered"));
                                          },
                                          child: CircleAvatar(
                                            radius: 22,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  order.status2 == null
                                                      ? "assets/icons/cart_return.png"
                                                      : "assets/icons/orders.png",
                                                  fit: BoxFit.contain,
                                                  width: 24,
                                                  height: 24,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            backgroundColor: Colors.greenAccent,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
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
          ),
        ));
  }
}
