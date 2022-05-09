import 'package:cube/screen/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String route = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
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
                    height: 438,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        _buildDot(20, 0),
                        _buildLine(40, 11, 3, 438),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          'Dernières ressources',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 25),
                        _buildBoxRessource(constraints),
                        SizedBox(height: 25),
                        _buildBoxRessource(constraints),
                        SizedBox(height: 25),
                        _buildBoxRessource(constraints),
                      ]),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 25,
                    height: 242,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        _buildDot(20, 0),
                        _buildLine(40, 11, 3, 202),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          'Derniers utilisateurs inscrits',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 25),
                        _buildBoxUser(constraints),
                        SizedBox(height: 25),
                        _buildBoxUser(constraints),
                        SizedBox(height: 25),
                        _buildBoxUser(constraints),
                      ]),
                )
              ],
            )
          ],
        ),
      );
    });
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

  Widget _buildBoxRessource(BoxConstraints constraints) {
    return Container(
      color: Color(0xFFEEEEEE),
      width: (constraints.maxWidth * 0.01) * 100 + (25 - 106),
      child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Lorom Impsum',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 14),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam facilisis semper tellus id varius.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }

  Widget _buildBoxUser(BoxConstraints constraints) {
    return Container(
      color: Color(0xFFEEEEEE),
      width: (constraints.maxWidth * 0.01) * 100 + (25 - 106),
      child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Tom P.',
                style: TextStyle(fontSize: 18),
              ),
            ],
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
