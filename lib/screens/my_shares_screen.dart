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
              'My shares on sale',
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
              child: MySharesOnSaleCardsView(
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

class MySharesOnSaleCardsView extends StatefulWidget {
  final double width;
  final double height;

  const MySharesOnSaleCardsView({
    required this.width,
    required this.height,
    super.key,
  });

  @override
  _MySharesOnSaleCardsViewState createState() =>
      _MySharesOnSaleCardsViewState();
}

class _MySharesOnSaleCardsViewState extends State<MySharesOnSaleCardsView> {
  late bool _isLastPage;
  late int _pageNumber = 1;
  late bool _isError;
  late bool _isLoading;
  final int _numberOfSharesPerRequest = 3;
  late List<MySharesOnSale> _shares;
  final int _nextPageTrigger = 0;

  @override
  void initState() {
    super.initState();
    _shares = [];
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
      print('object per request: $_numberOfSharesPerRequest');
      List<MySharesOnSale> req = await getMySharesOnSale(
          userId, _pageNumber, _numberOfSharesPerRequest);
      for (var element in req) {
        print('watchID: ${element.watchId}');
      }

      if (mounted) {
        print(_shares.length.toString());
        setState(() {
          _shares.addAll(req);
          _isLastPage = req.length < _numberOfSharesPerRequest;
          _isLoading = false;
          _pageNumber += 1;
        });
        print(_shares.length.toString());
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
    return _shares.isEmpty ? _buildEmptyListView() : _buildListView();
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
      itemCount: _shares.length + (_isLastPage ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == _shares.length - _nextPageTrigger && !_isLastPage) {
          fetchData();
        }
        if (index == _shares.length) {
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
        final MySharesOnSale share = _shares[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: CustomCard(
            watchID: share.watchId,
            screenWidth: widget.width,
            myShare: share,
            imgUrl: getDownloadURL(share.imageuri),
          ),
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.watchID,
    required this.screenWidth,
    required this.myShare,
    required this.imgUrl,
  });

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
                SizedBox(height: screenWidth * 0.02),
                CustomButton(
                  screenWidth: screenWidth,
                  backgorundColor: const Color.fromARGB(255, 17, 45, 68),
                  textColor: Colors.white,
                  text: 'Edit',
                  onPressed: () => {
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
                        ))
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
                  child: Text('Reference: ${myShare.modelType.reference}')),
              Text('Serial: $watchID'),
              SizedBox(height: screenWidth * 0.02),
              Text('Shares on Sale: ${myShare.sharesOnSale}'),
              Text('At this price: ${myShare.onSaleAtPrice}'),
              Text('Share price: ${formatAmountFromDouble(myShare.price)}€'),
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
