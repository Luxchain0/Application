import 'package:flutter/material.dart';
import 'package:lux_chain/screens/buy_screen.dart';
import 'package:lux_chain/screens/home_screen.dart';
import 'package:lux_chain/screens/market_screen.dart';
import 'package:lux_chain/screens/model_page.dart';
import 'package:lux_chain/screens/serial_screen.dart';
import 'package:lux_chain/screens/setting_screen.dart';
import 'package:lux_chain/screens/sell_screen.dart';
import 'package:lux_chain/screens/wallet_screen.dart';
import 'package:lux_chain/screens/wallet_timeline_screen.dart';
import 'package:lux_chain/screens/watch_tinder_screen.dart';
import 'package:lux_chain/utilities/frame.dart';
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
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          SettingScreen.id: (context) => const SettingScreen(),
          WatchTinderScreen.id: (context) => const WatchTinderScreen(),
          BuyScreen.id: (context) => const BuyScreen(),
          SellScreen.id: (context) => const SellScreen(),
          WalletScreen.id: (context) => const WalletScreen(),
          WalletTimelineScreen.id: (context) => const WalletTimelineScreen(),
          ModelScreen.id: (context) => const ModelScreen(),
          MarketScreen.id: (context) => const MarketScreen(),
          FrameScreen.id: (context) => const FrameScreen(),
          SerialScreen.id: (context) => const SerialScreen(),
          
        },
        theme: MyTheme.lightTheme,
        home: const FrameScreen(),
      );
  }
}