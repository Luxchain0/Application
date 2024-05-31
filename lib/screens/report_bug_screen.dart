// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';

class ReportBugScreen extends StatelessWidget {
  static const String id = 'ReportBugScreen';
  final TextEditingController reportController = TextEditingController();

  ReportBugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
//    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: width,
              child: Text(
                'Report a bug',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Bebas',
                  fontSize: width * 0.1,
                ),
              ),
            ),
            const Text(
              'Describe the bug',
              style: kLabelStyle,
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: reportController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    hintText: 'Describe the bug',
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //api all
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
