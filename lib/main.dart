import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/firebase_options.dart';
import 'package:lux_chain/screens/login.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/route_generator.dart';
import 'package:lux_chain/utilities/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> showLoginPage() async {
    user = await SharedPreferences.getInstance();

    token = user.getString('token');

    return token == null;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: MyTheme.lightTheme,
        home: FutureBuilder<bool>(
          future: showLoginPage(),
          builder: (buildContext, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return const Login();
              }
              return const FrameScreen();
            } else {
              // Return loading screen while reading preferences
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
