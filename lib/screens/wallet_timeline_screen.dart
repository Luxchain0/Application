import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/frame.dart';

class WalletTimelineScreen extends StatefulWidget {
  static const String id = 'WalletTimelineScreen';
  const WalletTimelineScreen({super.key});

  @override
  State<WalletTimelineScreen> createState() => _WalletTimelineScreenState();
}

class _WalletTimelineScreenState extends State<WalletTimelineScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: heigh * 0.01),
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
                height: heigh * 0.08,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
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
