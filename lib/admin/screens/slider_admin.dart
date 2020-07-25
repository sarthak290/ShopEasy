import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:matrix/admin/bloc/admin_sliders/bloc.dart';
import 'package:matrix/admin/bloc/form_bloc/bloc.dart';
import 'package:matrix/admin/widgets/slider_from.dart';
import 'package:matrix/models/slider.dart';
import 'package:matrix/widgets/custom_route.dart';

class SlidersAdmin extends StatelessWidget {
  const SlidersAdmin({Key key}) : super(key: key);

  void updateFormState(String type, String message) {}

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
            "Sliders",
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
                        child: SlidersForm(
                          slider: null,
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
                          Text('ADD A Slider',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              BlocProvider(
                create: (context) =>
                    AdminSlidersBloc()..add(LoadAdminSliders()),
                child: BlocBuilder<AdminSlidersBloc, AdminSlidersState>(
                  builder: (BuildContext context, AdminSlidersState state) {
                    if (state is AdminSlidersLoading) {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is AdminSlidersLoaded) {
                      return StreamBuilder(
                        stream: state.sliders,
                        initialData: [],
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                              final List<SliderModel> sliders = snapshot.data;
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: sliders.length,
                                itemBuilder: (BuildContext context, int index) {
                                  SliderModel slider = sliders[index];
                                  return Slidable(
                                    actionPane: SlidableStrechActionPane(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Card(
                                        child: Container(
                                          height: 300,
                                          child:
                                              Image.network(slider.images[0]),
                                        ),
                                      ),
                                    ),
                                    secondaryActions: <Widget>[
                                      SlideAction(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            SlideTopRoute(
                                              page: BlocProvider(
                                                create: (context) =>
                                                    FormBlocBloc(),
                                                child: SlidersForm(
                                                  slider: slider,
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
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      SlideAction(
                                        onTap: () {
                                        
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    actions: <Widget>[
                                                      ButtonBar(
                                                        children: <Widget>[
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              AdminSlidersBloc().add(
                                                                  DeleteAdminSlider(
                                                                      slider:
                                                                          slider));
                                                              Navigator.pop(
                                                                  context);
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
                                                      child:
                                                          Text("Are you sure?"),
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
                              );
                          }
                        },
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
