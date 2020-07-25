import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/models/user.dart';
import 'package:matrix/screens/account.dart';
import 'package:matrix/widgets/appbar.dart';

class Home extends StatefulWidget {
  final UserModel user;

  const Home({Key key, @required this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  PageController _pageController;
  int pageIndex = 0;

  void _onChangePageIndex(index) {
    setState(() {
      pageIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.user.role == 'admin' ? true : false;
    return Scaffold(
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(58.0),        child: CustomAppbar(),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onChangePageIndex,
        children: null,
      ),
      drawer: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _onChangePageIndex(2);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/icons/icon-cart.png",
                    fit: BoxFit.contain,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  
                ],
              )
              // elevation: 5.0,
              ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3.0,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/icon-home.png",
                fit: BoxFit.contain,
                width: 20,
                height: 20,
                color: pageIndex == 0
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).hintColor,
              ),
              title: Container(height: 0.0)),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/icon-category.png",
                fit: BoxFit.contain,
                width: 20,
                height: 20,
                color: pageIndex == 1
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).hintColor,
              ),
              title: Container(height: 0.0)),
          BottomNavigationBarItem(
              title: Container(
                height: 0,
              ),
              icon: Icon(
                Icons.category,
                color: Colors.transparent,
              )),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/icon-search.png",
                  fit: BoxFit.contain,
                  width: 20,
                  height: 20,
                  color: pageIndex == 3
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).hintColor),
              title: Container(height: 0.0)),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/icon-user.png",
                fit: BoxFit.contain,
                width: 20,
                height: 20,
                color: pageIndex == 4
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).hintColor),
            title: Container(height: 0.0),
          ),
        ],
        onTap: _onChangePageIndex,
        currentIndex: pageIndex,
        fixedColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

