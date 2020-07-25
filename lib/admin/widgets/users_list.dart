import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrix/models/user.dart';

class UsersList extends StatefulWidget {
  final List<UserModel> users;
  const UsersList({Key key, @required this.users}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool searching = false;
  bool hasSearchResult = true;
  bool firstTime = true;
  List<UserModel> users;

  @override
  void initState() {
    super.initState();
    users = widget.users;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      users = widget.users;
    });
  }

  void search(String query) async {
    if (query.length == 0) {
      setState(() {
        searching = false;
        hasSearchResult = true;
      });
      return;
    }

    setState(() {
      searching = true;
    });

    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        users = widget.users
            .where((user) =>
                user.email.toLowerCase().contains(query.toLowerCase()) ||
                user.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searching = false;
        hasSearchResult = users.length != 0 ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, right: 0.0, left: 0.0, bottom: 8),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15.0,
                      spreadRadius: 0.0)
                ]),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10.0,
                ),
                child: Theme(
                  data: ThemeData(hintColor: Colors.transparent),
                  child: TextFormField(
                    onChanged: (String query) {
                      search(query);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Color(0xFF6991C7),
                          size: 28.0,
                        ),
                        hintText: "Search by email, name, role",
                        hintStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
            ),
          ),
        ),
        searching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : hasSearchResult
                ? Container(
                   
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        color: Colors.grey[400],
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final UserModel user = users[index];

                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            leading: user.avatarURL != null
                                ? Image.network(user.avatarURL)
                                : Image.network(
                                    "https://i.imgur.com/RS2mTYj.jpg"),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                user.displayName != null
                                    ? user.displayName
                                    : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                user.email != null ? user.email : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                user.role != null ? user.role : "user",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            SlideAction(
                              onTap: () async {
                                if (user.role == 'admin') {
                                  return;
                                }
                                final HttpsCallable callable =
                                    CloudFunctions.instance.getHttpsCallable(
                                  functionName: 'setRole',
                                );

                                try {
                                  final HttpsCallableResult resp =
                                      await callable.call(<String, dynamic>{
                                    'userId': user.uid,
                                    'role': 'admin',
                                  });
                                  Fluttertoast.showToast(
                                      msg: "${resp.data}",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg: "${e.message.toString()}",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: CircleAvatar(
                                radius: 22,
                                child: ImageIcon(
                                  AssetImage("assets/icons/admin.png"),
                                  size: 36.0,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            SlideAction(
                              onTap: () async {},
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
                  )
                : Center(
                    child: Container(
                      child: Text("Sorry :( No user found"),
                    ),
                  ),
      ],
    );
  }
}
 