import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/admin/bloc/admin_users/bloc.dart';
import 'package:matrix/admin/widgets/users_list.dart';
import 'package:matrix/models/user.dart';

class UsersAdmin extends StatelessWidget {
  const UsersAdmin({Key key}) : super(key: key);

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
            "Users",
            style: TextStyle(
                color: Colors.white, fontSize: 24.0, letterSpacing: 1.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              BlocProvider(
                create: (context) => UsersBloc()..add(LoadUsers()),
                child: BlocBuilder<UsersBloc, UsersState>(
                  builder: (BuildContext context, UsersState state) {
                    if (state is UsersLoading) {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is UsersLoaded) {
                      return StreamBuilder(
                        stream: state.users,
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
                              final List<UserModel> users = snapshot.data;
                              return Container(
                                child: UsersList(
                                  users: users,
                                ),
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
