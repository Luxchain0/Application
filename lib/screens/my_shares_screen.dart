//TODO

import 'package:flutter/material.dart';
import 'package:lux_chain/screens/modify_on_sale_share.dart';
import 'package:lux_chain/utilities/size_config.dart';

class MySharesScreen extends StatefulWidget {
  static const String id = 'HistoryScreen';
  const MySharesScreen({super.key});

  @override
  State<MySharesScreen> createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<MySharesScreen> {
  @override
  void initState() {
    super.initState();
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
                Text(
                  'Le mie quote in vendita',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'),
                ),
                CustomCard(watchID: 1, screenWidth: width, imgUrl: "assets/images/o1.jpg", modelName: "ModelName", brandName: "BrandName", serialNumber: "0x32wxx", quote: 3, price: "43,98 €"),
                CustomCard(watchID: 1, screenWidth: width, imgUrl: "assets/images/o2.jpg", modelName: "ModelName", brandName: "BrandName", serialNumber: "0x32wxx", quote: 3, price: "23,18 €"),
                CustomCard(watchID: 1, screenWidth: width, imgUrl: "assets/images/o3.jpg", modelName: "ModelName", brandName: "BrandName", serialNumber: "0x32wxx", quote: 3, price: "123,18 €"),
                CustomCard(watchID: 1, screenWidth: width, imgUrl: "assets/images/o1.jpg", modelName: "ModelName", brandName: "BrandName", serialNumber: "0x32wxx", quote: 3, price: "123,18 €"),
                CustomCard(watchID: 1, screenWidth: width, imgUrl: "assets/images/o2.jpg", modelName: "ModelName", brandName: "BrandName", serialNumber: "0x32wxx", quote: 3, price: "123,18 €"),
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
    required this.watchID,
    required this.screenWidth, //
    required this.imgUrl, //
    required this.modelName, //
    required this.brandName, //
    required this.serialNumber, //
    required this.quote,
    required this.price,
  });

  final int watchID;
  final double screenWidth;
  final String modelName;
  final String brandName;
  final String imgUrl;
  final String serialNumber;
  final int quote;
  final String price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          {Navigator.of(context).pushNamed(ModifyOnSaleShareScreen.id)},
      child: Container(
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
                margin: const EdgeInsets.only(right: 0),
                alignment: Alignment.center, // This is needed
                child: Image.asset(
                  // Utilizzo di Image.network per caricare l'immagine da un URL
                  imgUrl, // Utilizzo dell'URL dell'immagine
                  fit: BoxFit.contain,
                  width: screenWidth * 0.22,
                ),
              ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                modelName,
                style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas'),
              ),
              Text(
                brandName,
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: screenWidth * 0.055,
                    fontFamily: 'Bebas'),
              ),
              Text('Serial: $serialNumber'),
              SizedBox(height: screenWidth * 0.02),
              Text('Quote in vendita: $quote'),
              Text('Prezzo quota: $price €'),
            ],
          )
        ]),
      ),
    );
  }
}
