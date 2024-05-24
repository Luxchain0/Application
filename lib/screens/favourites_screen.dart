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
  late Future<List<Favorite>> futureFavorites = Future.value([]);

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
                                    screenWidth: width,
                                    favorite: favorite,
                                    imgUrl: getDownloadURL(favorite.watch.imageuri),
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
    required this.screenWidth, //
    required this.favorite, //
    required this.imgUrl, //
  });

  final double screenWidth;
  final Favorite favorite;
  final Future<String> imgUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(WatchScreen.id,
          arguments: Watch(
              watchId: favorite.watch.watchId,
              condition: favorite.watch.condition,
              numberOfShares: favorite.watch.numberOfShares,
              initialPrice: favorite.watch.initialPrice,
              actualPrice: favorite.watch.actualPrice,
              dialcolor: favorite.watch.dialcolor,
              year: favorite.watch.year,
              imageuri: favorite.watch.imageuri,
              description: favorite.watch.description,
              modelTypeId: favorite.watch.modelTypeId,
              modelType: favorite.watch.modelType)),
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
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite.watch.modelType.model.brandname,
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text(
                  favorite.watch.modelType.model.modelname,
                  style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: screenWidth * 0.055,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text('Serial: ${favorite.watch.watchId}'),
                SizedBox(height: screenWidth * 0.02),
                Text('Shares: ${favorite.watch.numberOfShares}'),
                Text('Initial Price: ${formatAmountFromDouble(favorite.watch.initialPrice)} €'),
                Text('Actual Price: ${formatAmountFromDouble(favorite.watch.actualPrice)} €'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
