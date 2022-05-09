import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static final String route = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
            SizedBox(height: 30),
            _buildSearchButton()
          ],
        ),
      );
    });
  }

  Widget _buildSearchButton() {
    return Container(
      width: double.infinity,
      height: 40,
      color: Colors.white,
      child: Center(
        child: TextField(
          autofocus: true,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Votre recherche',
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
              )),
        ),
      ),
    );
  }

  Widget _buildTtitle() {
    return Text("Rechercher",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 30));
  }
}
