import 'package:flutter/material.dart';
import 'package:lux_chain/screens/login_screen.dart';
import 'package:lux_chain/screens/personal_data_screen.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'SettingsScreen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
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
              icon: Icons.person,
              text: 'Personal data',
              onPressed: () => {
                Navigator.of(context).pushNamed(PersonalDataScreen.id),
              },
            ),
            const SizedBox(height: 30.0),
            CustomCard(
              icon: Icons.question_mark,
              text: 'FAQ',
              onPressed: () => {},
            ),
            const SizedBox(height: 30.0),
            CustomCard(
              icon: Icons.bug_report,
              text: 'Report a bug',
              onPressed: () => {},
            ),
            const SizedBox(height: 30.0),
            CustomCard(
              icon: Icons.logout,
              text: 'Logout',
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'This action will bring you to the LoginIn page.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Nope'),
                      ),
                      TextButton(
                        onPressed: () {
                          _logout(context);
                        },
                        child: const Text('Yep'),
                      ),
                    ],
                  ),
                ),
              },
            ),
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

userInfo(width) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
                fontFamily: 'Bebas', fontSize: width * 0.07, height: 1),
          ),
          Text(user.getString('email')!),
        ],
      )
    ],
  );
}

_logout(context) async {
  await user.clear();
  token = '';
  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (_) => false);
}
