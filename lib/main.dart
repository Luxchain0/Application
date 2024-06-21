import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/firebase_options.dart';
import 'package:lux_chain/screens/disclaimer_screen.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: DisclaimerScreen.id,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: MyTheme.lightTheme,
      home: const DisclaimerScreen(),
    );
  }
}
