import 'package:flutter/material.dart';
import 'package:lux_chain/screens/login/login_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerScreen extends StatefulWidget {
  static const String id = 'DisclaimerScreen';
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    user = await SharedPreferences.getInstance();
    token = user.getString('token');
  }

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
            margin:
                const EdgeInsets.only(left: 3, right: 4, top: 15, bottom: 20),
            child: Text.rich(
              TextSpan(
                text: 'THE NEW PLATFORM FOR ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: heigh * 0.05,
                  height: 1,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'LUXURY ITEMS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(
                horizontal: 15), 
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, 
              children: [
                Text(
                  'Disclaimer',
                  style: TextStyle(
                    fontSize: heigh * 0.024,
                    height: 1.2,
                  ),
                ),
                const SizedBox( height: 10),
                Text(
                  'This application is a demo, and all transactions and assets are purely virtual and fictitious. '
                  'Although the euro (€) currency symbol is used within the application, no real money transactions are involved, '
                  'and the transactions hold no actual monetary value.',
                  style: TextStyle(
                    fontSize: heigh *
                        0.014,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await accessLog();
              if (user.getBool("verified") == true) {
                Navigator.pushNamedAndRemoveUntil(
                    context, FrameScreen.id, (_) => false);
              } else {
                Navigator.pushNamed(context, LoginScreen.id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'OK',
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
