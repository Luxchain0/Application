import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:http/http.dart' as http;

const String apiURL = 'https://luxchain-flame.vercel.app/api';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.get(
                    Uri.parse('$apiURL/auth/login/google'),
                  );

                  if (response.statusCode == 200) {
                    // cambia pagina
                  } else {
                    throw Exception(
                        '[FLUTTER] Google Login http Error: $response.statusMessage');
                  }
                } catch (e) {
                  throw Exception('[FLUTTER] Google Login Error: $e');
                }
              },
              child: const Text('Google Login'),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement button 2 functionality
              },
              child: const Text('Login 2'),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement button 3 functionality
              },
              child: const Text('Login 3'),
            ),
          ],
        ),
      ),
    );
  }
}
