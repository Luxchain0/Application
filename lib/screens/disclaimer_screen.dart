import 'package:flutter/material.dart';
import 'package:lux_chain/screens/login_screen.dart';
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

  // Method to load the shared preference data
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
            child: Text(
              'Disclaimer',
              style: TextStyle(
                fontSize: heigh * 0.024,
                height: 1.2,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
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
