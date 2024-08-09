import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lux_chain/screens/login/reset_password_screen.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/screens/settings/settings_screen.dart';
import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/utils.dart';

const String authURL = '$baseUrl/auth';

class PersonalDataScreen extends StatefulWidget {
  static const String id = 'PersonalDataScreen';
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(width),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(height: 10.0),
            userInfo(width),
            const SizedBox(height: 30.0),
            CustomCard(
              title: 'First name:',
              content: user.getString('firstname')!,
            ),
            const SizedBox(height: 30.0),
            CustomCard(
              title: 'Last name:',
              content: user.getString('lastname')!,
            ),
            const SizedBox(height: 30.0),
            CustomCard(
              title: 'Birthdate:',
              content: user
                  .getString('birthdate')!
                  .substring(0, user.getString('birthdate')!.indexOf('T')),
            ),
            const SizedBox(height: 30.0),
            CustomCard(
              title: 'Email:',
              content: user.getString('email')!,
            ),
            const SizedBox(height: 50.0),
            OutlinedButton(
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(30, 50))),
              onPressed: () async {
                _changePassword(user.getString('email')!, context);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child:
                        Text('Change password', style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.arrow_forward_rounded),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(String email, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse("$authURL/reset_pwd_code"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
                'An email with the password reset code has been sent'),
            content: const Text('Insert it in the next screen'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ResetPasswordScreen.id,
                      arguments: email);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        snackbar(context, 'Server error, please try again later');
      }
    } catch (e) {
      snackbar(context, 'Connection error with the server');
      throw Exception('[FLUTTER] Login Error: $e');
    }
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String content;

  const CustomCard({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(content),
          ),
        ),
      ],
    );
  }
}
