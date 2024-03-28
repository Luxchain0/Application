import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class WalletScreen extends StatefulWidget {
  static const String id = 'WalletScreen';
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
              right: width * 0.05, left: width * 0.05, top: heigh * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Wallet value',
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Icon(Icons.visibility),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '134 456.43',
                      style: TextStyle(
                          color: Colors.black87,
                          height: 1,
                          fontSize: width * 0.1,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(
                      '€',
                      style: TextStyle(
                        fontSize: width * 0.06,
                        height: 1,
                      ),
                    ),
                    Expanded(
                        child: SizedBox(
                      width: width * 0.01,
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.lightGreen),
                      child: const Text('+ 2.3%'),
                    ),
                  ],
                ),
              ),
              Text(
                'In collezioni: 100 000.00 €',
                style: TextStyle(fontSize: width * 0.04),
              ),
              Text(
                'Liquidi: 34 456.43 €',
                style: TextStyle(fontSize: width * 0.04),
              ),
              SizedBox(
                height: heigh * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                child: Row(
                  children: [
                    Icon(
                      Icons.archive,
                      size: width * 0.08,
                    ),
                    Icon(
                      Icons.timelapse,
                      size: width * 0.08,
                    ),
                    Icon(
                      Icons.store,
                      size: width * 0.08,
                    ),
                    Icon(
                      Icons.star,
                      size: width * 0.08,
                    ),
                    Expanded(child: SizedBox(width: width * 0.08)),
                    Icon(Icons.arrow_outward_rounded, size: width * 0.08),
                    Icon(Icons.filter, size: width * 0.08),
                    Icon(Icons.search, size: width * 0.08),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    CustomBottomBigCard(
                        screenWidth: width,
                        img: 'assets/images/o1.jpg',
                        shortName: 'nome corto'.toUpperCase(),
                        longName: 'nome lungo con descrizione'.toUpperCase(),
                        serialNumber: '34XX7WZY',
                        valoreAttuale: 3070,
                        valoreDiAcquisto: 3040,
                        quotePossedute: 4,
                        controvalore: 12345.45,
                        incremento: 0.4),
                    CustomBottomBigCard(
                        screenWidth: width,
                        img: 'assets/images/o2.jpg',
                        shortName: 'nome corto'.toUpperCase(),
                        longName: 'nome lungo con descrizione'.toUpperCase(),
                        serialNumber: '34X4dWZY',
                        valoreAttuale: 3070,
                        valoreDiAcquisto: 3040,
                        quotePossedute: 4,
                        controvalore: 12345.45,
                        incremento: 0.4),
                    CustomBottomBigCard(
                        screenWidth: width,
                        img: 'assets/images/o3.jpg',
                        shortName: 'nome corto'.toUpperCase(),
                        longName: 'nome lungo con descrizione'.toUpperCase(),
                        serialNumber: '34ZS8WZY',
                        valoreAttuale: 3070,
                        valoreDiAcquisto: 3040,
                        quotePossedute: 4,
                        controvalore: 12345.45,
                        incremento: 0.4),
                  ]),
                ),
              ),
            ],
          ),
        ),
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
    required this.valoreAttuale,
    required this.valoreDiAcquisto,
    required this.quotePossedute,
    required this.controvalore,
    required this.incremento,
  });

  final double screenWidth;
  final String shortName;
  final String longName;
  final String img;
  final String serialNumber;
  final int quotePossedute;
  final double controvalore;
  final double valoreDiAcquisto;
  final double valoreAttuale;
  final double incremento;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              alignment: Alignment.center, // This is needed
              child: Image.asset(
                img,
                fit: BoxFit.contain,
                width: screenWidth * 0.15,
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
        ),
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
            Text('Quote Possedute: $quotePossedute/100'),
            Text('Controvalore: $controvalore €'),
            Text('Valore di acquisto: $valoreDiAcquisto €'),
            Text('Valore attuale: $valoreAttuale €'),
          ],
        )
      ]),
    );
  }
}
