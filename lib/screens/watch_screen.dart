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

class WatchScreen extends StatefulWidget {
  static const String id = 'WatchScreen';
  final int watchID;
  const WatchScreen({required this.watchID, super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late Future<Watch> futureWatchData;
  late Future<List<ShareOnSale>> futureSharesData;

  @override
  void initState() {
    super.initState();
    futureWatchData = getWatchByWatchId(widget.watchID);
    futureSharesData = getSharesOfTheWatchOnSell(widget.watchID);
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
          child: FutureBuilder<Watch>(
            future: futureWatchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                Watch watch = snapshot.data!;
                return Padding(
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
                                  watch.modelType.model.brandname,
                                  style: TextStyle(
                                      color: Colors.black38,
                                      height: 1,
                                      fontSize: width * 0.07,
                                      fontFamily: 'Bebas'),
                                ),
                                Text(
                                  watch.modelType.model.modelname,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      height: 1,
                                      fontSize: width * 0.08,
                                      fontFamily: 'Bebas'),
                                ),
                              ],
                            ),
                            RefreshingButton(watchID: widget.watchID),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                          ),
                          alignment: Alignment.center,
                          child: FutureBuilder<String>(
                            future: getDownloadURL(watch.imageuri),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasData) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(7)),
                                  child: Image.network(
                                    snapshot.data!,
                                    fit: BoxFit
                                        .cover, // L'immagine si espanderà per riempire il contenitore
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
                        Text("Referenza: ${watch.modelType.reference}"),
                        Text("Seriale: ${watch.watchId}"),
                        Text("Anno: ${watch.year}"),
                        Text(
                            "Materiale cassa: ${watch.modelType.casematerial}"),
                        Text(
                            "Materiale bracciale: ${watch.modelType.braceletmaterial}"),
                        Text(
                            'Prezzo di listino: ${formatAmountFromDouble(watch.initialPrice)} €'),
                        Text(
                            'Prezzo medio: ${formatAmountFromDouble(watch.actualPrice)} €'),
                        Text(
                            'Prezzo di vendita proposto: ${formatAmountFromDouble(watch.actualPrice)} €'),
                        Text("Numero di quote: ${watch.numberOfShares}"),
                        Text("Condizione orlogio: ${watch.condition}"),
                        Row(
                          children: [
                            const Text('Variazione percentuale: '),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  color: Colors.lightGreen),
                              child: const Text('+ 2.3%'),
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.05),
                        const Text(
                          'Descrizione: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          watch.description,
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
                                      watchid: widget.watchID,
                                      brandName:
                                          watch.modelType.model.brandname,
                                      modelName:
                                          watch.modelType.model.modelname,
                                      actualPrice: watch.actualPrice,
                                      totalNumberOfShares: watch.numberOfShares,
                                      image: getDownloadURL(watch.imageuri),
                                      proposalPrice: watch.actualPrice,
                                      numberOfShares: watch
                                          .numberOfShares, // TODO: Change this
                                    ))
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.blueAccent),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
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
                          'Le migliori quote in vendita: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: heigh * 0.02),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Prezzo quota',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 20),
                                child: Text(
                                  'n° quote',
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
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasData) {
                                List<ShareOnSale> sharesOnSale = snapshot.data!;
                                return sharesOnSale.isNotEmpty
                                    ? Column(
                                        children: sharesOnSale.map(
                                          (share) {
                                            return CustomRowForQuote(
                                                width: width,
                                                numberOfQuotes:
                                                    share.shareCount,
                                                quotePrice: share.price,
                                                buyInfo: BuyInfo(
                                                  watchid: widget.watchID,
                                                  brandName: watch.modelType
                                                      .model.brandname,
                                                  modelName: watch.modelType
                                                      .model.modelname,
                                                  actualPrice:
                                                      watch.actualPrice,
                                                  totalNumberOfShares:
                                                      watch.numberOfShares,
                                                  image: getDownloadURL(
                                                      watch.imageuri),
                                                  proposalPrice: share.price,
                                                  numberOfShares:
                                                      share.shareCount,
                                                ));
                                          },
                                        ).toList(),
                                      )
                                    : const Text(
                                        'Ooops, there aren\'t any quote on sell');
                              } else if (snapshot.hasError) {
                                // Gestisci il caso in cui si verifica un errore
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // Gestisci il caso in cui non ci sono dati disponibili
                                return const SizedBox(); // Placeholder widget when no data is available
                              }
                            })
                      ]),
                );
              } else if (snapshot.hasError) {
                // Gestisci il caso in cui si verifica un errore
                return Text('Error: ${snapshot.error}');
              } else {
                // Gestisci il caso in cui non ci sono dati disponibili
                return const SizedBox(); // Placeholder widget when no data is available
              }
            },
          ),
        ),
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
  late Future<bool> isFavourite;

  @override
  void initState() {
    isFavourite = getFavorite(1, widget.watchID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          bool isFav = await isFavourite;
          if (isFav) {
            APIStatus removeStatus =
                await removeFromFavourite(1, widget.watchID);
            if (removeStatus == APIStatus.success) {
              setState(() {
                isFavourite = Future.value(false);
              });
            }
          } else {
            APIStatus addStatus = await addToFavourite(1, widget.watchID);
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
