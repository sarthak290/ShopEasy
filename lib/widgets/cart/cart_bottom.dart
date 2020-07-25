import 'package:flutter/material.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/utils/tools.dart';
import 'package:matrix/widgets/cart/payment.dart';
import 'package:matrix/widgets/custom_route.dart';
import 'package:matrix/widgets/text_widget.dart';

class CartBottom extends StatelessWidget {
  final List<CartModel> cart;
  final double totalAmount;
  final double taxAmount;
  final double subTotal;
  final UserModel user;
  const CartBottom(
      {Key key,
      @required this.totalAmount,
      @required this.taxAmount,
      @required this.user,
      @required this.subTotal,
      @required this.cart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding:
          const EdgeInsets.only(top: 9.0, left: 10.0, right: 10.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),

          
            child: CustomTextWidget(
              textKey: "total",
              addText: Tools.getCurrecyFormatted(totalAmount),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(SlideTopRoute(
                  page: Payment(
                cart: cart,
                user: user,
                totalAmount: totalAmount,
                taxAmount: taxAmount,
                subTotal: subTotal,
              )));
            
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                height: 40.0,
                width: 120.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: CustomTextWidget(
                    textKey: "checkout",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
