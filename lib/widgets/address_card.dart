import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/bloc/form_bloc/bloc.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/widgets/address_form.dart';
import 'package:matrix/widgets/custom_route.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool fromPayment, isSelected;
  const AddressCard(
      {Key key,
      @required this.address,
      this.fromPayment = false,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          await Firestore.instance
              .collection("users")
              .document(address.userId)
              .updateData(({
                "address": {...address.toMap(), "id": address.id}
              }));
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(address.name),
                        Text(address.phoneNumber),
                        Text(address.flatNumber + " " + address.colonyNumber),
                        Text(address.landmark),
                        Text(address.city + " " + address.state),
                      ],
                    ),
                    isSelected ? Icon(Icons.check_circle_outline) : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                fromPayment
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: RaisedButton(
                              child: Text("Edit"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  SlideTopRoute(
                                    page: BlocProvider(
                                      create: (context) => FormBlocBloc(),
                                      child: AddressForm(
                                        address: address,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                              child: Text("Delete"),
                              onPressed: () {
                                BlocProvider.of<FormBlocBloc>(context)
                                  ..add(DeleteAddress(addressId: address.id));
                              },
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
