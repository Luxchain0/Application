import 'package:flutter/material.dart';
import 'package:lux_chain/screens/history_screen.dart';
import 'package:lux_chain/screens/market_screen.dart';
import 'package:lux_chain/screens/my_shares_screen.dart';
import 'package:lux_chain/screens/settings_screen.dart';
import 'package:lux_chain/screens/wallet_screen.dart';
import 'package:lux_chain/screens/favourites_screen.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences user;
String? token;

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
    MySharesScreen(), //Le quote che hai in vendita
    HistoryScreen(), //Ultime quote che hai comprato o venduto
    FavouritesScreen(), //Preferiti
    SettingsScreen(),
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
                icon: Icon(Icons.wallet_rounded), label: 'Wallet'),
            NavigationDestination(
                icon: Icon(Icons.store_rounded), label: 'Market'),
            NavigationDestination(
                icon: Icon(Icons.shopping_bag_rounded), label: 'Shopping bag'),
            NavigationDestination(
                icon: Icon(Icons.alarm_outlined), label: 'History'),
            NavigationDestination(
                icon: Icon(Icons.favorite_rounded), label: 'Favourites'),
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

// method for saving data to shared preferences
void saveData(String key, dynamic value) async {
  print('Saving $key: $value');
  if (value is String) {
    await user.setString(key, value);
  } else if (value is int) {
    await user.setInt(key, value);
  } else if (value is double) {
    await user.setDouble(key, value);
  } else if (value is bool) {
    await user.setBool(key, value);
  } else if (value is List<String>) {
    await user.setStringList(key, value);
  }
}

void snackbar(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 49, 115, 168),
      duration: const Duration(milliseconds: 10000),
    ),
  );
}

const kHintTextStyle = TextStyle(
  color: Colors.white54,
);

const kLabelStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
