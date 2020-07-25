import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrix/bloc/address/bloc.dart';
import 'package:matrix/bloc/form_bloc/form_bloc_bloc.dart';
import 'package:matrix/bloc/orders_bloc/bloc.dart';
import 'package:matrix/bloc/user_bloc/bloc.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/utils/config.dart';
import 'package:matrix/widgets/address_card.dart';
import 'package:matrix/widgets/address_form.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/orders/orders.dart';
import 'package:matrix/widgets/progress.dart';

class Payment extends StatefulWidget {
  final List<CartModel> cart;
  final double totalAmount;
  final double taxAmount;
  final double subTotal;
  final UserModel user;

  Payment(
      {@required this.cart,
      @required this.totalAmount,
      @required this.user,
      @required this.subTotal,
      @required this.taxAmount});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _saving = false;

  onFinishStripe(data) {
    setState(() {
      _saving = true;
    });
    Navigator.pop(context);

    print("FUNC onFinisges ${data.status}");
    if (data.status == "succeeded") {
      print("coming here");
      Navigator.of(context).pushReplacement(
        FadeRoute(
          page: BlocProvider(
            create: (context) =>
                OrdersBloc()..add(LoadOrders(userId: widget.user.uid)),
            child: Orders(
              user: widget.user,
            ),
          ),
        ),
      );
      setState(() {
        _saving = false;
      });
    }
  }

  onFinishRazorPay(data) {
    setState(() {
      _saving = true;
    });
    print(data);
    if (data != null) {
      Navigator.of(context).pushReplacement(
        FadeRoute(
          page: BlocProvider(
            create: (context) =>
                OrdersBloc()..add(LoadOrders(userId: widget.user.uid)),
            child: Orders(
              user: widget.user,
            ),
          ),
        ),
      );
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  int tapvalue = 0;
  int tapvalue2 = 0;

  Widget build(BuildContext context) {
    if (widget.cart.length == 0) {
      Navigator.pop(context);
      return null;
    }

    print(tapvalue2);
    print(tapvalue);
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.arrow_back_ios)),
          elevation: 0.0,
          title: Text(
            "Payment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Select Delivery Address",
                        style: TextStyle(
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context).push(
                              SlideTopRoute(
                                page: BlocProvider(
                                  create: (context) => FormBlocBloc(),
                                  child: AddressForm(
                                    address: null,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                  BlocProvider(
                    create: (context) => UserBloc()..add(LoadUser()),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (BuildContext context, UserState state) {
                        if (state is UserLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (state is UserLoaded) {
                          return StreamBuilder(
                            stream: state.user,
                            initialData: [],
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Container(
                                  child: Center(
                                      child: Text(
                                    "Coming Soon",
                                  )),
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
                                  final UserModel modelUser = snapshot.data;
                                  return BlocProvider(
                                    create: (context) => AddressBloc()
                                      ..add(LoadAddresss(
                                          userId: widget.user.uid)),
                                    child:
                                        BlocBuilder<AddressBloc, AddressState>(
                                      builder: (BuildContext context,
                                          AddressState state) {
                                        if (state is AddressLoading) {
                                          return Container(
                                            height: 80,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        if (state is AddressLoaded) {
                                          return StreamBuilder(
                                            stream: state.data,
                                            initialData: [],
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasError) {
                                                return Container(
                                                  child: Center(
                                                    child: Text(
                                                        "Something went wrong"),
                                                  ),
                                                );
                                              }
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Container(
                                                    height: 80,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                  break;
                                                default:
                                                  final List<AddressModel>
                                                      data = snapshot.data;
                                                  if (data.length == 0) {
                                                    return Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        child:
                                                            Text("No address"),
                                                      ),
                                                    );
                                                  }
                                                  return Container(
                                                    height: 200,
                                                    child: ListView.builder(
                                                      itemCount: data.length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final isSelected = modelUser
                                                                    .address ==
                                                                null
                                                            ? false
                                                            : modelUser.address[
                                                                    "id"] ==
                                                                data[index].id;
                                                        return AddressCard(
                                                          address: data[index],
                                                          fromPayment: true,
                                                          isSelected:
                                                              isSelected,
                                                        );
                                                      },
                                                    ),
                                                  );
                                              }
                                            },
                                          );
                                        }
                                        return SizedBox();
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
                  ),
                  Padding(padding: EdgeInsets.only(top: 22.0, bottom: 12)),
                  Text(
                    "Choose your Payment method",
                    style: TextStyle(
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 60.0)),

                  InkWell(
                    onTap: () {
                      setState(() {
                        if (tapvalue == 0) {
                          tapvalue++;
                          tapvalue2 = 0;
                        } else {
                          tapvalue--;
                        }
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: tapvalue,
                          onChanged: null,
                        ),
                        Text(
                          "Credit / Debit Card",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                      ],
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  Divider(
                    height: 1.0,
                    color: Colors.black26,
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (tapvalue2 == 0) {
                          tapvalue2++;
                          tapvalue = 0;
                        } else {
                          tapvalue2--;
                        }
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: tapvalue2,
                          onChanged: null,
                        ),
                        Text("Cash On Delivery",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0)),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  Divider(
                    height: 1.0,
                  ),

                  Padding(padding: EdgeInsets.only(top: 110.0)),

                 
                  InkWell(
                    onTap: () async {
                      if (widget.user.address == null) {
                        Fluttertoast.showToast(
                            msg: "Please Select an Address",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      if (tapvalue == 1) {
                        
                          Fluttertoast.showToast(
                              msg: "This payment method is not enabled",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        
                      } else if (tapvalue2 == 1) {
                        print("came 2");
                        try {
                          setState(() {
                            _saving = true;
                          });
                          final HttpsCallable callable =
                              CloudFunctions.instance.getHttpsCallable(
                            functionName: 'createCODOrder',
                          );

                          final HttpsCallableResult resp =
                              await callable.call(<String, dynamic>{
                            'cart': widget.cart.map((c) => c.toMap()).toList(),
                            'totalAmount': widget.totalAmount,
                            'taxAmount': widget.taxAmount,
                            'subTotal': widget.subTotal
                          });

                          print(resp.data);
                          Navigator.of(context).pushReplacement(
                            FadeRoute(
                              page: BlocProvider(
                                create: (context) => OrdersBloc()
                                  ..add(LoadOrders(userId: widget.user.uid)),
                                child: Orders(
                                  user: widget.user,
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            _saving = false;
                          });
                          Fluttertoast.showToast(
                              msg:
                                  "Something went wrong please try again later",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                    child: Container(
                      height: 55.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          tapvalue2 == 1 ? "Confirm" : "Pay",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                              letterSpacing: 2.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
