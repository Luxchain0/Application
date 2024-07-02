import 'package:flutter/material.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesScreen extends StatefulWidget {
  static const String id = 'FavouritesScreen';
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {

  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.02, horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'My favourites',
              style: TextStyle(
                  color: Colors.black87,
                  height: 1,
                  fontSize: width * 0.1,
                  fontFamily: 'Bebas'),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
              child: MyFavouritesCardsView(
                width: width,
                height: height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFavouritesCardsView extends StatefulWidget {
  final double width;
  final double height;

  const MyFavouritesCardsView({
    required this.width,
    required this.height,
    super.key,
  });

  @override
  _MyFavouritesCardsViewState createState() =>
      _MyFavouritesCardsViewState();
}

class _MyFavouritesCardsViewState extends State<MyFavouritesCardsView> {
  late bool _isLastPage;
  late int _pageNumber = 1;
  late bool _isError;
  late bool _isLoading;
  final int _numberOfWatchesPerRequest = 10;
  late List<Favorite> _favourites;
  final int _nextPageTrigger = 0;

  @override
  void initState() {
    super.initState();
    _favourites = [];
    _isLastPage = false;
    _isLoading = true;
    _isError = false;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences user = await getUserData();
      int userId = user.getInt('accountid') ?? 0;

      print('page number: $_pageNumber');
      print('object per request: $_numberOfWatchesPerRequest');
      List<Favorite> req = await getFavorites(userId);
      for (var element in req) {
        print('watchID: ${element.watchid}');
      }

      if (mounted) {
        print(_favourites.length.toString());
        setState(() {
          _favourites.addAll(req);
          _isLastPage = req.length < _numberOfWatchesPerRequest;
          _isLoading = false;
          _pageNumber += 1;
        });
        print(_favourites.length.toString());
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _favourites.isEmpty ? _buildEmptyListView() : _buildListView();
  }

  Widget _buildEmptyListView() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isError) {
      return const Center(
        child: Text('Errore'),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _favourites.length + (_isLastPage ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == _favourites.length - _nextPageTrigger && !_isLastPage) {
          fetchData();
        }
        if (index == _favourites.length) {
          if (_isError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
        final Favorite favourite = _favourites[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: CustomBottomBigCard(
            watchID: favourite.watchid,
            screenWidth: widget.width,
            imgUrl: getDownloadURL(favourite.watch.imageuri),
            favoriteWatch: favourite.watch,
          ),
        );
      },
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
                      'Retail Price: ${formatAmountFromDouble(favoriteWatch.retailPrice)}'),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.4,
                  ),
                  child: Text(
                      'Actual Price: ${formatAmountFromDouble(favoriteWatch.actualPrice)}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
