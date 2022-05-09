import 'dart:convert';

import 'package:cube/screen/default_screen.dart';
import 'package:cube/screen/home_screen.dart';
import 'package:cube/screen/login_screen.dart';
import 'package:cube/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';

  static final nameController = TextEditingController();
  static final firstNameController = TextEditingController();
  static final phoneNumberController = TextEditingController();
  static final stateController = TextEditingController();
  static final postalNumberController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  final State<DefaultPage>? instanceDefaultPage;
  const RegisterScreen(this.instanceDefaultPage);
  static int stepIndex = 0;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late List<StatelessWidget> _steps = [
    RegisterScreenStep1(this, widget.instanceDefaultPage),
    RegisterScreenStep2(this),
    RegisterScreenStep3(this)
  ];

  @override
  void initState() {
    super.initState();
    RegisterScreen.stepIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
          padding: EdgeInsets.all(16), child: _steps[RegisterScreen.stepIndex]);
    });
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

    final name = RegisterScreen.nameController.text;
    final firstName = RegisterScreen.firstNameController.text;
    final phoneNumber = RegisterScreen.phoneNumberController.text;
    final state = RegisterScreen.stateController.text;
    final postalNumber = RegisterScreen.postalNumberController.text;
    final email = RegisterScreen.emailController.text;
    final password = RegisterScreen.passwordController.text;

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

class RegisterScreenStep1 extends StatelessWidget {
  final State<DefaultPage>? instanceDefaultScreen;

  final State<RegisterScreen>? instanceRegisterScreen;
  const RegisterScreenStep1(
      this.instanceRegisterScreen, this.instanceDefaultScreen);

  get getInstanceRegisterScreen => this.instanceRegisterScreen;
  get getInstanceDefaultScreen => this.instanceDefaultScreen;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80),
        _buildTtitle(),
        SizedBox(height: 8),
        _buildSubTtitle(),
        SizedBox(height: 30),
        Expanded(
            child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLastNameField(),
              SizedBox(height: 30),
              _buildFirstNameField(),
              SizedBox(height: 30),
              _buildButtonNext(),
              new InkWell(
                child: new Text("Déjà un compte ? Se connecter"),
                onTap: () => getInstanceDefaultScreen!.setState(() {
                  DefaultPage.currentIndex = 3;
                  DefaultPage.currentPage =
                      LoginScreen(getInstanceDefaultScreen);
                }),
              ),
            ],
          ),
        ))
      ],
    );
  }

  Widget _buildTtitle() {
    return Text("Inscription",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 30));
  }

  Widget _buildSubTtitle() {
    return Text("Étape 1 / 3",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 14));
  }

  Widget _buildButtonNext() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(180, 40),
          textStyle: const TextStyle(fontSize: 17),
          onPrimary: Colors.black,
          primary: Color(0xFFEEEEEE),
        ),
        onPressed: () => getInstanceRegisterScreen!.setState(() {
              RegisterScreen.stepIndex = 1;
            }),
        child: Text("Suivant"));
  }

  Widget _buildLastNameField() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: RegisterScreen.nameController,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez renseigner un nom' : null,
            autofocus: true,
            keyboardType: TextInputType.name,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Nom',
            )),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: RegisterScreen.firstNameController,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez renseigner un prénom' : null,
            autofocus: true,
            keyboardType: TextInputType.text,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Prénom',
            )),
      ),
    );
  }
}

class RegisterScreenStep2 extends StatelessWidget {
  final State<RegisterScreen>? instanceRegisterScreen;
  const RegisterScreenStep2(this.instanceRegisterScreen);

  get instanceDefaultPage => this.instanceRegisterScreen;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80),
        _buildTtitle(),
        SizedBox(height: 8),
        _buildSubTtitle(),
        SizedBox(height: 30),
        Expanded(
            child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPhoneNumberField(),
              SizedBox(height: 30),
              _buildStateField(),
              SizedBox(height: 30),
              _buildPostalCodeField(),
              SizedBox(height: 30),
              _buildButtonNext(),
              new InkWell(
                  child: new Text("Déjà un compte ? Se connecter"),
                  onTap: () => instanceDefaultPage!.setState(() {
                        RegisterScreen.stepIndex = 0;
                      })),
            ],
          ),
        ))
      ],
    );
  }

  Widget _buildTtitle() {
    return Text("Inscription",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 30));
  }

  Widget _buildSubTtitle() {
    return Text("Étape 2 / 3",
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontSize: 14));
  }

  Widget _buildButtonNext() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(180, 40),
          textStyle: const TextStyle(fontSize: 17),
          onPrimary: Colors.black,
          primary: Color(0xFFEEEEEE),
        ),
        onPressed: () => instanceDefaultPage!.setState(() {
              RegisterScreen.stepIndex = 2;
            }),
        child: Text("Suivant"));
  }

  Widget _buildPhoneNumberField() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: RegisterScreen.nameController,
            validator: (value) => value!.isEmpty
                ? 'Veuillez renseigner un numéro de téléphone'
                : null,
            autofocus: true,
            keyboardType: TextInputType.phone,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Numéro de téléphone',
            )),
      ),
    );
  }

  Widget _buildStateField() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: RegisterScreen.nameController,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez renseigner un pays' : null,
            autofocus: true,
            keyboardType: TextInputType.text,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Pays',
            )),
      ),
    );
  }

  Widget _buildPostalCodeField() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Color(0xFFEEEEEE),
      child: Center(
        child: TextFormField(
            controller: RegisterScreen.nameController,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez renseigner un code postal' : null,
            autofocus: true,
            keyboardType: TextInputType.number,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Color(0xFFEEEEEE),
              focusColor: Color(0xFFEEEEEE),
              hoverColor: Color(0xFFEEEEEE),
              filled: true,
              border: InputBorder.none,
              hintText: 'Code postal',
            )),
      ),
    );
  }
}

class RegisterScreenStep3 extends StatelessWidget {
  final State<RegisterScreen>? instanceRegisterScreen;
  const RegisterScreenStep3(this.instanceRegisterScreen);

  get instanceDefaultPage => this.instanceRegisterScreen;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Step3"));
  }
}
