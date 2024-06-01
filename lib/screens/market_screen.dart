import 'package:flutter/material.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';

class MarketScreen extends StatefulWidget {
  static const String id = 'MarketScreen';

  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late Future<List<MarketPlaceWatch>> futureMarketPlaceWatches;
  int pageNumber = 1;
  int watchPerPage = 10;
  List<MarketPlaceWatch> marketPlaceWatches = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  String _nameSearchedWatch = '';

  @override
  void initState() {
    super.initState();
    futureMarketPlaceWatches =
        Future.value([]); // Initialize with an empty list
    _initializeData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() async {
    setState(() {
      futureMarketPlaceWatches =
          getMarketPlaceWatches(pageNumber, watchPerPage);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreWatches();
    }
  }

  void _loadMoreWatches() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    pageNumber++;

    List<MarketPlaceWatch> newWatches =
        await getMarketPlaceWatches(pageNumber, watchPerPage);

    setState(() {
      marketPlaceWatches.addAll(newWatches);
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: heigh * 0.02, horizontal: width * 0.04),
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
                    fontFamily: 'Bebas'),
              ),
              SizedBox(
                height: heigh * 0.01,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 239, 239, 239),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Icon(Icons.search_rounded),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        print('Ghe semo');
                      },
                      child: TextFormField(
                        autofocus: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                        decoration: const InputDecoration(
                            hintText: 'Search the name of the watch',
                            border: InputBorder.none),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            try {
                              setState(() {
                                _nameSearchedWatch = value;
                              });
                            } catch (e) {
                              // Gestire il caso in cui la stringa non possa essere convertita in double
                              print(e.toString());
                            }
                          }
                        },
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: heigh * 0.01,
              ),
              FutureBuilder<List<MarketPlaceWatch>>(
                future: futureMarketPlaceWatches,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    List<MarketPlaceWatch> marketWatchesList = snapshot.data!;
                    List<MarketPlaceWatch> filteredList = [];

                      for (MarketPlaceWatch w in marketWatchesList) {
                        if (_nameSearchedWatch == '') {
                          filteredList = marketWatchesList;
                        } else if (w.modelType.model.brandname
                                .contains(_nameSearchedWatch) 
                                || w.modelType.model.modelname
                                .contains(_nameSearchedWatch)
                                ) {
                          filteredList.add(w);
                        } else {
                          filteredList = marketWatchesList;
                        }
                      }
                    return Column(
                      children: filteredList
                          .map((watch) => CustomBottomBigCard(
                              screenWidth: width,
                              marketWatch: watch,
                              watchid: watch.watchId,
                              imgFuture: getDownloadURL(watch.imageuri)))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const SizedBox(); // Placeholder widget when no data is available
                  }
                },
              ),
              if (isLoadingMore)
                const Center(child: CircularProgressIndicator()),
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
    required this.screenWidth,
    required this.marketWatch,
    required this.watchid,
    required this.imgFuture,
  }) : super(key: key);

  final MarketPlaceWatch marketWatch;
  final double screenWidth;
  final int watchid;
  final Future<String> imgFuture;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(WatchScreen.id,
          arguments: Watch(
              watchId: marketWatch.watchId,
              condition: marketWatch.condition,
              numberOfShares: marketWatch.numberOfShares,
              retailPrice: marketWatch.retailPrice,
              initialPrice: marketWatch.initialPrice,
              actualPrice: marketWatch.actualPrice,
              dialcolor: marketWatch.dialcolor,
              year: marketWatch.year,
              imageuri: marketWatch.imageuri,
              description: marketWatch.description,
              modelTypeId: marketWatch.modelTypeId,
              modelType: marketWatch.modelType)),
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
                    future: imgFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          child: Image.network(
                            snapshot.data!,
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.25,
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
                  SizedBox(height: screenWidth * 0.02),
                  CustomButton(
                    screenWidth: screenWidth,
                    backgorundColor: const Color.fromARGB(255, 17, 45, 68),
                    textColor: Colors.white,
                    text: 'Details',
                    onPressed: () => Navigator.pushNamed(
                        context, WatchScreen.id,
                        arguments: Watch(
                            watchId: marketWatch.watchId,
                            condition: marketWatch.condition,
                            numberOfShares: marketWatch.numberOfShares,
                            retailPrice: marketWatch.retailPrice,
                            initialPrice: marketWatch.initialPrice,
                            actualPrice: marketWatch.actualPrice,
                            dialcolor: marketWatch.dialcolor,
                            year: marketWatch.year,
                            imageuri: marketWatch.imageuri,
                            description: marketWatch.description,
                            modelTypeId: marketWatch.modelTypeId,
                            modelType: marketWatch.modelType)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marketWatch.modelType.model.modelname,
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text(
                  marketWatch.modelType.model.brandname,
                  style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: screenWidth * 0.055,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text('Serial: ${marketWatch.modelType.reference}'),
                Text(
                    'Retail Price: ${formatAmountFromDouble(marketWatch.retailPrice)}€'),
                SizedBox(height: screenWidth * 0.02),
                Text(
                    'Initial Price: ${formatAmountFromDouble(marketWatch.initialPrice)}€'),
                Text('Total Shares: ${marketWatch.numberOfShares}'),
                Text('Shares available: ${marketWatch.sharesOnSale}'),
                SizedBox(height: screenWidth * 0.02),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final double screenWidth;
  final Color backgorundColor;
  final Color textColor;
  final String text;
  final Function onPressed;

  const CustomButton(
      {super.key,
      required this.screenWidth,
      required this.backgorundColor,
      required this.textColor,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(),
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
