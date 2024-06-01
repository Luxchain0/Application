import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Aggiunto l'import per utilizzare http.post
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';

class ReportBugScreen extends StatelessWidget {
  static const String id = 'ReportBugScreen';
  final TextEditingController reportController = TextEditingController();

  ReportBugScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                  submitBugReport(reportController
                      .text, context); // Chiamata alla funzione per inviare il report
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

  void submitBugReport(String bugDescription, BuildContext context) async {
    final response = await http.post(
      Uri.parse("$URL/report"),
      body: {'message': bugDescription},
    );

    if (response.statusCode == 200) {
      // Successo
      // Mostra un messaggio di conferma
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bug Reported'),
            content: const Text('Thank you for reporting the bug!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Errore
      // Mostra un messaggio di errore
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to report the bug. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
