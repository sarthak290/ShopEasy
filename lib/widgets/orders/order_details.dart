import 'package:flutter/material.dart';
import 'package:matrix/models/order.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel order;
  final String address;

  OrderDetails({@required this.order, @required this.address});

  @override
  static var _txtCustom = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
  );

 
  var _bigCircleNotYet = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
    ),
  );


  var _bigCircle = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 14.0,
        ),
      ),
    ),
  );

  
  var _smallCircle = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 3.0,
      width: 3.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
    ),
  );

  Widget build(BuildContext context) {
    print(order);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 800.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Date - ${order.createdAt.toIso8601String().substring(0, 10)}",
                  style: _txtCustom.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Text(
                  "Order id: #${order.orderId}",
                  style: _txtCustom,
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text(
                  "Order Details",
                  style: _txtCustom.copyWith(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _bigCircleNotYet,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _bigCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _bigCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _bigCircle,
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        qeueuItem(
                          icon: "assets/img/bag.png",
                          txtHeader: "Out for Delivery ",
                          txtInfo: "",
                          time: "",
                          paddingValue: 55.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/courier.png",
                          txtHeader: "OrderDetails Processed",
                          txtInfo: "We are preparing your OrderDetails",
                          time: "",
                          paddingValue: 16.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/payment.png",
                          txtHeader:
                              "${order.status == "paid" ? "Payment Confirmed" : "Payment Failed"}",
                          txtInfo: "Awaiting Confirmation",
                          time: "",
                          paddingValue: 55.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/OrderDetails.png",
                          txtHeader: "OrderDetails Placed",
                          txtInfo: "We have received your order",
                          time: "",
                          paddingValue: 19.0,
                        ),
                      ],
                    ),
                  ],
                ), 
                Padding(
                  padding: const EdgeInsets.only(
                      top: 48.0, bottom: 30.0, left: 0.0, right: 25.0),
                  child: Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 4.5,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // Image.asset("assets/img/house.png"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Delivery Address",
                              style: _txtCustom.copyWith(
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Text(
                              "Home, Work & Other Address",
                              style: _txtCustom.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                  color: Colors.black38),
                            ),
                            Padding(padding: EdgeInsets.only(top: 2.0)),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(order.address.name),
                                    Text(order.address.phoneNumber),
                                    Text(order.address.flatNumber +
                                        " " +
                                        order.address.colonyNumber),
                                    Text(order.address.landmark),
                                    Text(order.address.city +
                                        " " +
                                        order.address.state),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class qeueuItem extends StatelessWidget {
  @override
  static var _txtCustomOrderDetails = TextStyle(
    color: Colors.black45,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
  );

  String icon, txtHeader, txtInfo, time;
  double paddingValue;

  qeueuItem(
      {this.icon, this.txtHeader, this.txtInfo, this.time, this.paddingValue});

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 13.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image.asset(icon),
              Padding(
                padding: EdgeInsets.only(
                    left: 8.0,
                    right: mediaQueryData.padding.right + paddingValue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(txtHeader, style: _txtCustomOrderDetails),
                    Text(
                      txtInfo,
                      style: _txtCustomOrderDetails.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.black38),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: _txtCustomOrderDetails
                  ..copyWith(fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }
}
