import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lux_chain/screens/wallet_specs_screen.dart';
import 'package:lux_chain/screens/watch_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  static const String id = 'WalletScreen';

  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<WalletData> futureWalletData;

  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();
    _width = SizeConfig.screenW!;
    _height = SizeConfig.screenH!;

    futureWalletData = Future.value(
      const WalletData(
        inShares: 0,
        liquidity: 0,
        rate: 0,
      ),
    );
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences user = await getUserData();
    int userId = user.getInt('accountid') ?? 0;

    if (mounted) {
      setState(() {
        futureWalletData = getWalletData(userId);
      });
    }
  }

  @override
  void dispose() {
    // Se necessario, cancella timer o listener qui
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            right: _width * 0.05,
            left: _width * 0.05,
            top: _height * 0.01,
          ),
          child: FutureBuilder<WalletData>(
            future: futureWalletData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                WalletData walletData = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RefreshingWalletData(
                      walletData: walletData,
                      width: _width,
                      height: _height,
                    ),
                    Expanded(
                      child: CardsView(
                        width: _width,
                        height: _height,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const SizedBox(); // Placeholder widget when no data is available
              }
            },
          ),
        ),
      ),
    );
  }
}

class CardsView extends StatefulWidget {
  final double width;
  final double height;

  const CardsView({
    required this.width,
    required this.height,
    super.key,
  });

  @override
  _CardsViewState createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _isError;
  late bool _isLoading;
  final int _numberOfWatchesPerRequest = 7;
  late List<WalletWatch> _watches;
  final int _nextPageTrigger = 0;

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _watches = [];
    _isLastPage = false;
    _isLoading = true;
    _isError = false;
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences user = await getUserData();
    int userId = user.getInt('accountid') ?? 0;
    var req = await getUserWalletWatches(
        userId, _pageNumber, _numberOfWatchesPerRequest);

    setState(() {
      _watches.addAll(req);
      _isLastPage = req.length < _numberOfWatchesPerRequest;
      _isLoading = false;
      _pageNumber = _pageNumber + 1;
    });
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
        child: Text('Errore'),
      );
    } else {
      return const SizedBox();
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
        final WalletWatch watch = _watches[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: CustomBottomBigCard(
            watchID: watch.watchId,
            screenWidth: widget.width,
            screenHeight: widget.height,
            walletWatch: watch,
            imgUrl: getDownloadURL(watch.imageuri),
          ),
        );
      },
    );
  }
}

class WalletInfo extends StatelessWidget {
  const WalletInfo({
    super.key,
    required this.walletData,
    required this.width,
    required this.height,
  });

  final WalletData walletData;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatAmountFromDouble(
                      walletData.inShares + walletData.liquidity),
                  style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
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
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    color:
                        walletData.rate >= 0 ? Colors.lightGreen : Colors.red,
                  ),
                  child: Text('${walletData.rate}%'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'In shares: ${formatAmountFromDouble(walletData.inShares)} €',
            style: TextStyle(fontSize: width * 0.04),
          ),
          Text(
            'Liquidity: ${formatAmountFromDouble(walletData.liquidity)} €',
            style: TextStyle(fontSize: width * 0.04),
          ),
          SizedBox(
            height: height * 0.04,
          ),
        ],
      ),
    );
  }
}

class CustomBottomBigCard extends StatelessWidget {
  const CustomBottomBigCard({
    Key? key,
    required this.watchID,
    required this.screenWidth,
    required this.screenHeight,
    required this.walletWatch,
    required this.imgUrl,
  }) : super(key: key);

  final int watchID;
  final double screenWidth;
  final double screenHeight;
  final WalletWatch walletWatch;
  final Future<String> imgUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(WatchScreen.id,
            arguments: Watch(
              watchId: walletWatch.watchId,
              condition: walletWatch.condition,
              numberOfShares: walletWatch.numberOfShares,
              retailPrice: walletWatch.retailPrice,
              initialPrice: walletWatch.initialPrice,
              actualPrice: walletWatch.actualPrice,
              dialcolor: walletWatch.dialcolor,
              year: walletWatch.year,
              imageuri: walletWatch.imageuri,
              description: walletWatch.description,
              modelTypeId: walletWatch.modelTypeId,
              modelType: walletWatch.modelType,
            ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight*0.003),
        padding: EdgeInsets.symmetric(vertical: screenHeight*0.015),
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
                  SizedBox(height: screenWidth * 0.05),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      color: (walletWatch.increaseRate >= 0)
                          ? Colors.lightGreen
                          : Colors.red,
                    ),
                    child: Text('${walletWatch.increaseRate}%'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  walletWatch.modelType.model.brandname,
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Bebas',
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.5,
                  ),
                  child: Text(
                    walletWatch.modelType.model.modelname,
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
                    maxWidth: screenWidth*0.5,
                  ),
                  child: Text('Reference: ${walletWatch.modelType.reference}')),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.5,
                  ),
                  child: Text(
                      'Retail Price: ${formatAmountFromDouble(walletWatch.retailPrice)}€'),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                    'Owned Shares: ${walletWatch.owned}/${walletWatch.numberOfShares}'),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.5,
                  ),
                  child: Text(
                      'Retail Price: ${formatAmountFromDouble(walletWatch.retailPrice)}€'),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth*0.5,
                  ),
                  child: Text(
                      'Actual Price: ${formatAmountFromDouble(walletWatch.actualPrice)}€'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BlurFilter extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;

  const BlurFilter({
    required this.child,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX,
              sigmaY: sigmaY,
            ),
            child: Opacity(
              opacity: 0.01,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class RefreshingWalletData extends StatefulWidget {
  final WalletData walletData;
  final double width;
  final double height;

  const RefreshingWalletData({
    required this.walletData,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  _RefreshingWalletDataState createState() => _RefreshingWalletDataState();
}

class _RefreshingWalletDataState extends State<RefreshingWalletData> {
  bool isBlur = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Text(
                'Wallet value',
                style: TextStyle(fontSize: widget.width * 0.05),
              ),
              SizedBox(
                width: widget.width * 0.02,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isBlur = !isBlur;
                  });
                },
                icon: isBlur
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
            ],
          ),
        ),
        SizedBox(
          height: widget.height * 0.01,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletSpecsScreen(walletData: widget.walletData,),
              ),
            );
          },
          child: isBlur
              ? BlurFilter(
                  child: WalletInfo(
                    walletData: widget.walletData,
                    width: widget.width,
                    height: widget.height,
                  ),
                )
              : WalletInfo(
                  walletData: widget.walletData,
                  width: widget.width,
                  height: widget.height,
                ),
        ),
      ],
    );
  }
}
