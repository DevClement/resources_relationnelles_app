import 'dart:convert';

import 'package:cube/screen/home_screen.dart';
import 'package:cube/screen/login_screen.dart';
import 'package:cube/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 10),
                _buildTextField(_nameController, 'Nom', 'Nom incorrect',
                    TextInputType.text, false),
                SizedBox(height: 10),
                _buildTextField(_firstNameController, 'Prénom',
                    'Prénom incorrect', TextInputType.text, false),
                SizedBox(height: 10),
                _buildNumberField(_phoneNumberController, 'Numéro de téléphone',
                    'Numéro incorect', TextInputType.phone),
                SizedBox(height: 10),
                _buildTextField(_stateController, 'Pays', 'Pays incorrect',
                    TextInputType.text, false),
                SizedBox(height: 10),
                _buildNumberField(_postalNumberController, 'Code postal',
                    'Code postal incorrect', TextInputType.number),
                SizedBox(height: 10),
                _buildTextField(_emailController, 'Email', 'Email incorrect',
                    TextInputType.emailAddress, false),
                SizedBox(height: 10),
                _buildTextField(_passwordController, 'Mot de passe',
                    'Mot de passe invalid', TextInputType.text, true),
                SizedBox(height: 10),
                _buildButtonRegister(),
                SizedBox(height: 10),
                _buildLine(),
                SizedBox(height: 20),
                Text('Déjà un compte ?'),
                SizedBox(height: 10),
                _buildButtonGoToLogin()
              ],
            ),
          ),
        )));
  }

  Widget _buildButtonRegister() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green)),
        onPressed: () => _validate(),
        child: Text("M'inscrire"));
  }

  void _validate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final firstName = _passwordController.text;
    final phoneNumber = _emailController.text;
    final state = _passwordController.text;
    final postalNumber = _emailController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await Utils().postData('api/users/', {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': name,
      'country': state,
      'phone_number': phoneNumber,
      'postal_number': postalNumber
    });

    final Map<String, dynamic> responseMap = json.decode(response.body);
    // success: false, message: Email ou mot de passe incorrects.}

    if (responseMap['insertId'] != null) {
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

  Widget _buildButtonGoToLogin() {
    return ElevatedButton(
        onPressed: () =>
            Navigator.of(context).pushReplacementNamed(LoginScreen.route),
        child: Text("Me connecter"));
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String errorLabel, TextInputType type, bool obscure) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? errorLabel : null,
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label,
      String errorLabel, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? errorLabel : null,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
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
