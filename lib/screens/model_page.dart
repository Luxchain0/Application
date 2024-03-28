import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class ModelScreen extends StatefulWidget {
  static const String id = 'ModelScreen';
  const ModelScreen({super.key});

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: heigh * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'MarketPlace',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'),
                ),
                SizedBox(
                  height: heigh * 0.02,
                ),
                CustomBottomBigCard(
                    screenWidth: width,
                    img: 'assets/images/o2.jpg',
                    shortName: 'nome corto'.toUpperCase(),
                    longName: 'nome lungo con descrizione'.toUpperCase(),
                    serialNumber: '34XX7WZY',
                    prezzoDiListino: 230000,
                    quoteTotali: 300,
                    pezziDisponibili: 4,
                    incremento: 0.4),
                SizedBox(
                  height: heigh * 0.015,
                ),
                Text(
                  'Le migliori quote in vendita: ',
                  style: TextStyle(
                      fontSize: heigh * 0.025, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heigh * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20, right: 20),
                      child: Text('Serial'),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Text(
                        'Prezzo quota/\nPrezzo listino',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Text(
                        'Quote in\nvendita',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        child: SizedBox(
                      width: width * 0.01,
                    ))
                  ],
                ),
                CustomRowForQuote(
                    width: width,
                    listinoPrice: 200000,
                    numberOfQuotes: 5,
                    quotePrice: 200500,
                    serial: 'xyz'),
                CustomRowForQuote(
                    width: width,
                    listinoPrice: 200000,
                    numberOfQuotes: 5,
                    quotePrice: 200500,
                    serial: 'xyz'),
                CustomRowForQuote(
                    width: width,
                    listinoPrice: 200000,
                    numberOfQuotes: 5,
                    quotePrice: 200500,
                    serial: 'xyz'),
                CustomRowForQuote(
                    width: width,
                    listinoPrice: 200000,
                    numberOfQuotes: 5,
                    quotePrice: 200500,
                    serial: 'xyz'),
                CustomRowForQuote(
                    width: width,
                    listinoPrice: 200000,
                    numberOfQuotes: 5,
                    quotePrice: 200500,
                    serial: 'xyz'),
                SizedBox(
                  height: heigh * 0.05,
                ),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      width: width * 0.1,
                    )),
                    OutlinedButton.icon(
                        onPressed: () => {},
                        icon: Icon(Icons.arrow_back_ios),
                        label: Text('Back to the market')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRowForQuote extends StatelessWidget {
  const CustomRowForQuote(
      {super.key,
      required this.width,
      required this.listinoPrice,
      required this.numberOfQuotes,
      required this.quotePrice,
      required this.serial});

  final double width;
  final double quotePrice;
  final double listinoPrice;
  final int numberOfQuotes;
  final String serial;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(serial),
        Column(
          children: [
            Text(
              listinoPrice.toString(),
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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
        Text(numberOfQuotes.toString()),
        CustomButton(
          screenWidth: width,
          backgorundColor: const Color.fromARGB(255, 17, 45, 68),
          textColor: Colors.white,
          text: 'Buy',
        ),
      ],
    );
  }
}

class CustomBottomBigCard extends StatelessWidget {
  const CustomBottomBigCard({
    super.key,
    required this.screenWidth,
    required this.img,
    required this.shortName,
    required this.longName,
    required this.serialNumber,
    required this.prezzoDiListino,
    required this.quoteTotali,
    required this.pezziDisponibili,
    required this.incremento,
  });

  final double screenWidth;
  final String shortName;
  final String longName;
  final String img;
  final String serialNumber;
  final int prezzoDiListino;
  final int quoteTotali;
  final int pezziDisponibili;
  final double incremento;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10),
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
        Column(children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            alignment: Alignment.center, // This is needed
            child: Image.asset(
              img,
              fit: BoxFit.contain,
              width: screenWidth * 0.19,
            ),
          ),
          SizedBox(height: screenWidth * 0.05),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: Colors.lightGreen),
            child: Text('$incremento%'),
          ),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shortName,
              style: TextStyle(
                  color: Colors.black38,
                  height: 1,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'Bebas'),
            ),
            Text(
              longName,
              style: TextStyle(
                  color: Colors.black87,
                  height: 1,
                  fontSize: screenWidth * 0.055,
                  fontFamily: 'Bebas'),
            ),
            Text('Serial: $serialNumber'),
            SizedBox(height: screenWidth * 0.02),
            Text('Prezzo di listino: $prezzoDiListino €'),
            Text('Quote totali: $quoteTotali'),
            Text('Quote disponibili: $pezziDisponibili'),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                CustomButton(
                  screenWidth: screenWidth,
                  backgorundColor: const Color.fromARGB(255, 17, 45, 68),
                  textColor: Colors.white,
                  text: 'Dettagli del prodotto',
                ),
              ],
            ),
          ],
        )
      ]),
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
              Size(screenWidth * 0.2, screenWidth * 0.08))),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
