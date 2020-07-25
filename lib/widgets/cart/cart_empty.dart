import 'package:flutter/material.dart';
import 'package:matrix/widgets/text_widget.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      height: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextWidget(
              textKey: "cartEmpty",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.5,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 70,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: CustomTextWidget(
                    textKey: "startShopping",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
