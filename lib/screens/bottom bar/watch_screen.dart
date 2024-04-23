import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/size_config.dart';

class WatchScreen extends StatefulWidget {
  static const String id = 'WatchScreen';
  final int watchID;
  const WatchScreen({required this.watchID, super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late Future<Watch> futureWatchData;

  @override
  void initState() {
    super.initState();
    futureWatchData = getWatchByWatchId(widget.watchID);
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
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: FutureBuilder<Watch>(
            future: futureWatchData,
            builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            Watch watch = snapshot.data!;
                            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: heigh * 0.02),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      watch.watchId.toString(),
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black26,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7))),
                      alignment: Alignment.center, // This is needed
                      child: Padding(
                        padding: EdgeInsets.all(heigh * 0.02),
                        child: Image.asset(
                          watch.modelType.imageuri,
                          fit: BoxFit.contain,
                          height: heigh * 0.3,
                        ),
                      ),
                    ),
                    Text("Referenza: ${watch.modelType.modelid}"),
                    Text("Anno: ${watch.modelType.year}"),
                    Text("Materiale cassa: ${watch.modelType.casematerial}"),
                    Text("Materiale bracciale: ${watch.modelType.braceletmaterial}"),
                    Text("Prezzo di listino: ${watch.initialPrice}"),
                    Text("Prezzo medio: ${watch.actualPrice}"),
                    Text('Prezzo di vendita proposto: '),
                    Text("Numero di quote: ${watch.numberOfShares}"),
                    Text("Condizione orlogio: ${watch.condition}"),
                    Row(
                      children: [
                        const Text('Variazione percentuale: '),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
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
                    const Text(
                      'Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà. Questa è una descrizione lunga e noiosa che mai nessuno leggerà.',
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
                          onPressed: () => {},
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.blueAccent),
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
                      'Le migliori quote in vendita: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: heigh * 0.02),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Prezzo quota/\nPrezzo listino',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                            child: Text(
                              'Quote in\nvendita',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox())
                      ],
                    ),
                    CustomRowForQuote(
                      width: width,
                      listinoPrice: 200000,
                      numberOfQuotes: 5,
                      quotePrice: 200500,
                    ),
                    CustomRowForQuote(
                      width: width,
                      listinoPrice: 200000,
                      numberOfQuotes: 5,
                      quotePrice: 200500,
                    ),
                    CustomRowForQuote(
                      width: width,
                      listinoPrice: 200000,
                      numberOfQuotes: 5,
                      quotePrice: 200500,
                    ),
                    CustomRowForQuote(
                      width: width,
                      listinoPrice: 200000,
                      numberOfQuotes: 5,
                      quotePrice: 200500,
                    ),
                    CustomRowForQuote(
                      width: width,
                      listinoPrice: 200000,
                      numberOfQuotes: 5,
                      quotePrice: 200500,
                    ),
                  ]),
            );
                          } else if (snapshot.hasError) {
                            // Gestisci il caso in cui si verifica un errore
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // Gestisci il caso in cui non ci sono dati disponibili
                            return const SizedBox(); // Placeholder widget when no data is available
                          }
                        }
            ,
          ),
        ),
      ),
    );
  }
}

class CustomRowForQuote extends StatelessWidget {
  const CustomRowForQuote({
    super.key,
    required this.width,
    required this.listinoPrice,
    required this.numberOfQuotes,
    required this.quotePrice,
  });

  final double width;
  final double quotePrice;
  final double listinoPrice;
  final int numberOfQuotes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  listinoPrice.toString(),
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                Text(
                  quotePrice.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
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
          flex: 1,
          child: CustomButton(
            screenWidth: width,
            backgorundColor: const Color.fromARGB(255, 17, 45, 68),
            textColor: Colors.white,
            text: 'Buy',
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.screenWidth,
      required this.backgorundColor,
      required this.textColor,
      required this.text});

  final double screenWidth;
  final Color backgorundColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgorundColor),
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
          minimumSize: MaterialStateProperty.all<Size>(
              Size(screenWidth * 0.15, screenWidth * 0.08)),
          maximumSize: MaterialStateProperty.all<Size>(
              Size(screenWidth * 0.15, screenWidth * 0.08))),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
