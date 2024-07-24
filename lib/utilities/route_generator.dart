import 'package:flutter/material.dart';
import 'package:lux_chain/screens/settings/FAQ_screen.dart';
import 'package:lux_chain/screens/buy_screen.dart';
import 'package:lux_chain/screens/login/disclaimer_screen.dart';
import 'package:lux_chain/screens/login/email_verification_screen.dart';
import 'package:lux_chain/screens/login/login_screen.dart';
import 'package:lux_chain/screens/login/signup_screen.dart';
import 'package:lux_chain/screens/bottom_menu/market_screen.dart';
import 'package:lux_chain/screens/modify_on_sale_share.dart';
import 'package:lux_chain/screens/settings/personal_data_screen.dart';
import 'package:lux_chain/screens/settings/report_bug_screen.dart';
import 'package:lux_chain/screens/login/reset_password_screen.dart';
import 'package:lux_chain/screens/sell_screen.dart';
import 'package:lux_chain/screens/bottom_menu/wallet_screen.dart';
import 'package:lux_chain/screens/bottom_menu/watch_screen.dart';
import 'package:lux_chain/screens/home_screen.dart';
import 'package:lux_chain/screens/settings/settings_screen.dart';
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
      case DisclaimerScreen.id:
        return MaterialPageRoute(builder: (_) => const DisclaimerScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case ResetPasswordScreen.id:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: args));
        }
        break;
      case SignUpScreen.id:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case EmailVerificationScreen.id:
        return MaterialPageRoute(
            builder: (_) => const EmailVerificationScreen());
      case SettingsScreen.id:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case PersonalDataScreen.id:
        return MaterialPageRoute(builder: (_) => const PersonalDataScreen());
      case FAQScreen.id:
        return MaterialPageRoute(builder: (_) => const FAQScreen());
      case ReportBugScreen.id:
        return MaterialPageRoute(builder: (_) => ReportBugScreen());
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
