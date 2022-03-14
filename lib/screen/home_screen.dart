import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String route = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            _buildTtitle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 25,
                    height: 300,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        _buildDot(20, 0),
                        _buildLine(40, 11, 3, 120),
                        _buildDot(150, 0)
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      'Dernières ressources',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 25),
                    _buildBoxRessource(),
                    Container(
                      color: Colors.red,
                      height: 100,
                      width: 100,
                    )
                  ]),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Color.fromARGB(255, 13, 148, 136),
          selectedIconTheme: IconThemeData(
              color: Color.fromARGB(255, 13, 148, 136), opacity: 1.0, size: 25),
          unselectedIconTheme:
              IconThemeData(color: Colors.black45, opacity: 1.0, size: 25),
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Accueil',
              icon: Icon(Icons.home),
            ),
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
          onTap: (int indexOfItem) {}),
    );
  }

  Widget _buildTtitle() {
    return Text("Accueil",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 30));
  }

  Widget _buildDot(double top, double left) {
    return Positioned(
        top: top,
        left: left,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF6DC300),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: 25,
          width: 25,
        ));
  }

  Widget _buildBoxRessource() {
    return Container(
      color: Color(0xFFEEEEEE),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.height * 0.30,
      ),
      width: 22200,
      height: 100,
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[],
          )),
    );
  }

  Widget _buildLine(double top, double left, double width, double height) {
    return Positioned(
        top: top,
        left: left,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF6DC300),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: height,
          width: width,
        ));
  }
}
