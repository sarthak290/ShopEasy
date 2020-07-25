import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/cart_bloc/bloc.dart';
import 'package:matrix/models/cart.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/widgets/cart/cart.dart';

class CartScreen extends StatelessWidget {
  final UserModel user;
  const CartScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(LoadCart(userId: user.uid)),
      child: Scaffold(
        body: BlocListener<CartBloc, CartState>(
          listener: (BuildContext context, CartState state) {
            
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (BuildContext context, CartState state) {
              if (state is CartLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CartLoaded) {
                return StreamBuilder(
                  stream: state.cart,
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
                        final List<CartModel> carts = snapshot.data;
                        return Cart(
                          carts: carts,
                          user: user,
                        );
                    }
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
