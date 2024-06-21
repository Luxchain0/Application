import 'package:flutter/material.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketScreen extends StatefulWidget {
  static const String id = 'MarketScreen';

  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _nameSearchedWatch = '';
  String _provvisorio = '';

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
              'MarketPlace',
              style: TextStyle(
                  color: Colors.black87,
                  height: 1,
                  fontSize: width * 0.1,
                  fontFamily: 'Bebas'),
            ),
            SizedBox(
              height: height * 0.01,
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
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {},
                      child: TextFormField(
                        autofocus: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                        decoration: const InputDecoration(
                            hintText: 'Name of the watch',
                            border: InputBorder.none),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _nameSearchedWatch = value; // rimuoverlo per disattivare la ricerca automatica
                              _provvisorio = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                        screenWidth: width,
                        textColor: Colors.white,
                        backgorundColor: const Color.fromARGB(255, 89, 126, 188),
                        text: 'Search',
                        onPressed: () {
                          setState(() {
                            _nameSearchedWatch = _provvisorio;
                          });
                        }),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
              child: MarketCardsView(
                key: ValueKey(_nameSearchedWatch),
                width: width,
                searchedString: _nameSearchedWatch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketCardsView extends StatefulWidget {
  final double width;
  final String searchedString;

  const MarketCardsView({
    required this.width,
    required this.searchedString,
    super.key,
  });

  @override
  _MarketCardsViewState createState() => _MarketCardsViewState();
}

class _MarketCardsViewState extends State<MarketCardsView> {
  late bool _isLastPage;
  int _pageNumber = 1;
  late bool _isError;
  late bool _isLoading;
  final int _numberOfWatchesPerRequest = 10;
  late List<MarketPlaceWatch> _watches;
  final int _nextPageTrigger = 0;

  @override
  void initState() {
    super.initState();
    _watches = [];
    _isLastPage = false;
    _isLoading = true;
    _isError = false;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences user = await getUserData();
      int userId = user.getInt('accountid') ?? 0;

      List<MarketPlaceWatch> req = await getMarketPlaceWatches(
          _pageNumber, _numberOfWatchesPerRequest, widget.searchedString, userId);

      if (mounted) {
        setState(() {
          _watches.addAll(req);
          _isLastPage = req.length < _numberOfWatchesPerRequest;
          _isLoading = false;
          _pageNumber += 1;
        });
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
  void dispose() {
    // Se necessario, cancella timer o listener qui
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _watches.isEmpty ? _buildEmptyListView() : _buildListView();
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
        child: Text('Some errors occurr.\nPlease try again ...'),
      );
    } else {
      return const Center(
        child: Text('\nNo watch found with that name ...'),
      );
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _watches.length + (_isLastPage ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == _watches.length - _nextPageTrigger && !_isLastPage) {
          fetchData();
        }
        if (index == _watches.length) {
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
        final MarketPlaceWatch watch = _watches[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: CustomBottomBigCard(
            screenWidth: widget.width,
            marketWatch: watch,
            watchid: watch.watchId,
            imgFuture: getDownloadURL(watch.imageuri),
          ),
        );
      },
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
                  marketWatch.modelType.model.brandname,
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas',
                  ),
                ),
                Text(
                  marketWatch.modelType.model.modelname,
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
