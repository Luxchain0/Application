import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/screens/buy_screen.dart';
import 'package:lux_chain/screens/chart_card.dart';
import 'package:lux_chain/screens/sell_screen.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/utils.dart';

class WatchScreen extends StatefulWidget {
  static const String id = 'WatchScreen';
  final Watch watch;

  const WatchScreen({required this.watch, Key? key}) : super(key: key);

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late Future<List<ShareOnSale>> futureSharesData = Future.value([]);
  late int sharesOwned = 0;
  late double increaseRate = 0;
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = await getUserData();
    final userId = user.getInt('accountid') ?? 0;

    futureSharesData = getSharesOfTheWatchOnSell(widget.watch.watchId, userId);
    final additionalData =
        await getWatchAdditionalData(userId, widget.watch.watchId);
    setState(() {
      sharesOwned = additionalData.sharesOwned;
      increaseRate = additionalData.increaseRate;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    final double height = SizeConfig.screenH!;
    final double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildWatchInfo(),
                      SizedBox(height: height * 0.02),
                      _buildImageContainer(height),
                      SizedBox(height: height * 0.02),
                      _buildDescription(),
                      SizedBox(height: height * 0.03),
                      SizedBox(height: height * 0.01),
                      Column(
                        children: [
                          ChartCard(
                            isShowingMainData: false,
                            watchId: widget.watch.watchId,
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      if (sharesOwned > 0) _buildSellButton(),
                      SizedBox(height: height * 0.02),
                      _buildBestSharesForSale(),
                      SizedBox(height: height * 0.02),
                      _buildSharesOnSaleList(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildWatchInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.watch.modelType.model.brandname,
              style: TextStyle(
                color: Colors.black38,
                height: 1,
                fontSize: SizeConfig.screenW! * 0.07,
                fontFamily: 'Bebas',
              ),
            ),
            Text(
              widget.watch.modelType.model.modelname,
              style: TextStyle(
                color: Colors.black87,
                height: 1,
                fontSize: SizeConfig.screenW! * 0.08,
                fontFamily: 'Bebas',
              ),
            ),
          ],
        ),
        RefreshingButton(watchID: widget.watch.watchId),
      ],
    );
  }

  Widget _buildImageContainer(double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: FutureBuilder<String>(
        future: getDownloadURL(widget.watch.imageuri),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              child: Image.network(
                snapshot.data!,
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
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reference: ${widget.watch.modelType.reference}"),
        Text("Serial: ${widget.watch.watchId}"),
        Text("Year: ${widget.watch.year}"),
        Text("Case material: ${widget.watch.modelType.casematerial}"),
        Text("Bracelet material: ${widget.watch.modelType.braceletmaterial}"),
        Text(
            "Retail Price: ${formatAmountFromDouble(widget.watch.retailPrice)}"),
        Text(
            'Actual Price: ${formatAmountFromDouble(widget.watch.actualPrice)}'),
        Text("Conditions: ${widget.watch.condition}"),
        Text("Shares: ${widget.watch.numberOfShares}"),
        RefreshingAdditionalData(
            sharesOwned: sharesOwned, increaseRate: increaseRate),
        SizedBox(height: SizeConfig.screenW! * 0.05),
        const Text('Description:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(widget.watch.description, textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _buildSellButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            SellScreen.id,
            arguments: SellInfo(
              watchid: widget.watch.watchId,
              brandName: widget.watch.modelType.model.brandname,
              modelName: widget.watch.modelType.model.modelname,
              actualPrice: widget.watch.actualPrice,
              sharesOwned: sharesOwned,
              image: getDownloadURL(widget.watch.imageuri),
              proposalPrice: widget.watch.actualPrice,
              numberOfShares: widget.watch.numberOfShares,
            ),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.blueAccent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            minimumSize: MaterialStateProperty.all<Size>(
                Size(SizeConfig.screenW! * 0.25, SizeConfig.screenW! * 0.08)),
          ),
          child: const Text('Sell'),
        ),
      ],
    );
  }

  Widget _buildBestSharesForSale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Best shares for sale:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.screenH! * 0.02),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text('Price share', textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                child: Text('n° shares', textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSharesOnSaleList() {
    return FutureBuilder<List<ShareOnSale>>(
      future: futureSharesData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<ShareOnSale> sharesOnSale = snapshot.data!;
          return sharesOnSale.isNotEmpty
              ? Column(
                  children: sharesOnSale.map(
                    (share) {
                      return CustomRowForQuote(
                        width: SizeConfig.screenW!,
                        numberOfQuotes: share.shareCount,
                        quotePrice: share.price,
                        buyInfo: BuyInfo(
                          watchid: widget.watch.watchId,
                          brandName: widget.watch.modelType.model.brandname,
                          modelName: widget.watch.modelType.model.modelname,
                          actualPrice: widget.watch.actualPrice,
                          sharesOnSale: widget.watch.numberOfShares,
                          image: getDownloadURL(widget.watch.imageuri),
                          proposalPrice: share.price,
                          numberOfShares: share.shareCount,
                        ),
                      );
                    },
                  ).toList(),
                )
              : const SizedBox();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class CustomRowForQuote extends StatelessWidget {
  final double width;
  final double quotePrice;
  final int numberOfQuotes;
  final BuyInfo buyInfo;

  const CustomRowForQuote({
    required this.width,
    required this.numberOfQuotes,
    required this.quotePrice,
    required this.buyInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  formatAmountFromDouble(quotePrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            numberOfQuotes.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomButton(
            screenWidth: width,
            backgroundColor: const Color.fromARGB(255, 17, 45, 68),
            textColor: Colors.white,
            text: 'Buy',
            buyInfo: buyInfo,
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final double screenWidth;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final BuyInfo buyInfo;

  const CustomButton({
    required this.screenWidth,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    required this.buyInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () =>
          Navigator.pushNamed(context, BuyScreen.id, arguments: buyInfo),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        foregroundColor: MaterialStateProperty.all<Color>(textColor),
        minimumSize: MaterialStateProperty.all<Size>(
            Size(screenWidth * 0.05, screenWidth * 0.08)),
        maximumSize: MaterialStateProperty.all<Size>(
            Size(screenWidth * 0.05, screenWidth * 0.08)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RefreshingButton extends StatefulWidget {
  final int watchID;

  const RefreshingButton({required this.watchID, Key? key}) : super(key: key);

  @override
  _RefreshingButtonState createState() => _RefreshingButtonState();
}

class _RefreshingButtonState extends State<RefreshingButton> {
  late Future<bool> isFavourite = Future.value(false);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = await getUserData();
    final userId = user.getInt('accountid') ?? 0;

    setState(() {
      isFavourite = getFavorite(userId, widget.watchID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final user = await getUserData();
        final userId = user.getInt('accountid') ?? 0;
        final isFav = await isFavourite;
        if (isFav) {
          final removeStatus =
              await removeFromFavourite(userId, widget.watchID);
          if (removeStatus == APIStatus.success) {
            setState(() {
              isFavourite = Future.value(false);
            });
          }
        } else {
          final addStatus = await addToFavourite(userId, widget.watchID);
          if (addStatus == APIStatus.success) {
            setState(() {
              isFavourite = Future.value(true);
            });
          }
        }
      },
      icon: FutureBuilder<bool>(
        future: isFavourite,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final isFav = snapshot.data!;
            return Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_outlined,
              color: Colors.red,
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.error);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class RefreshingAdditionalData extends StatelessWidget {
  final int sharesOwned;
  final double increaseRate;

  const RefreshingAdditionalData({
    required this.sharesOwned,
    required this.increaseRate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shares owned: $sharesOwned"),
        Row(
          children: [
            const Text('Rate: '),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: increaseRate >= 0 ? Colors.lightGreen : Colors.red,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${increaseRate >= 0 ? '+' : ''}$increaseRate%',
                    style:
                        const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.public,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
