import 'package:flutter/material.dart';
import 'package:matrix/admin/widgets/page_design_form.dart';
import 'package:matrix/admin/screens/edit_page_design.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:matrix/admin/bloc/form_bloc/bloc.dart';




import 'package:matrix/widgets/custom_route.dart';

class Page_design_card extends StatelessWidget {
  String name;
  String admin;

  Page_design_card({this.name, this.admin});

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
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(admin),
                       
                      ],
                    ),
                  
                    SizedBox()
                  ],
                ),
                SizedBox(
                  height: 32,
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
                      child: EditPageDesign(category: null, ForEdit: true,Edit_name: name,),
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


