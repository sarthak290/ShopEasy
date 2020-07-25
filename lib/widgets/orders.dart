import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  static var _txtCustom = TextStyle(
    color: Colors.black54,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track My Orders",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
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
                  "Wed, 12 September",
                  style: _txtCustom,
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Text(
                  "Orders ID: 5t36 - 9iu2 - 12i92",
                  style: _txtCustom,
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text(
                  "Orders",
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
                          txtHeader: "Ready to Pickup",
                          txtInfo: "Orders from TrevaShop",
                          time: "11:0",
                          paddingValue: 55.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/courier.png",
                          txtHeader: "Orders Processed",
                          txtInfo: "We are preparing your Orders",
                          time: "9:50",
                          paddingValue: 16.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/payment.png",
                          txtHeader: "Payment Confirmed",
                          txtInfo: "Awaiting Confirmation",
                          time: "8:20",
                          paddingValue: 55.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/Orders.png",
                          txtHeader: "Orders Placed",
                          txtInfo: "We have received your Orders",
                          time: "8:00",
                          paddingValue: 19.0,
                        ),
                      ],
                    ),
                  ],
                ), /////
                Padding(
                  padding: const EdgeInsets.only(
                      top: 48.0, bottom: 30.0, left: 0.0, right: 25.0),
                  child: Container(
                    height: 130.0,
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
                            Text(
                              "House No: 1234, 2nd Floor Sector 18, \nSilicon Valey Amerika Serikat",
                              style: _txtCustom.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  color: Colors.black38),
                              overflow: TextOverflow.ellipsis,
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
  static var _txtCustomOrders = TextStyle(
    color: Colors.black45,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
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
                    Text(txtHeader, style: _txtCustomOrders),
                    Text(
                      txtInfo,
                      style: _txtCustomOrders.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.black38),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: _txtCustomOrders..copyWith(fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }
}
