import 'package:flutter/material.dart';
import 'package:lux_chain/screens/buy_screen.dart';
//import 'package:lux_chain/screens/home_screen.dart';
import 'package:lux_chain/screens/market_screen.dart';
import 'package:lux_chain/screens/sell_screen.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/screens/wallet_screen.dart';
import 'package:lux_chain/screens/watch_tinder_screen.dart';
import 'package:lux_chain/utilities/size_config.dart';

class FrameScreen extends StatefulWidget {
  static const String id = 'FrameScreen';
  const FrameScreen({super.key});

  @override
  State<FrameScreen> createState() => _FrameScreenState();
}

class _FrameScreenState extends State<FrameScreen> {
  int currentPageIndex = 0;
  List<Widget> pages = const [
    WalletScreen(),
    MarketScreen(),
    WatchScreen(watchID: 1), //Le quote che hai in vendita
    WatchTinderScreen(), //Ultime quote che hai comprato o venduto
    BuyScreen(), //Preferiti
    SellScreen()
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;

    return Scaffold(
        appBar: appBar(width),
        body: pages[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          animationDuration: const Duration(seconds: 1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.wallet_rounded),
              label: 'Boh',
            ),
            NavigationDestination(
                icon: Icon(Icons.store_rounded), label: 'Market'),
            NavigationDestination(
                icon: Icon(Icons.shopping_bag_rounded), label: 'Shopping bag'),
            NavigationDestination(
                icon: Icon(Icons.alarm_outlined), label: 'History'),
            NavigationDestination(
                icon: Icon(Icons.star_rounded), label: 'Favourites'),
            NavigationDestination(
                icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) => {
            setState(() {
              currentPageIndex = index;
            }),
          },
        ));
  }
}

appBar(width) {
  return AppBar(
      elevation: 40,
      title: Row(
        children: [
          SizedBox(
              width: width * 0.1,
              child: Image.asset('assets/images/LogoLUXCHAIN.png')),
          SizedBox(
            width: width * 0.05,
          ),
          Text(
            'Luxchain'.toUpperCase(),
            style: TextStyle(fontFamily: 'Bebas', fontSize: width * 0.08),
          ),
        ],
      ));
}
