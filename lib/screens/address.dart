import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/address/bloc.dart';
import 'package:matrix/bloc/form_bloc/form_bloc_bloc.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/widgets/address_card.dart';
import 'package:matrix/widgets/address_form.dart';
import 'package:matrix/widgets/custom_route.dart';

class AddressScreen extends StatelessWidget {
  final UserModel user;
  const AddressScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Address",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BlocProvider(
              create: (context) =>
                  AddressBloc()..add(LoadAddresss(userId: user.uid)),
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (BuildContext context, AddressState state) {
                  if (state is AddressLoading) {
                    return Container(
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is AddressLoaded) {
                    return StreamBuilder(
                      stream: state.data,
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
                              height: 80,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                            break;
                          default:
                            final List<AddressModel> data = snapshot.data;
                            if (data.length == 0) {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Text("No address"),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final isSelected = user.address == null
                                    ? false
                                    : user.address["id"] == data[index].id;
                                return AddressCard(
                                  address: data[index],
                                  isSelected: isSelected,
                                );
                              },
                            );
                        }
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
