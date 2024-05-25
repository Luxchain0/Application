import 'package:flutter/material.dart';
import 'package:lux_chain/screens/buy_screen.dart';
import 'package:lux_chain/screens/login_screen.dart';
import 'package:lux_chain/screens/market_screen.dart';
import 'package:lux_chain/screens/modify_on_sale_share.dart';
import 'package:lux_chain/screens/personal_data_screen.dart';
import 'package:lux_chain/screens/sell_screen.dart';
import 'package:lux_chain/screens/wallet_screen.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/screens/home_screen.dart';
import 'package:lux_chain/screens/settings_screen.dart';
import 'package:lux_chain/screens/wallet_timeline_screen.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/models.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recupera gli argomenti passati, se ci sono
    final args = settings.arguments;

    switch (settings.name) {
      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case SettingsScreen.id:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case PersonalDataScreen.id:
        return MaterialPageRoute(builder: (_) => const PersonalDataScreen());
      case BuyScreen.id:
        if (args is BuyInfo) {
          return MaterialPageRoute(builder: (_) => BuyScreen(buyInfo: args));
        }
        break;
      case SellScreen.id:
        if (args is SellInfo) {
          return MaterialPageRoute(builder: (_) => SellScreen(sellInfo: args));
        }
        break;
      case WalletScreen.id:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case WalletTimelineScreen.id:
        return MaterialPageRoute(builder: (_) => const WalletTimelineScreen());
      // case ModelScreen.id:
      //   return MaterialPageRoute(builder: (_) => const ModelScreen());
      case MarketScreen.id:
        return MaterialPageRoute(builder: (_) => const MarketScreen());
      case FrameScreen.id:
        return MaterialPageRoute(builder: (_) => const FrameScreen());
      case ModifyOnSaleShareScreen.id:
        if (args is ModifySharesOnSale) {
          return MaterialPageRoute(
              builder: (_) =>
                  ModifyOnSaleShareScreen(modifySharesOnSale: args));
        }
        break;
      case WatchScreen.id:
        if (args is Watch) {
          return MaterialPageRoute(builder: (_) => WatchScreen(watch: args));
        } else {
          print("args is not Watch");
        }
        break;
      default:
        // Se la route non è stata trovata, restituisci una route di errore
        return _errorRoute();
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    // Route di errore predefinita
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
