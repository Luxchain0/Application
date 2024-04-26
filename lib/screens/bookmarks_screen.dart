//TODO

import 'package:flutter/material.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';

class BookmarksScreen extends StatefulWidget {
  static const String id = 'BookmarksScreen';
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late Future<List<WalletWatch>> futureWatches;
  late Future<WalletData> futureWalletData;

  @override
  void initState() {
    super.initState();
    futureWatches = getUserWalletWatches(1);
    futureWalletData = getWalletData(1);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
              right: width * 0.05, left: width * 0.05, top: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FutureBuilder<List<WalletWatch>>(
                        future: futureWatches,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            List<WalletWatch> walletWatches = snapshot.data!;
                            return Column(
                              children: walletWatches.map(
                                (watch) {
                                  return CustomBottomBigCard(
                                    watchID: watch.watchid,
                                    screenWidth: width,
                                    imgUrl: getDownloadURL(watch.imageuri),
                                    modelName: watch.watchid.toString(),
                                    brandName: watch.modeltype.model.modelname,
                                    serialNumber: watch.watchid.toString(),
                                    valoreAttuale: 0,
                                    valoreDiAcquisto: watch.initialprice,
                                    quotePossedute: watch.owned,
                                    quoteTotali: watch.numberofshares,
                                    controvalore: 0,
                                    incremento: 0,
                                  );
                                },
                              ).toList(),
                            );
                          } else if (snapshot.hasError) {
                            // Gestisci il caso in cui si verifica un errore
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // Gestisci il caso in cui non ci sono dati disponibili
                            return const SizedBox(); // Placeholder widget when no data is available
                          }
                        })),
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
    required this.watchID,
    required this.screenWidth, //
    required this.imgUrl, //
    required this.modelName, //
    required this.brandName, //
    required this.serialNumber, //
    required this.valoreAttuale, //
    required this.valoreDiAcquisto, //
    required this.quotePossedute, //
    required this.quoteTotali, //
    required this.controvalore, //
    required this.incremento, //
  });

  final int watchID;
  final double screenWidth;
  final String modelName;
  final String brandName;
  final Future<String> imgUrl;
  final String serialNumber;
  final int quotePossedute;
  final int quoteTotali;
  final double controvalore;
  final double valoreDiAcquisto;
  final double valoreAttuale;
  final double incremento;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          {Navigator.of(context).pushNamed(WatchScreen.id, arguments: watchID)},
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(children: [
              FutureBuilder<String>(
                  future: imgUrl,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(right: 0),
                        alignment: Alignment.center, // This is needed
                        child: Image.network(
                          // Utilizzo di Image.network per caricare l'immagine da un URL
                          snapshot.data!, // Utilizzo dell'URL dell'immagine
                          fit: BoxFit.contain,
                          width: screenWidth * 0.22,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    } else {
                      return const SizedBox();
                    }
                  }),
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
              Text('Quote Possedute: $quotePossedute/$quoteTotali'),
              Text('Controvalore: $controvalore €'),
              Text('Valore di acquisto: $valoreDiAcquisto €'),
              Text('Valore attuale: $valoreAttuale €'),
            ],
          )
        ]),
      ),
    );
  }
}
