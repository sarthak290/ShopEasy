import 'package:flutter/material.dart';
import 'package:matrix/widgets/categories/category_round.dart';

class CategoryScreen extends StatelessWidget {
  final String userId;
  CategoryScreen({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CategoryRound(
            userId: userId,
          ),
        ],
      ),
    );
  }
}
