import 'dart:convert';

import 'package:cube/screen/default_screen.dart';
import 'package:cube/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';

  final State<DefaultPage>? instanceDefaultPage;
  const LoginScreen(this.instanceDefaultPage);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    autoConnect();
  }

  void autoConnect() async {
    final data = await SharedPreferences.getInstance();

    final email = data.getString('email') ?? null;
    final password = data.getString('password') ?? null;

    print(email.toString() + "  " + password.toString());

    if (email != null && password != null) {
      _emailController.text = email;
      _passwordController.text = password;
      print(email + "  " + password + "  GO");
      _validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            _buildTtitle(),
            SizedBox(height: 30),
            Expanded(
                child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEmailField(constraints),
                    SizedBox(height: 30),
                    _buildPasswordField(constraints),
                    SizedBox(height: 30),
                    _buildButtonConnect(),
                    new InkWell(
                      child: new Text("Pas de compte ? S'inscrire"),
                      onTap: () => widget.instanceDefaultPage!.setState(() {
                        DefaultPage.currentPage =
                            RegisterScreen(widget.instanceDefaultPage);
                      }),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      );
    });

    /*Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 40),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 20),
                _buildButtonConnect(),
                SizedBox(height: 30),
                _buildLine(),
                SizedBox(height: 20),
                Text('Pas encore de compte ?'),
                SizedBox(height: 10),
                _buildButtonGoToRegister()
              ],
            ),
          ),
        ));
        */
  }

  Widget _buildTtitle() {
    return Text("Connexion",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 30));
  }

  Widget _buildButtonConnect() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(180, 40),
          textStyle: const TextStyle(fontSize: 17),
          onPrimary: Colors.black,
          primary: Color(0xFFEEEEEE),
        ),
        onPressed: () => _validate(),
        child: Text("Me connecter"));
  }

  void _validate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await Utils()
        .postData('api/users/login', {'email': email, 'password': password});
    print(response.body);
    final Map<String, dynamic> responseMap = json.decode(response.body);
    // success: false, message: Email ou mot de passe incorrects.}
    print(responseMap['success']);

    if (responseMap['success']) {
      // Save user
      await Utils().saveUser(email, password);
      widget.instanceDefaultPage!.setState(() {
        DefaultPage.currentIndex = 0;
        DefaultPage.currentPage = HomeScreen();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          responseMap['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  Widget _buildEmailField(BoxConstraints constraints) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: _emailController,
            validator: (value) =>
                !_isEmail(value!) ? 'Adresse e-mail invalide' : null,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Adresse e-mail',
            )),
      ),
    );
  }

  Widget _buildPasswordField(BoxConstraints constraints) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez renseigner un mot de passe' : null,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Mot de passe',
            )),
      ),
    );
  }

  Widget _buildLine() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 70),
        child: SizedBox(
            height: 1,
            child: Container(decoration: BoxDecoration(color: Colors.black))));
  }

  Widget _buildLogo() {
    return Center(
        child: SizedBox(
      width: 150,
      child: Image.asset('assets/images/logo_cube.jpg'),
    ));
  }

  bool _isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
