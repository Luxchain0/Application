import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/utils.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String id = 'EmailVerificationScreen';

  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(width),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 3, right: 3, bottom: 15),
            child: Text(
              'Check your email for the verification link or go back to change your email',
              style: TextStyle(
                fontSize: heigh * 0.024,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                Map<String, String> requestBody = {
                  'email': user.getString('email')!,
                };

                await http.post(
                  Uri.parse('$baseUrl/auth/request_verification_code'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(requestBody),
                );
                snackbar(context, 'Email sent');
              } catch (e) {
                snackbar(context, 'Connection error with the server');
                throw Exception('[FLUTTER] Login Error: $e');
              }
            },
            child: const Text(
              'Resend verification email',
              style: kLabelStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                Map<String, String> requestBody = {
                  'email': user.getString('email')!,
                };

                final response = await http.post(
                  Uri.parse('$baseUrl/auth/check_email'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(requestBody),
                );

                if (response.statusCode == 200) {
                  saveData('verified', true);
                  Navigator.pushNamedAndRemoveUntil(
                      context, FrameScreen.id, (_) => false);
                } else {
                  snackbar(context, 'Email not verified, please verify it');
                }
              } catch (e) {
                snackbar(context, 'Connection error with the server');
                throw Exception('[FLUTTER] Login Error: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'EMAIL VERIFIED',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
