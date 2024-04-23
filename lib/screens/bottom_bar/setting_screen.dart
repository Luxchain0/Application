import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class SettingScreen extends StatefulWidget {
  static const String id = 'SettingScreen';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double heigh = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: Colors.white,
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
                      'NOME e COGNOME',
                      style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: width * 0.07,
                          height: 1),
                    ),
                    const Text('mailDellUtente@gmail.com'),
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
            CustomCard(icon: Icons.logout, text: 'Logout', onPressed: () => {}),
          ],
        ),
      ),
    );
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
