import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/screens/settings_screen.dart';

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
    double heigh = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(width),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.1, vertical: heigh * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                  child: CircleAvatar(
                    radius: width * 0.1,
                    backgroundColor: Colors.amber,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.getString('firstname')!} ${user.getString('lastname')!}",
                      style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: width * 0.07,
                          height: 1),
                    ),
                    Text(user.getString('email')!),
                  ],
                )
              ],
            ),
            CustomCard(
                icon: Icons.person, text: 'Personal data', onPressed: () => {}),
            CustomCard(
                icon: Icons.notifications,
                text: 'Notification',
                onPressed: () => {}),
            CustomCard(
                icon: Icons.chat_bubble,
                text: 'Assistance',
                onPressed: () => {}),
            CustomCard(
                icon: Icons.question_mark, text: 'FAQ', onPressed: () => {}),
            CustomCard(icon: Icons.book, text: 'Guide', onPressed: () => {}),
            CustomCard(
                icon: Icons.lightbulb, text: 'Hints', onPressed: () => {}),
            CustomCard(
                icon: Icons.translate, text: 'Language', onPressed: () => {}),
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
        // Successo
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
        // Errore
        // Mostra un messaggio di errore
        snackbar(context, 'Server error, please try again later');
      }
    } catch (e) {
      snackbar(context, 'Connection error with the server');
      throw Exception('[FLUTTER] Login Error: $e');
    }
  }
}

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final dynamic onPressed;

  const CustomCard({
    required this.icon,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: const ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size(30, 50))),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Icon(icon),
            ),
            Expanded(
              flex: 8,
              child: Text(text, style: const TextStyle(fontSize: 16)),
            ),
            const Expanded(
              flex: 2,
              child: Icon(Icons.arrow_forward_rounded),
            )
          ],
        ));
  }
}
