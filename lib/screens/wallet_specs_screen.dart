import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';

class WalletSpecsScreen extends StatelessWidget {
  static const String id = 'WalletSpecsScreen';
  const WalletSpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
              right: width * 0.05, left: width * 0.05, top: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Wallet value',
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  const Icon(Icons.visibility),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '134 456.43',
                      style: TextStyle(
                          color: Colors.black87,
                          height: 1,
                          fontSize: width * 0.1,
                          fontWeight: FontWeight.bold),
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
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.lightGreen),
                      child: const Text('+ 2.3%'),
                    ),
                  ],
                ),
              ),
              Text(
                'In collezioni: 100 000.00 €',
                style: TextStyle(fontSize: width * 0.04),
              ),
              Text(
                'Liquidi: 34 456.43 €',
                style: TextStyle(fontSize: width * 0.04),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                child: Row(
                  children: [
                    Icon(
                      Icons.archive,
                      size: width * 0.08,
                    ),
                    Icon(
                      Icons.timelapse,
                      size: width * 0.08,
                    ),
                    Icon(
                      Icons.store,
                      size: width * 0.08,
                    ),
                    Icon(
                      Icons.star,
                      size: width * 0.08,
                    ),
                    Expanded(child: SizedBox(width: width * 0.08)),
                    Icon(Icons.arrow_outward_rounded, size: width * 0.08),
                    Icon(Icons.filter, size: width * 0.08),
                    Icon(Icons.search, size: width * 0.08),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
