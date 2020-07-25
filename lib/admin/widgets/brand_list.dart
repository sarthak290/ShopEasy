import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:matrix/admin/bloc/admin_brands/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/brand_form.dart';
import 'package:matrix/models/brand.dart';
import 'package:matrix/widgets/custom_route.dart';

class BrandList extends StatelessWidget {
  final List<BrandModel> brands;
  const BrandList({Key key, @required this.brands}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "BRAND LIST",
              textAlign: TextAlign.center,
              style: TextStyle(
                 
                  fontFamily: "Montserat",
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
            ),
          ),
        ),
        Container(
         
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: brands.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey[400],
            ),
            itemBuilder: (BuildContext context, int index) {
              final BrandModel brand = brands[index];

              return Slidable(
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.25,
                child: ListTile(
                  leading: brand.images != null && brand.images.length > 0
                      ? Image.network(brand.images[0])
                      : Image.network("https://i.imgur.com/RS2mTYj.jpg"),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      brand.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      brand.description,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  SlideAction(
                    onTap: () {
                      Navigator.of(context).push(
                        SlideTopRoute(
                          page: BlocProvider(
                            create: (context) => FormBlocBloc(),
                            child: BrandsForm(
                              brand: brand,
                            ),
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                  SlideAction(
                    onTap: () {
                    
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                actions: <Widget>[
                                  ButtonBar(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          AdminbrandsBloc().add(
                                              DeleteAdminBrand(brand: brand));
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                                content: Container(
                                  child: Text("Are you sure?"),
                                ),
                              ));
                    },
                    child: CircleAvatar(
                      radius: 22,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
