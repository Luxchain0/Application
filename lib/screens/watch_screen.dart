import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/screens/buy_screen.dart';
import 'package:lux_chain/screens/sell_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchScreen extends StatefulWidget {
  static const String id = 'WatchScreen';
  final Watch watch;

  const WatchScreen({required this.watch, super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late Future<List<ShareOnSale>> futureSharesData = Future.value([]);
  late int sharesOwned = 0;
  late double increaseRate = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    futureSharesData = getSharesOfTheWatchOnSell(widget.watch.watchId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    List<FlSpot> chartData = const [
      FlSpot(0, 1),
      FlSpot(1, 3),
      FlSpot(2, 10),
      FlSpot(3, 7),
      FlSpot(4, 12),
      FlSpot(5, 13),
      FlSpot(6, 17),
      FlSpot(7, 15),
      FlSpot(8, 20),
    ];

    return Scaffold(
      appBar: appBar(width),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.watch.modelType.model.brandname,
                          style: TextStyle(
                              color: Colors.black38,
                              height: 1,
                              fontSize: width * 0.07,
                              fontFamily: 'Bebas'),
                        ),
                        Text(
                          widget.watch.modelType.model.modelname,
                          style: TextStyle(
                              color: Colors.black87,
                              height: 1,
                              fontSize: width * 0.08,
                              fontFamily: 'Bebas'),
                        ),
                      ],
                    ),
                    RefreshingButton(watchID: widget.watch.watchId),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black26,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                  ),
                  alignment: Alignment.center,
                  child: FutureBuilder<String>(
                    future: getDownloadURL(widget.watch.imageuri),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Text("Reference: ${widget.watch.modelType.reference}"),
                Text("Seriale: ${widget.watch.watchId}"),
                Text("Year: ${widget.watch.year}"),
                Text("Case material: ${widget.watch.modelType.casematerial}"),
                Text(
                    "Bracelet material: ${widget.watch.modelType.braceletmaterial}"),
                Text(
                    'Initial Price: ${formatAmountFromDouble(widget.watch.initialPrice)} €'),
                Text(
                    'Actual Price: ${formatAmountFromDouble(widget.watch.actualPrice)} €'),
                Text("Conditions: ${widget.watch.condition}"),
                Text("Shares: ${widget.watch.numberOfShares}"),
                RefreshingAdditionalData(watchID: widget.watch.watchId),
                SizedBox(height: width * 0.05),
                const Text(
                  'Description: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.watch.description,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: heigh * 0.03,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 300,
                  child: LineChart(
                    LineChartData(
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(spots: chartData),
                        ]),
                  ),
                ),
                SizedBox(
                  height: heigh * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => {
                        Navigator.pushNamed(context, SellScreen.id,
                            arguments: SellInfo(
                              watchid: widget.watch.watchId,
                              brandName: widget.watch.modelType.model.brandname,
                              modelName: widget.watch.modelType.model.modelname,
                              actualPrice: widget.watch.actualPrice,
                              sharesOwned: sharesOwned,
                              image: getDownloadURL(widget.watch.imageuri),
                              proposalPrice: widget.watch.actualPrice,
                              numberOfShares: widget.watch.numberOfShares,
                            ))
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueAccent),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(width * 0.25, width * 0.08))),
                      child: const Text(
                        'Sell',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: heigh * 0.02,
                ),
                Text(
                  'Best shares for sale: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: heigh * 0.02),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Price share',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                        child: Text(
                          'n° shares',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(flex: 2, child: SizedBox())
                  ],
                ),
                FutureBuilder<List<ShareOnSale>>(
                    future: futureSharesData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        List<ShareOnSale> sharesOnSale = snapshot.data!;
                        return sharesOnSale.isNotEmpty
                            ? Column(
                                children: sharesOnSale.map(
                                  (share) {
                                    return CustomRowForQuote(
                                        width: width,
                                        numberOfQuotes: share.shareCount,
                                        quotePrice: share.price,
                                        buyInfo: BuyInfo(
                                          watchid: widget.watch.watchId,
                                          brandName: widget
                                              .watch.modelType.model.brandname,
                                          modelName: widget
                                              .watch.modelType.model.modelname,
                                          actualPrice: widget.watch.actualPrice,
                                          sharesOnSale:
                                              widget.watch.numberOfShares,
                                          image: getDownloadURL(
                                              widget.watch.imageuri),
                                          proposalPrice: share.price,
                                          numberOfShares: share.shareCount,
                                        ));
                                  },
                                ).toList(),
                              )
                            : const SizedBox();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const SizedBox();
                      }
                    })
              ]),
        )),
      ),
    );
  }
}

class CustomRowForQuote extends StatelessWidget {
  final double width;
  final double quotePrice;
  final int numberOfQuotes;
  final BuyInfo buyInfo;

  const CustomRowForQuote({
    super.key,
    required this.width,
    required this.numberOfQuotes,
    required this.quotePrice,
    required this.buyInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  '${formatAmountFromDouble(quotePrice)} €',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              numberOfQuotes.toString(),
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 2,
          child: CustomButton(
            screenWidth: width,
            backgorundColor: const Color.fromARGB(255, 17, 45, 68),
            textColor: Colors.white,
            text: 'Buy',
            buyInfo: buyInfo,
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final double screenWidth;
  final Color backgorundColor;
  final Color textColor;
  final String text;
  final BuyInfo buyInfo;

  const CustomButton(
      {super.key,
      required this.screenWidth,
      required this.backgorundColor,
      required this.textColor,
      required this.text,
      required this.buyInfo});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => {
        Navigator.pushNamed(context, BuyScreen.id, arguments: buyInfo),
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgorundColor),
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
          minimumSize: MaterialStateProperty.all<Size>(
              Size(screenWidth * 0.05, screenWidth * 0.08)),
          maximumSize: MaterialStateProperty.all<Size>(
              Size(screenWidth * 0.05, screenWidth * 0.08))),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RefreshingButton extends StatefulWidget {
  final int watchID;

  const RefreshingButton({required this.watchID, super.key});

  @override
  _RefreshingButtonState createState() => _RefreshingButtonState();
}

class _RefreshingButtonState extends State<RefreshingButton> {
  late Future<bool> isFavourite = Future.value(false);

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
      isFavourite = getFavorite(userId, widget.watchID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          Future<SharedPreferences> userFuture = getUserData();
          SharedPreferences user = await userFuture;

          // Assume that you have a specific key in SharedPreferences
          int userId = user.getInt('accountid') ?? 0;
          bool isFav = await isFavourite;
          if (isFav) {
            APIStatus removeStatus =
                await removeFromFavourite(userId, widget.watchID);
            if (removeStatus == APIStatus.success) {
              setState(() {
                isFavourite = Future.value(false);
              });
            }
          } else {
            APIStatus addStatus = await addToFavourite(userId, widget.watchID);
            if (addStatus == APIStatus.success) {
              setState(() {
                isFavourite = Future.value(true);
              });
            }
          }
        },
        icon: FutureBuilder<bool>(
          future: isFavourite,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              bool isFav = snapshot.data!;
              return Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_outlined,
                color: Colors.red,
              );
            } else if (snapshot.hasError) {
              return const Icon(Icons.error);
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}

class RefreshingAdditionalData extends StatefulWidget {
  final int watchID;

  const RefreshingAdditionalData({required this.watchID, super.key});

  @override
  _RefreshingAdditionalDataState createState() =>
      _RefreshingAdditionalDataState();
}

class _RefreshingAdditionalDataState extends State<RefreshingAdditionalData> {
  late Future<bool> isFavourite = Future.value(false);
  late int sharesOwned = 0;
  late double increaseRate = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    Future<SharedPreferences> userFuture = getUserData();
    SharedPreferences user = await userFuture;

    int userId = user.getInt('accountid') ?? 0;

    getWatchAdditionalData(userId, widget.watchID).then((value) {
      setState(() {
        sharesOwned = value.sharesOwned;
        increaseRate = value.increaseRate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shares owned: $sharesOwned"),
        Row(
          children: [
            const Text('Rate: '),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Colors.lightGreen),
              child: Text("$increaseRate%"),
            ),
          ],
        ),
      ],
    );
  }
}
