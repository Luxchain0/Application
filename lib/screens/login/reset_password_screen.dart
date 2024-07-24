import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/utils.dart';
//import 'package:google_sign_in/google_sign_in.dart';

const String authURL = '$baseUrl/auth';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'ResetPasswordScreen';
  final String email;

  const ResetPasswordScreen({required this.email, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  bool _showPassword = false;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _buildResetCodeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Reset Code',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
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
              hintText: 'Enter your reset code',
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
          'New Password',
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
              hintText: 'Enter your new Password',
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

  Widget _buildConfirmBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (codeController.text.isEmpty) {
            snackbar(context, 'Code missing');
          } else if (passwordController.text.isEmpty) {
            snackbar(context, 'New password missing');
          } else {
            try {
              Map<String, String> requestBody = {
                'code': codeController.text,
                'new_password': passwordController.text,
                'email': widget.email,
              };

              final response = await http
                  .post(
                    Uri.parse('$authURL/change_password'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(requestBody),
                  );

              if (response.statusCode == 200) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Password changed successfully'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (response.statusCode == 401) {
                snackbar(context, 'Incorrect reset code');
              } else {
                snackbar(context, response.body);
              }
            } catch (e) {
              snackbar(context, 'Connection error with the server');
              throw Exception('[FLUTTER] Login Error: $e');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'CONFIRM',
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
//    double height = SizeConfig.screenH!;
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    _buildResetCodeTF(),
                    const SizedBox(height: 30.0),
                    _buildPasswordTF(),
                    const SizedBox(height: 10.0),
                    _buildShowPasswordBox(),
                    const SizedBox(height: 10.0),
                    _buildConfirmBtn(),
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

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
