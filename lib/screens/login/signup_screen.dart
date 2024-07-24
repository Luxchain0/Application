import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lux_chain/screens/login/email_verification_screen.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/utils.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  bool _showPassword = false;
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _buildFirstNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'First Name',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: firstnameController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your First Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastnameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Last Name',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: lastnameController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your Last Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Birth Date',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: birthdateController,
            readOnly: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your Birth Date',
              hintStyle: kHintTextStyle,
            ),
            onTap: () => datePicker(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: !_showPassword,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShowPasswordBox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _showPassword,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _showPassword = value!;
                });
              },
            ),
          ),
          const Text(
            'Show Password',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (firstnameController.text.isEmpty) {
            snackbar(context, 'Firstname is Missing');
          } else if (lastnameController.text.isEmpty) {
            snackbar(context, 'Lastname is Missing');
          } else if (birthdateController.text.isEmpty) {
            snackbar(context, 'Birthdate is Missing');
          } else if (emailController.text.isEmpty) {
            snackbar(context, 'Email is Missing');
          } else if (passwordController.text.isEmpty) {
            snackbar(context, 'Password is Missing');
          } else {
            try {
              Map<String, String> requestBody = {
                'firstname': firstnameController.text,
                'lastname': lastnameController.text,
                "birthdate": birthdateController.text,
                'email': emailController.text,
                'password': passwordController.text,
              };

              final response = await http.post(
                Uri.parse('$baseUrl/auth/signup'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(requestBody),
              );

              Map<String, dynamic> myMap = jsonDecode(response.body);
              if (response.statusCode == 200) {
                for (var v in myMap['user'].entries) {
                  saveData(v.key, v.value);
                }
                token = myMap['jwt_token'];
                saveData('token', token);
                saveData('verified', false);
                Navigator.pushNamed(context, EmailVerificationScreen.id);
              } else if (response.statusCode == 404) {
                snackbar(context, 'Please insert a valid email');
              } else if (response.statusCode == 409) {
                if (myMap['error']['meta']['target'].contains('email')) {
                  snackbar(context,
                      'User already registered, please proceed to login');
                  Navigator.pop(context);
                } else if (myMap['error']['meta']['target']
                    .contains('username')) {
                  snackbar(context, 'Username already used by another account');
                } else if (myMap['error']['meta']['target']
                    .contains('phonenr')) {
                  snackbar(context,
                      'Phone number already used, have you already created an account?');
                }
              } else {
                snackbar(context, 'Server error, please try again later');
              }
            } catch (e) {
              snackbar(context, 'Connection error with the server');
              throw Exception('[FLUTTER] SignUpScreen Error: $e');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  datePicker(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 191, 223, 250)),
            ),
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: height * 0.05,
                  vertical: height * 0.015,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.014),
                    _buildFirstNameTF(),
                    SizedBox(height: height * 0.014),
                    _buildLastnameTF(),
                    SizedBox(height: height * 0.014),
                    _buildBirthDateTF(),
                    SizedBox(height: height * 0.014),
                    _buildEmailTF(),
                    SizedBox(height: height * 0.014),
                    _buildPasswordTF(),
                    SizedBox(height: height * 0.014),
                    _buildShowPasswordBox(),
                    SizedBox(height: height * 0.001),
                    _buildSignUpBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
