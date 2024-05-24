//TODO

import 'package:flutter/material.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  static const String id = 'HistoryScreen';

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<HistoryScreen> {
  late Future<List<Trade>> futureTradeHistory = Future.value([]);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    Future<SharedPreferences> userFuture = getUserData();
    SharedPreferences user = await userFuture;

    // Assume that you have a specific key in SharedPreferences
    int userId = user.getInt('accountid') ?? 0;

    setState(() {
      futureTradeHistory = getTradeHistory(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: heigh * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                  child: Text(
                    'Trade History',
                    style: TextStyle(
                        color: Colors.black87,
                        height: 1,
                        fontSize: width * 0.1,
                        fontFamily: 'Bebas'),
                  ),
                ),
                FutureBuilder<List<Trade>>(
                  future: futureTradeHistory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!
                            .map((trade) => CustomCard(
                                  screenWidth: width,
                                  trade: trade,
                                  imgUrl: getDownloadURL(trade.imageuri),
                                  shareTraded: trade.sharesTraded,
                                  buySell: trade.type,
                                  price: trade.price,
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return const SizedBox(); // Placeholder widget when no data is available
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.screenWidth,
    required this.trade,
    required this.imgUrl,
    required this.shareTraded,
    required this.buySell,
    required this.price,
  });

  final double screenWidth;
  final Trade trade;
  final Future<String> imgUrl;
  final int shareTraded;
  final String buySell;
  final double price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              Navigator.of(context).pushNamed(WatchScreen.id,
                  arguments: Watch(
                      watchId: trade.watchId,
                      condition: trade.condition,
                      numberOfShares: trade.numberOfShares,
                      initialPrice: trade.initialPrice,
                      actualPrice: trade.actualPrice,
                      dialcolor: trade.dialcolor,
                      year: trade.year,
                      imageuri: trade.imageuri,
                      description: trade.description,
                      modelTypeId: trade.modelTypeId,
                      modelType: trade.modelType))
            },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black26,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(3, 3), // Shadow position
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Row(children: [
            FutureBuilder<String>(
              future: imgUrl,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    child: Image.network(
                      snapshot.data!,
                      width: screenWidth * 0.29,
                      height: screenWidth * 0.29,
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Text('Image not found');
                }
              },
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trade.modelType.model.modelname,
                  style: TextStyle(
                      color: Colors.black38,
                      height: 1,
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'Bebas'),
                ),
                Text(
                  trade.modelType.model.brandname,
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: screenWidth * 0.055,
                      fontFamily: 'Bebas'),
                ),
                Text('Reference: ${trade.modelType.reference}'),
                Text('Serial: ${trade.watchId}'),
                SizedBox(height: screenWidth * 0.02),
                Text('Traded shares: $shareTraded'),
                Text('Trade type: $buySell'),
                Text('Total: ${formatAmountFromDouble(price * shareTraded)}€'),
              ],
            )
          ]),
        ));
  }
}
