import 'package:flutter/material.dart';
import 'package:lux_chain/screens/modify_on_sale_share.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/firestore.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharesScreen extends StatefulWidget {
  static const String id = 'HistoryScreen';
  const MySharesScreen({super.key});

  @override
  State<MySharesScreen> createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<MySharesScreen> {
  late Future<List<MySharesOnSale>> futureMySharesOnSale = Future.value([]);
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    Future<SharedPreferences> userFuture = getUserData();
    SharedPreferences user = await userFuture;

    int userId = user.getInt('accountid') ?? 0;

    setState(() {
      futureMySharesOnSale = getMySharesOnSale(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: heigh * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                  child: Text(
                    'Le mie quote in vendita',
                    style: TextStyle(
                        color: Colors.black87,
                        height: 1,
                        fontSize: width * 0.1,
                        fontFamily: 'Bebas'),
                  ),
                ),
                FutureBuilder<List<MySharesOnSale>>(
                  future: futureMySharesOnSale,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!
                            .map((myShare) => CustomCard(
                                  watchID: myShare.watchId,
                                  screenWidth: width,
                                  imgUrl: getDownloadURL(myShare.imageuri),
                                  modelName: myShare.modelName,
                                  brandName: myShare.brandName,
                                  reference: myShare.reference,
                                  onSaleAtPrice: myShare.onSaleAtPrice,
                                  sharesOwned: myShare.sharesOwned,
                                  sharesOnSale: myShare.sharesOnSale,
                                  price: myShare.price,
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return const SizedBox(); // Placeholder widget when no data is available
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.watchID,
    required this.screenWidth,
    required this.imgUrl,
    required this.modelName,
    required this.brandName,
    required this.reference,
    required this.onSaleAtPrice,
    required this.sharesOwned,
    required this.sharesOnSale,
    required this.price,
  });

  final int watchID;
  final double screenWidth;
  final String modelName;
  final String brandName;
  final Future<String> imgUrl;
  final String reference;
  final int onSaleAtPrice; // Shares on sale at this price
  final int sharesOwned; // Shares owned by the user
  final int sharesOnSale; // Shares on sale owned by the user
  final double price;

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
                    text: 'Modifica',
                    onPressed: () => {
                      Navigator.of(context).pushNamed(ModifyOnSaleShareScreen.id,
            arguments: ModifySharesOnSale(
              watchid: watchID,
              brandName: brandName,
              modelName: modelName,
              proposalPrice: price,
              onSaleAtPrice: onSaleAtPrice,
              sharesOwned: sharesOwned,
              sharesOnSale: sharesOnSale,
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
                modelName,
                style: TextStyle(
                  color: Colors.black38,
                  height: 1,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'Bebas',
                ),
              ),
              Text(
                brandName,
                style: TextStyle(
                  color: Colors.black87,
                  height: 1,
                  fontSize: screenWidth * 0.055,
                  fontFamily: 'Bebas',
                ),
              ),
              Text('Reference: $reference'),
                  Text('Serial: $watchID'),
                  SizedBox(height: screenWidth * 0.02),
                  Text('Quote in vendita: $onSaleAtPrice'),
                  Text('Prezzo quota: ' + formatAmountFromDouble(price) + '€'),
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
