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

  @override
  void initState() {
    super.initState();
    futureMarketPlaceWatches = getMarketPlaceWatches();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            height: heigh * 0.02,
          ),
          TextFormField(
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                suffixIcon: Icon(Icons.search),
                alignLabelWithHint: true,
                labelText: 'Insert the name of the watch'),
          ),
          SizedBox(height: heigh*0.02,),
          FutureBuilder<List<MarketPlaceWatch>>(
            future: futureMarketPlaceWatches,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MarketPlaceWatch> marketWatchesList = snapshot.data!;
                return Column(
                  children: marketWatchesList
                      .map((watch) => CustomBottomBigCard(
                          screenWidth: width,
                          watchid: watch.watchId,
                          imgFuture: getDownloadURL(watch.imageuri),
                          modelName: watch.modelType.model.modelname,
                          brandName: watch.modelType.model.brandname,
                          serialNumber: watch.watchId.toString(),
                          prezzoDiListino: watch.initialPrice.toInt(),
                          quoteTotali: watch.numberOfShares,
                          pezziDisponibili: watch.sharesOnSale,
                          incremento: 0))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
      
              return const CircularProgressIndicator();
            },
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
    required this.screenWidth,
    required this.watchid,
    required this.imgFuture,
    required this.modelName,
    required this.brandName,
    required this.serialNumber,
    required this.prezzoDiListino,
    required this.quoteTotali,
    required this.pezziDisponibili,
    required this.incremento,
  }) : super(key: key);

  final double screenWidth;
  final int watchid;
  final String modelName;
  final String brandName;
  final Future<String> imgFuture;
  final String serialNumber;
  final int prezzoDiListino;
  final int quoteTotali;
  final int pezziDisponibili;
  final double incremento;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(WatchScreen.id, arguments: watchid),
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
                    text: 'Dettagli',
                    onPressed: () => Navigator.pushNamed(
                        context, WatchScreen.id,
                        arguments: watchid),
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
              Text('Serial: $serialNumber'),
              SizedBox(height: screenWidth * 0.02),
              Text('Prezzo di listino: ' + formatAmountFromInt(prezzoDiListino) + '€'),
              Text('Quote totali: $quoteTotali'),
              Text('Quote disponibili: $pezziDisponibili'),
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
