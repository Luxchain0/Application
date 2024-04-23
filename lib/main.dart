import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/route_generator.dart';
import 'package:lux_chain/utilities/theme_data.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: FrameScreen.id,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: MyTheme.lightTheme,
      home: const FrameScreen(),
    );
  }
}
