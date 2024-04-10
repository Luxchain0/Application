import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class MarketScreen extends StatefulWidget {
  static const String id = 'MarketScreen';
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
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
                  Text(
                    'MarketPlace',
                    style: TextStyle(
                        color: Colors.black87,
                        height: 1,
                        fontSize: width * 0.1,
                        fontFamily: 'Bebas'
                    ),
                  ),
                  SizedBox(
                    height: heigh * 0.02,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                        color: Colors.grey,
                        ),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                      suffixIcon: Icon(Icons.search),
                      alignLabelWithHint: true,
                      labelText: 'Insert the name of the watch'
                    ),
                  ),
                  Container(
                  margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: width * 0.08,
                      ),
                      Expanded(child: SizedBox(width: width * 0.08)),
                      Icon(Icons.arrow_outward_rounded, size: width * 0.08),
                      Icon(Icons.filter, size: width * 0.08),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
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
                      CustomBottomBigCard(
                          screenWidth: width,
                          img: 'assets/images/o2.jpg',
                          shortName: 'nome corto'.toUpperCase(),
                          longName: 'nome lungo con descrizione'.toUpperCase(),
                          serialNumber: '34X4dWZY',
                          prezzoDiListino: 250000,
                          quoteTotali: 400,
                          pezziDisponibili: 12,
                          incremento: 3.4),
                      CustomBottomBigCard(
                          screenWidth: width,
                          img: 'assets/images/o2.jpg',
                          shortName: 'nome corto'.toUpperCase(),
                          longName: 'nome lungo con descrizione'.toUpperCase(),
                          serialNumber: '34ZS8WZY',
                          prezzoDiListino: 130000,
                          quoteTotali: 100,
                          pezziDisponibili: 3,
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
                CustomButton(
                    screenWidth: screenWidth,
                    backgorundColor: const Color.fromARGB(255, 17, 45, 68),
                    textColor: Colors.white,
                    text: 'Vedi i dettagli',
                ),
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
