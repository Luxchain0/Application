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
  Future<List<Favorite>> futureFavorites = Future.value([]);

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    Future<SharedPreferences> userFuture = getUserData();
    SharedPreferences user = await userFuture;

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
                            return Container(
                                constraints: BoxConstraints(
                                    minHeight: height * 0.8, maxWidth: width),
                                child: const Center(
                                    child: CircularProgressIndicator()));
                          } else if (snapshot.hasData) {
                            List<Favorite> favorites = snapshot.data!;
                            return favorites.isNotEmpty
                                ? Column(
                                    children: favorites.map(
                                      (favorite) {
                                        return CustomBottomBigCard(
                                          watchID: favorite.watch.watchId,
                                          screenWidth: width,
                                          imgUrl: getDownloadURL(
                                              favorite.watch.imageuri),
                                          favoriteWatch: favorite.watch,
                                        );
                                      },
                                    ).toList(),
                                  )
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: height * 0.01),
                                    child: const Center(
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          '\nYou\'ve not added any watch as favourite yet.'),
                                    ),
                                  );
                          } else if (snapshot.hasError) {
                            // Gestisci il caso in cui si verifica un errore
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // Gestisci il caso in cui non ci sono dati disponibili
                            return const Center(
                              child: Text(
                                  "\nYou've not added any watch as favourite yet."),
                            ); // Placeholder widget when no data is available
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
    required this.favoriteWatch, //
  });

  final int watchID;
  final double screenWidth;
  final Watch favoriteWatch;
  final Future<String> imgUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(WatchScreen.id, arguments: favoriteWatch),
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
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.4,
                  ),
                  child: Text(
                    favoriteWatch.modelType.model.brandname,
                    style: TextStyle(
                      color: Colors.black38,
                      height: 1,
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'Bebas',
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.4,
                  ),
                  child: Text(
                    favoriteWatch.modelType.model.modelname,
                    style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: screenWidth * 0.055,
                      fontFamily: 'Bebas',
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.4,
                  ),
                  child: Text('Reference: ${favoriteWatch.modelType.reference}')
                ),
                Text('Serial: ${favoriteWatch.watchId}'),
                SizedBox(height: screenWidth * 0.02),
                Text('Number of Shares: ${favoriteWatch.numberOfShares}'),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.4,
                  ),
                  child: Text(
                      'Retail Price: ${formatAmountFromDouble(favoriteWatch.retailPrice)}€'),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.4,
                  ),
                  child: Text(
                      'Actual Price: ${formatAmountFromDouble(favoriteWatch.actualPrice)}€'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
