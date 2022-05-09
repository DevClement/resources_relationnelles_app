import 'package:cube/screen/account_screen.dart';
import 'package:cube/screen/home_screen.dart';
import 'package:cube/screen/login_screen.dart';
import 'package:cube/screen/register_screen.dart';
import 'package:cube/screen/search_screen.dart';
import 'package:flutter/material.dart';

class DefaultPage extends StatefulWidget {
  static final String route = '/';

  static Widget currentPage = HomeScreen();
  static int currentIndex = 0;

  @override
  _DefaultPageState createState() => new _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;

  @override
  void initState() {
    super.initState();

    _page1 = HomeScreen();
    _page2 = SearchScreen();
    _page3 = HomeScreen();
    _page4 = LoginScreen(this);

    _pages = [_page1, _page2, _page3, _page4];

    DefaultPage.currentIndex = 0;
    DefaultPage.currentPage = _page1;
  }

  void changeTab(int index) {
    setState(() {
      DefaultPage.currentIndex = index;
      DefaultPage.currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: DefaultPage.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => changeTab(index),
          currentIndex: DefaultPage.currentIndex,
          fixedColor: Color.fromARGB(255, 13, 148, 136),
          selectedIconTheme: IconThemeData(
              color: Color.fromARGB(255, 13, 148, 136), opacity: 1.0, size: 25),
          unselectedIconTheme:
              IconThemeData(color: Colors.black45, opacity: 1.0, size: 25),
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: 'Accueil', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              label: 'Rechercher',
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: 'Ressources',
              icon: Icon(Icons.menu_book),
            ),
            BottomNavigationBarItem(
              label: 'Compte',
              icon: Icon(Icons.account_circle),
            ),
          ],
        ));
  }

  Widget navigationItemListTitle(String title, int index) {
    return new ListTile(
      title: new Text(
        title,
        style: new TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        changeTab(index);
      },
    );
  }
}
