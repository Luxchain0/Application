import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/firebase_options.dart';
import 'package:lux_chain/screens/login/disclaimer_screen.dart';
import 'package:lux_chain/utilities/route_generator.dart';
import 'package:lux_chain/utilities/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: DisclaimerScreen.id,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: MyTheme.lightTheme,
      home: const DisclaimerScreen(),
    );
  }
}
