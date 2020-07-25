import 'package:flutter/material.dart';
import 'package:matrix/admin/widgets/page_design_form.dart';
import 'package:matrix/admin/widgets/product_option_form.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:matrix/admin/bloc/form_bloc/bloc.dart';




import 'package:matrix/widgets/custom_route.dart';

class product_option_card extends StatelessWidget {
  String name;
  String action,type,caption;


  product_option_card({this.name, this.action,this.type,this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
       
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
           
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
                        Text("Name: "+
                          name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text("Action: "+
                          action,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Type: "+
                          type,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(caption),
                        
                      ],
                    ),
                   
                    SizedBox()
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: RaisedButton(
                        child: Text("Edit"),
                        onPressed: () {
                          Navigator.of(context).push(SlideTopRoute(
                        page: BlocProvider(
                      create: (context) => FormBlocBloc(),
                      child: ProductOptionForm(product: null,ForEdit: true,Edit_name: name,Edit_action: action,Edit_type: type,Edit_caption: caption,)
                    )));
                        },
                      ),
                    ),

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


