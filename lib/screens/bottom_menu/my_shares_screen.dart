import 'package:flutter/material.dart';
import 'package:lux_chain/screens/modify_on_sale_share.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharesScreen extends StatefulWidget {
  static const String id = 'MySharesScreen';
  const MySharesScreen({Key? key}) : super(key: key);

  @override
  State<MySharesScreen> createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<MySharesScreen> {
  late Future<List<MySharesOnSale>> futureMySharesOnSale = Future.value([]);
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool isLastPage = false;
  int pageNumber = 1;
  final int watchPerPage = 10;
  late List<MySharesOnSale> _sharesOnSale;

  @override
  void initState() {
    super.initState();
    _sharesOnSale = [];
    _initializeData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() async {
    SharedPreferences user = await getUserData();
    int userId = user.getInt('accountid') ?? 0;

    List<MySharesOnSale> initialShares = await getMySharesOnSale(userId, pageNumber, watchPerPage);
    setState(() {
      _sharesOnSale = initialShares;
      futureMySharesOnSale = Future.value(_sharesOnSale);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingMore && !isLastPage) {
      _loadMoreShares();
    }
  }

  void _loadMoreShares() async {
    setState(() {
      isLoadingMore = true;
    });

    pageNumber++;

    SharedPreferences user = await getUserData();
    int userId = user.getInt('accountid') ?? 0;

    List<MySharesOnSale> newShares = await getMySharesOnSale(userId, pageNumber, watchPerPage);

    setState(() {
      if (newShares.isEmpty) {
        isLastPage = true;
      } else {
        _sharesOnSale.addAll(newShares);
        futureMySharesOnSale = Future.value(_sharesOnSale);
      }
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                child: Text(
                  'My Shares for Sale',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<MySharesOnSale>>(
                  future: futureMySharesOnSale,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && _sharesOnSale.isEmpty) {
                      return Container(
                        constraints: BoxConstraints(minHeight: height * 0.6, maxWidth: width),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<MySharesOnSale> mySharesOnSale = snapshot.data!;
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: mySharesOnSale.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == mySharesOnSale.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final myShare = mySharesOnSale[index];
                          return CustomCard(
                            watchID: myShare.watchId,
                            screenWidth: width,
                            myShare: myShare,
                            imgUrl: getDownloadURL(myShare.imageuri),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.watchID,
    required this.screenWidth,
    required this.myShare,
    required this.imgUrl,
  }) : super(key: key);

  final int watchID;
  final double screenWidth;
  final MySharesOnSale myShare;
  final Future<String> imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: Offset(3, 3),
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
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
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
                  text: 'Edit',
                  onPressed: () {
                    Navigator.of(context).pushNamed(ModifyOnSaleShareScreen.id,
                        arguments: ModifySharesOnSale(
                          watchid: watchID,
                          brandName: myShare.modelType.model.brandname,
                          modelName: myShare.modelType.model.modelname,
                          proposalPrice: myShare.price,
                          onSaleAtPrice: myShare.onSaleAtPrice,
                          sharesOwned: myShare.sharesOwned,
                          sharesOnSale: myShare.sharesOnSale,
                          image: imgUrl,
                        ));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                myShare.modelType.model.brandname,
                style: TextStyle(
                  color: Colors.black38,
                  height: 1,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'Bebas',
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.4,
                ),
                child: Text(
                  myShare.modelType.model.modelname,
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
                  maxWidth: screenWidth * 0.4,
                ),
                child: Text('Reference: ${myShare.modelType.reference}'),
              ),
              Text('Serial: $watchID'),
              SizedBox(height: screenWidth * 0.02),
              Text('Shares for Sale: ${myShare.sharesOnSale}'),
              Text('At this price: ${myShare.onSaleAtPrice}'),
              Text('Share price: ${formatAmountFromDouble(myShare.price)}'),
            ],
          ),
        ],
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

