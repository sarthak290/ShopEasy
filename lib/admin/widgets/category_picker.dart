import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/widgets/chips_input.dart';
import 'package:matrix/admin/bloc/admin_category/bloc.dart';
import 'package:matrix/models/category.dart';

class CategoryPicker extends StatelessWidget {
  final updateCategories;
  final List<CategoryModel> initalCategories;
  CategoryPicker(
      {@required this.updateCategories, @required this.initalCategories});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCategoryBloc()..add(LoadAdminCategory()),
      child: BlocBuilder<AdminCategoryBloc, AdminCategoryState>(
        builder: (BuildContext context, AdminCategoryState state) {
          if (state is AdminCategoryLoaded) {
            return StreamBuilder(
              stream: state.category,
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
                    final List<CategoryModel> category = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChipsInput(
                        initialValue: initalCategories,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Select Category",
                            labelStyle: TextStyle(
                                fontSize: 22.0,
                                color: Theme.of(context).primaryColor)),
                        maxChips: 6,
                        findSuggestions: (String query) {
                          if (query.length != 0) {
                            var lowercaseQuery = query.toLowerCase();
                            return category.where((cat) {
                              return cat.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase());
                            }).toList(growable: false)
                              ..sort((a, b) => a.name
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)
                                  .compareTo(b.name
                                      .toLowerCase()
                                      .indexOf(lowercaseQuery)));
                          }
                          return category;
                        },
                        onChanged: (data) {
                          
                          updateCategories(data);
                        },
                        chipBuilder: (context, state, cat) {
                          return InputChip(
                            key: ObjectKey(cat.name),
                            label: Text(cat.name),
                            onDeleted: () => state.deleteChip(cat),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        },
                        suggestionBuilder: (context, state, cat) {
                          return ListTile(
                            key: ObjectKey(cat.name),
                            title: Text(cat.name),
                            onTap: () => state.selectSuggestion(cat),
                          );
                        },
                      ),
                    );
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
