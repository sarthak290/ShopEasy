import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/admin_category/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/category_form.dart';
import 'package:matrix/admin/widgets/page_design_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matrix/admin/screens/page_design_card.dart';
import 'package:matrix/admin/screens/edit_page_design.dart';

import 'package:matrix/admin/widgets/category_list.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/widgets/custom_route.dart';

class PageDesignAdmin extends StatefulWidget {
  final List<Page_design_card> Design_cards;
  const PageDesignAdmin({Key key,@required this.Design_cards}) : super(key: key);

  @override
  _PageDesignAdminState createState() => _PageDesignAdminState();
}

class _PageDesignAdminState extends State<PageDesignAdmin> {
  final _firestore = Firestore.instance;



  
  
  Column makeColumn() {
    

    return Column(
      children: widget.Design_cards,
    );
  }

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
          "Page Design",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, letterSpacing: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 54.0),
              child: Material(
                elevation: 8.0,
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(0.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(SlideTopRoute(
                        page: BlocProvider(
                      create: (context) => FormBlocBloc(),
                      child: Pagedesignform(
                        category: null,
                        ForEdit: false,
                      ),
                    )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white),
                        Padding(padding: EdgeInsets.only(right: 16.0)),
                       Text('ADD PAGE DESIGN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            makeColumn(),
            
          
           
          ],
        ),
      ),
    );
  }
}

