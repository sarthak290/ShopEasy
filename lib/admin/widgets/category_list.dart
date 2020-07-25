import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:matrix/admin/bloc/admin_category/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/category_form.dart';
import 'package:matrix/models/category.dart';
import 'package:matrix/widgets/custom_route.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel> category;
  const CategoryList({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
       
        Container(
         
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: category.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey[400],
            ),
            itemBuilder: (BuildContext context, int index) {
              final CategoryModel cat = category[index];

              return Slidable(
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.25,
                child: ListTile(
                  leading: cat.images != null && cat.images.length > 0
                      ? Image.network(cat.images[0])
                      : Image.network("https://i.imgur.com/RS2mTYj.jpg"),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      cat.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      cat.description,
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
                            child: CategoryForm(
                              category: cat,
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
                                          AdminCategoryBloc().add(
                                              DeleteAdminCategory(
                                                  category: cat));
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
