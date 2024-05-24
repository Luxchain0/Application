import 'package:flutter/material.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesScreen extends StatefulWidget {
  static const String id = 'FavouritesScreen';
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late Future<List<Favorite>> futureFavorites;

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
      futureFavorites = getFavorites(userId);
    });
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
                    child: FutureBuilder<List<Favorite>>(
                        future: futureFavorites,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            List<Favorite> favorites = snapshot.data!;
                            return Column(
                              children: favorites.map(
                                (favorite) {
                                  return CustomBottomBigCard(
                                    watchID: favorite.watch.watchId,
                                    screenWidth: width,
                                    imgUrl:
                                        getDownloadURL(favorite.watch.imageuri),
                                    modelName:
                                        favorite.watch.watchId.toString(),
                                    brandName: favorite
                                        .watch.modelType.model.modelname,
                                    serialNumber:
                                        favorite.watch.watchId.toString(),
                                    valoreAttuale: 0,
                                    valoreDiAcquisto:
                                        favorite.watch.initialPrice,
                                    quotePossedute: 0,
                                    quoteTotali: favorite.watch.numberOfShares,
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
    Key? key,
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
  final int quotePossedute; // TODO: add this
  final int quoteTotali;
  final double controvalore;
  final double valoreDiAcquisto;
  final double valoreAttuale;
  final double incremento;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(WatchScreen.id, arguments: watchID),
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
          borderRadius: const BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  FutureBuilder<String>(
                    future: imgUrl,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          child: Image.network(
                            snapshot.data!,
                            width: screenWidth * 0.23,
                            height: screenWidth * 0.23,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('Image not found');
                      }
                    },
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      color: (incremento > 0) ? Colors.lightGreen : Colors.red,
                    ),
                    child: Text('$incremento%'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text(
                  modelName,
                  style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: screenWidth * 0.055,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text('Serial: $serialNumber'),
                SizedBox(height: screenWidth * 0.02),
                Text('Quote Possedute: $quotePossedute/$quoteTotali'),
                Text('Controvalore: ' +
                    formatAmountFromDouble(controvalore) +
                    ' €'),
                Text('Valore di acquisto: ' +
                    formatAmountFromDouble(valoreDiAcquisto) +
                    ' €'),
                Text('Valore attuale: ' +
                    formatAmountFromDouble(valoreAttuale) +
                    ' €'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
