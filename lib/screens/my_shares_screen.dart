//TODO

import 'package:flutter/material.dart';
import 'package:lux_chain/screens/modify_on_sale_share.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';

class MySharesScreen extends StatefulWidget {
  static const String id = 'HistoryScreen';
  const MySharesScreen({super.key});

  @override
  State<MySharesScreen> createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<MySharesScreen> {
  late Future<List<MySharesOnSale>> futureMySharesOnSale;
  @override
  void initState() {
    super.initState();
    futureMySharesOnSale = getMySharesOnSale(1);
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
                FutureBuilder<List<MySharesOnSale>>(
                  future: futureMySharesOnSale,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!
                            .map((myShare) => CustomCard(
                                  watchID: myShare.watchId,
                                  screenWidth: width,
                                  imgUrl: getDownloadURL(myShare.imageuri),
                                  modelName: myShare.modelName,
                                  brandName: myShare.brandName,
                                  reference: myShare.reference,
                                  sharesOnSale: myShare.sharesOnSale,
                                  price: myShare.price.toString(),
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    else {
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
    required this.watchID,
    required this.screenWidth,
    required this.imgUrl,
    required this.modelName,
    required this.brandName,
    required this.reference,
    required this.sharesOnSale,
    required this.price,
  });

  final int watchID;
  final double screenWidth;
  final String modelName;
  final String brandName;
  final Future<String> imgUrl;
  final String reference;
  final int sharesOnSale;
  final String price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          {Navigator.of(context).pushNamed(ModifyOnSaleShareScreen.id,
          arguments: ModifySharesOnSale(
            watchid: watchID,
            brandName: brandName,
            modelName: modelName,
            proposalPrice: double.parse(price),
            ownedShares: 0,
            onSaleShares: sharesOnSale,
            image: imgUrl,
          ))},
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
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
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
              Text('Reference: $reference'),
              Text('Serial: $watchID'),
              SizedBox(height: screenWidth * 0.02),
              Text('Quote in vendita: $sharesOnSale'),
              Text('Prezzo quota: $price €'),
            ],
          )
        ]),
      ),
    );
  }
}
