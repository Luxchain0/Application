import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: heigh*0.02, horizontal: width*0.04 ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        left: 3, right: 4, top: 15, bottom: 20),
                    child: Text.rich(
                      TextSpan(
                          text: 'The new platform for '.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: heigh * 0.05,
                            height: 1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'luxury items'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            )
                          ]),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Here there will be the subtitle. Here there will be the subtitle. Here there will be the subtitle. Here there will be the subtitle. Here there will be the subtitle.',
                      style: TextStyle(
                          fontSize: heigh * 0.024,
                          height: 1.2,
                      ),
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
            CustomBottomBigCard(
                screenWidth: width,
                img: 'assets/images/o1.jpg',
                shortName: 'nome corto'.toUpperCase(),
                longName: 'nome lungo con descrizi'.toUpperCase(),
                serialNumber: '34XX7WZY',
                prezzoDiListino: 230000,
                quoteTotali: 300,
                quoteDisponibili: 126,
                quotazioneAttuale: 240000,
                valoreQuotaAttuale: 2000,
                incremento: 0.4),
            CustomBottomBigCard(
                screenWidth: width,
                img: 'assets/images/o2.jpg',
                shortName: 'nome corto'.toUpperCase(),
                longName: 'nome lungo con descrine'.toUpperCase(),
                serialNumber: '34X4dWZY',
                prezzoDiListino: 250000,
                quoteTotali: 400,
                quoteDisponibili: 263,
                quotazioneAttuale: 200000,
                valoreQuotaAttuale: 1000,
                incremento: 3.4),
            CustomBottomBigCard(
                screenWidth: width,
                img: 'assets/images/o3.jpg',
                shortName: 'nome corto'.toUpperCase(),
                longName: 'nome lungo con descione'.toUpperCase(),
                serialNumber: '34ZS8WZY',
                prezzoDiListino: 130000,
                quoteTotali: 100,
                quoteDisponibili: 24,
                quotazioneAttuale: 330000,
                valoreQuotaAttuale: 1800,
                incremento: -0.45),
          ],

                  ),
                ),
                ],
              ),
          ),
        ) 
      ),
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
    required this.quoteDisponibili,
    required this.quotazioneAttuale,
    required this.valoreQuotaAttuale,
    required this.incremento,
  });

  final double screenWidth;
  final String shortName;
  final String longName;
  final String img;
  final String serialNumber;
  final int prezzoDiListino;
  final int quoteTotali;
  final int quoteDisponibili;
  final int quotazioneAttuale;
  final int valoreQuotaAttuale;
  final double incremento;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth*0.01, vertical: 7),
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
              width: screenWidth * 0.23,
            ),
          ),
          SizedBox(height: screenWidth * 0.07),
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
            Text('Quotazione attuale: $quotazioneAttuale €'),
            Text('Valore quota attuale: $valoreQuotaAttuale €'),
            Text('Quote totali: $quoteTotali'),
            Text('Quote disponibili: $quoteDisponibili'),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            Row(
              children: [
                CustomButton(
                    screenWidth: screenWidth,
                    backgorundColor: const Color.fromARGB(255, 17, 45, 68),
                    textColor: Colors.white,
                    text: 'Buy',
                ),
                SizedBox(width: screenWidth * 0.1),
                CustomButton(
                    screenWidth: screenWidth,
                    backgorundColor: Colors.blueAccent,
                    textColor: Colors.white,
                    text: 'Sell'),
              ],
            )
          ],
        )
      ]),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.screenWidth,
    required this.backgorundColor,
    required this.textColor,
    required this.text
  });

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
