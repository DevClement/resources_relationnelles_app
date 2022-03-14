import 'dart:convert';

import 'package:cube/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';
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
    return Scaffold(
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
  }

  Widget _buildButtonConnect() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green)),
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
    final Map<String, dynamic> responseMap = json.decode(response.body);
    // success: false, message: Email ou mot de passe incorrects.}
    print(responseMap['success']);

    if (responseMap['success']) {
      // Save user
      await Utils().saveUser(email, password);
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          responseMap['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  Widget _buildButtonGoToRegister() {
    return ElevatedButton(
        onPressed: () =>
            Navigator.of(context).pushReplacementNamed(RegisterScreen.route),
        child: Text("M'inscrire"));
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(labelText: "Adresse e-mail"),
      validator: (value) =>
          !_isEmail(value!) ? 'Adresse e-mail invalide' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(labelText: "Mot de passe"),
      validator: (value) =>
          value!.isEmpty ? 'Veuillez renseigner un mot de passe' : null,
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
