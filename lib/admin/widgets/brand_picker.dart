import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/widgets/chips_input.dart';
import 'package:matrix/admin/bloc/admin_brands/bloc.dart';
import 'package:matrix/models/brand.dart';



class BrandPicker extends StatelessWidget {
  final updateBrand;
  final BrandModel initalBrands;
  BrandPicker(
      {Key key, @required this.updateBrand, @required this.initalBrands})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("init brand $initalBrands");
    return BlocProvider(
      create: (context) => AdminbrandsBloc()..add(LoadAdminBrands()),
      child: BlocBuilder<AdminbrandsBloc, AdminbrandsState>(
        builder: (BuildContext context, AdminbrandsState state) {
          if (state is AdminBrandsLoaded) {
            return StreamBuilder(
              stream: state.brands,
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
                    final List<BrandModel> brands = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChipsInput(
                        initialValue: initalBrands != null
                            ? [initalBrands]
                            : List<BrandModel>(),

                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Select Brand",
                            labelStyle: TextStyle(
                                fontSize: 22.0,
                                color: Theme.of(context).primaryColor)),
                        maxChips: 1,
                        findSuggestions: (String query) {
                          if (query.length != 0) {
                            var lowercaseQuery = query.toLowerCase();
                            return brands.where((cat) {
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
                          return brands;
                        },
                        onChanged: (List<BrandModel> data) {
                          
                          updateBrand(data.length > 0 ? data[0] : null);
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
